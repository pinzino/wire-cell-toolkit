// Here we override params.jsonnet to provide simulation-specific params.

local base = import 'pgrapher/experiment/icarus/params.jsonnet';
local wc = import 'wirecell.jsonnet';

base {
  lar: super.lar {
      // be sure you really want to have this. default value: 8 ms
      lifetime: 35.0*wc.ms,
  },
  daq: super.daq {

    // Number of readout ticks.  See also sim.response.nticks.
    // In MB LArSoft simulation, they expect a different number of
    // ticks than acutal data.
    // nticks: 4096,
  },

  sim: super.sim {

    // For running in LArSoft, the simulation must be in fixed time mode.
    fixed: true,
    continuous: false,
    fluctuate: true,

    //ductor : super.ductor {
    //    start_time: $.daq.start_time - $.elec.fields.drift_dt + $.trigger.time,
    //},

  },

  //files: super.files{
  //    chresp: null,
  //},

  // This sets a relative gain at the input to the ADC.  Note, if
  // you are looking to fix SimDepoSource, you are in the wrong
  // place.  See the "scale" parameter of wcls.input.depos() defined
  // in pgrapher/common/ui/wcls/nodes.jsonnet.
  elec: super.elec {
    postgain: 1.0,
    shaping: 2.2 * wc.us,
  },

  sys_status: false,
  sys_resp: {
    // overall_short_padding should take into account this offset "start".
    start: -10 * wc.us,
    magnitude: 1.0,
    time_smear: 1.0 * wc.us,
  },

  rc_resp: {
    width: 1.1*wc.ms,
    rc_layers: 1,
  }
}
