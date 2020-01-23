// This is a main entry point for configuring a wire-cell CLI job to
// simulate ICARUS.  It is simplest signal-only simulation with
// one set of nominal field response function.

local g = import 'pgraph.jsonnet';
local f = import 'pgrapher/common/funcs.jsonnet';
local wc = import 'wirecell.jsonnet';

local io = import 'pgrapher/common/fileio.jsonnet';
local tools_maker = import 'pgrapher/common/tools.jsonnet';
local params = import 'pgrapher/experiment/icarus/simparams.jsonnet';

local tools = tools_maker(params);

local sim_maker = import 'pgrapher/experiment/icarus/sim.jsonnet';
local sim = sim_maker(params, tools);

local stubby = {
  tail: wc.point(-3000, 0, -9100, wc.mm),
  head: wc.point(-3000, 0, 8800, wc.mm),
};

local tracklist = [

  {
    time: 0 * wc.us,
    charge: -5000, // 5000 e/mm
    ray: params.det.bounds,
  },

];

local depos = sim.tracks(tracklist, step=1.0 * wc.mm);

// local output = 'wct-sim-ideal-sig.npz';
// local deposio = io.numpy.depos(output);
local drifter = sim.drifter;
local bagger = sim.make_bagger();
// signal plus noise pipelines
// local sn_pipes = sim.splusn_pipelines;
// signal only pipeline
// local sn_pipes = sim.signal_pipelines;

local nanodes = std.length(tools.anodes);
local anode_iota = std.range(0, nanodes-1);
local anode_idents = [anode.data.ident for anode in tools.anodes];

local perfect = import 'pgrapher/experiment/icarus/chndb-base.jsonnet';
local chndb = [{
  type: 'OmniChannelNoiseDB',
  name: 'ocndbperfect%d' % n,
  data: perfect(params, tools.anodes[n], tools.field, n),
  uses: [tools.anodes[n], tools.field],  // pnode extension
} for n in anode_iota];

// local nf_maker = import 'pgrapher/experiment/pdsp/nf.jsonnet';
// local nf_pipes = [nf_maker(params, tools.anodes[n], chndb[n], n, name='nf%d' % n) for n in std.range(0, std.length(tools.anodes) - 1)];

local sp_maker = import 'pgrapher/experiment/icarus/sp.jsonnet';
local sp = sp_maker(params, tools);
local sp_pipes = [sp.make_sigproc(a) for a in tools.anodes];

// fixme: see https://github.com/WireCell/wire-cell-gen/issues/29
local mega_anode = {
  type: 'MegaAnodePlane',
  name: 'meganodes',
  data: {
    anodes_tn: [wc.tn(anode) for anode in tools.anodes],
  },
};
local make_noise_model = function(anode, csdb=null) {
    type: "EmpiricalNoiseModel",
    name: "empericalnoise-" + anode.name,
    data: {
        anode: wc.tn(anode),
        chanstat: if std.type(csdb) == "null" then "" else wc.tn(csdb),
        spectra_file: params.files.noise,
        nsamples: params.daq.nticks,
        period: params.daq.tick,
        wire_length_scale: 1.0*wc.cm, // optimization binning
    },
    uses: [anode] + if std.type(csdb) == "null" then [] else [csdb],
};
local noise_model = make_noise_model(mega_anode);
local add_noise = function(model) g.pnode({
    type: "AddNoise",
    name: "addnoise-" + model.name,
    data: {
        rng: wc.tn(tools.random),
        model: wc.tn(model),
        nsamples: params.daq.nticks,
        replacement_percentage: 0.02, // random optimization
    }}, nin=1, nout=1, uses=[model]);
local noise = add_noise(noise_model);

local digitizer = sim.digitizer(mega_anode, name="digitizer", tag="orig");


local fansel = g.pnode({
    type: "ChannelSplitter",
    name: "peranode",
    data: {
        anodes: [wc.tn(a) for a in tools.anodes],
        tag_rules: [{
            frame: {
                '.*': 'orig%d'%ind,
            },
        } for ind in anode_idents/*anode_iota*/],
    },
}, nin=1, nout=nanodes, uses=tools.anodes);

local magoutput = 'icarus-sim-check.root';
local magnify = import 'pgrapher/experiment/icarus/magnify-sinks.jsonnet';
local magnifyio = magnify(tools, magoutput);

local pipelines = [
    g.pipeline([
        magnifyio.orig_pipe[n],

        // nf_pipes[n],
        // magnifyio.raw_pipe[n],

        sp_pipes[n],
        magnifyio.decon_pipe[n],
        // magnifyio.threshold_pipe[n],
        // magnifyio.debug_pipe[n], // use_roi_debug_mode=true in sp.jsonnet
    ],
               'nfsp_pipe_%d' % n)
    for n in anode_iota
    ];

local fanin = g.pnode({
    type: 'FrameFanin',
    name: 'sigmerge',
    data: {
        multiplicity: nanodes,
        tags: [],
        tag_rules: [{
            trace: {
                ['gauss%d'%ind]:'gauss%d'%ind,
                ['wiener%d'%ind]:'wiener%d'%ind,
                ['threshold%d'%ind]:'threshold%d'%ind,
            },
        } for ind in anode_iota],
    },
}, nin=nanodes, nout=1);

local retagger = g.pnode({
    type: 'Retagger',
    data: {
        // Note: retagger keeps tag_rules in an array to be like frame
        // fanin/fanout but only uses first element.
        tag_rules: [{
            // Retagger also handles "frame" and "trace" like
            // fanin/fanout and also "merge" separately all traces
            // like gaussN to gauss.
            frame: {
                '.*': 'retagger',
            },
            merge: {
                'gauss\\d': 'gauss',
                'wiener\\d': 'wiener',
            },
        }],
    },
}, nin=1, nout=1);

local fanpipe = g.intern(innodes=[fansel],
                         outnodes=[fanin],
                         centernodes=pipelines,
                         edges=
                         [g.edge(fansel, pipelines[n], n, 0) for n in anode_iota] +
                         [g.edge(pipelines[n], fanin, 0, n) for n in anode_iota],
                         name="fanpipe");

//local frameio = io.numpy.frames(output);
local sink = sim.frame_sink;

local graph = g.pipeline([depos, drifter, bagger, sim.analog, noise, digitizer, fanpipe, retagger, sink]);

local app = {
  type: 'Pgrapher',
  data: {
    edges: g.edges(graph),
  },
};

local cmdline = {
    type: "wire-cell",
    data: {
        plugins: ["WireCellGen", "WireCellPgraph", "WireCellSio", "WireCellSigProc", "WireCellRoot"],
        apps: ["Pgrapher"]
    }
};


// Finally, the configuration sequence which is emitted.

[cmdline] + g.uses(graph) + [app]
