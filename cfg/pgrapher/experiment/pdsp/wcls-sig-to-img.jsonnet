local sig_input_label = std.extVar("sig_input_label");
local use_blob_reframer = std.extVar("use_blob_reframer");

local wc = import 'wirecell.jsonnet';
local g = import 'pgraph.jsonnet';
local magoutput = 'magnify_output.root';


local params = import 'params.jsonnet';
local tools_maker = import 'pgrapher/common/tools.jsonnet';
local tools = tools_maker(params);
local img = import "pgrapher/experiment/pdsp/img.jsonnet";
local multimagnify = import 'pgrapher/experiment/pdsp/multimagnify.jsonnet';
local multi_magnify6 = multimagnify('roi', tools, magoutput);
local magnify_pipes6 = multi_magnify6.magnify_pipelines;

local nanodes = std.length(tools.anodes);
local anode_iota = std.range(0, nanodes-1);

// tag placed on the signal frame.
local signal_frame_tags = ["sig"];

// must match name used in fcl
local wcls_input = g.pnode({
    type: 'wclsCookedFrameSource',
    name: 'sigs',
    data: {
        art_tag: sig_input_label,
        frame_tags: signal_frame_tags,
    },
}, nin=0, nout=1);

local frameio = g.pnode({
    type: "NumpyFrameSaver",
    name: 'signal',
    data: {
        filename: "wcls-sig-to-img.npz",
        frame_tags: signal_frame_tags
    }
}, nin=1, nout=1);
local input = g.intern(innodes=[wcls_input], centernodes=[], outnodes=[frameio],
                       edges=[g.edge(wcls_input, frameio)]);


local fansel = g.pnode({
    type: "ChannelSplitter",
    name: "peranode",
    data: {
        anodes: [wc.tn(a) for a in tools.anodes],
        tag_rules: [{
            frame: {
                '.*': 'orig%d'%ind,
            },
        } for ind in anode_iota],
    },
}, nin=1, nout=nanodes, uses=tools.anodes);

local roi_filter = [g.pnode({
type: 'RegionOfInterestFilter',  //parameter to configure the node (type and name pair should be unique)
name: 'roi_filter%d' % n,
data: {
  roi_tag: 'roi%d' % n,
  old_tag: 'oriv%d' % n
}, 
}, nin=1, nout=1, uses=[]),
for n in std.range(0, std.length(tools.anodes) - 1) //tools.anodes sono le linee parallele del grafico
]; 

local perapa_pipelines = [
    g.pipeline([
        img.slicing(anode, anode.name),
        img.tiling(anode, anode.name),
        img.solving(anode, anode.name),
        // img.clustering(anode, anode.name),
      ]

      + if use_blob_reframer=="true" then [
        img.reframing(anode, anode.name),
        img.magnify(anode, anode.name, "reframe"),
        img.dumpframes(anode, anode.name),
        roi_filter[anode],
        magnify_pipes6[anode],
      ] else [
        img.dump(anode, anode.name, params.lar.drift_speed),
        roi_filter[anode],
        magnify_pipes6[anode],
      ], 
      "img-" + anode.name) for anode in tools.anodes];

local graph = g.intern(innodes=[input],
                       centernodes = [fansel] + perapa_pipelines,
                       outnodes=[],
                       edges=[g.edge(input, fansel)] +
                       [g.edge(fansel, perapa_pipelines[ind], ind, 0) for ind in anode_iota]);

local app = {
  type: 'Pgrapher',
  data: {
      edges: g.edges(graph)
  },
};


g.uses(graph) + [app]


