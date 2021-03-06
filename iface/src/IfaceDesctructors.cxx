// https://github.com/WireCell/wire-cell-iface/issues/5

#include "WireCellIface/IWireParameters.h"
#include "WireCellIface/IAnodeFace.h"
#include "WireCellIface/IAnodePlane.h"
#include "WireCellIface/IApplication.h"
#include "WireCellIface/IBlob.h"
#include "WireCellIface/IBlobSet.h"
#include "WireCellIface/IBlobSetFanin.h"
#include "WireCellIface/IBlobSetFanout.h"
#include "WireCellIface/IBlobSetSink.h"
#include "WireCellIface/IChannelFilter.h"
#include "WireCellIface/IChannelNoiseDatabase.h"
#include "WireCellIface/IChannelResponse.h"
#include "WireCellIface/IChannelSpectrum.h"
#include "WireCellIface/IChannelStatus.h"
#include "WireCellIface/ICluster.h"
#include "WireCellIface/IClusterFanin.h"
#include "WireCellIface/IClusterFilter.h"
#include "WireCellIface/IClusterFramer.h"
#include "WireCellIface/IClustering.h"
#include "WireCellIface/IClusterSink.h"
#include "WireCellIface/IConfigurable.h"
#include "WireCellIface/IDataFlowGraph.h"
#include "WireCellIface/IDeconvolution.h"
#include "WireCellIface/IDepo.h"
#include "WireCellIface/IDepoCollector.h"
#include "WireCellIface/IDepoFanout.h"
#include "WireCellIface/IDepoFilter.h"
#include "WireCellIface/IDepoFramer.h"
#include "WireCellIface/IDepoMerger.h"
#include "WireCellIface/IDepoSet.h"
#include "WireCellIface/IDepoSetFanout.h"
#include "WireCellIface/IDepoSink.h"
#include "WireCellIface/IDepoSource.h"
#include "WireCellIface/IDiffusion.h"
#include "WireCellIface/IDiffuser.h"
#include "WireCellIface/IDrifter.h"
#include "WireCellIface/IDuctor.h"
#include "WireCellIface/IFaninNode.h"
#include "WireCellIface/IFanoutNode.h"
#include "WireCellIface/IFieldResponse.h"
#include "WireCellIface/IFilterWaveform.h"
#include "WireCellIface/IFrame.h"
#include "WireCellIface/IFrameFanin.h"
#include "WireCellIface/IFrameFanout.h"
#include "WireCellIface/IFrameFilter.h"
#include "WireCellIface/IFrameJoiner.h"
#include "WireCellIface/IFrameSink.h"
#include "WireCellIface/IFrameSlicer.h"
#include "WireCellIface/IFrameSlices.h"
#include "WireCellIface/IFrameSource.h"
#include "WireCellIface/IFrameSplitter.h"
#include "WireCellIface/IFunctionNode.h"
#include "WireCellIface/IHydraNode.h"
#include "WireCellIface/IJoinNode.h"
#include "WireCellIface/INode.h"
#include "WireCellIface/IPlaneImpactResponse.h"
#include "WireCellIface/IPointFieldSink.h"
#include "WireCellIface/IProcessor.h"
#include "WireCellIface/IQueuedoutNode.h"
#include "WireCellIface/IQueuedoutNode.h"
#include "WireCellIface/IRandom.h"
#include "WireCellIface/IRecombinationModel.h"
#include "WireCellIface/IScalarFieldSink.h"
#include "WireCellIface/ISequence.h"
#include "WireCellIface/ISinkNode.h"
#include "WireCellIface/ISourceNode.h"
#include "WireCellIface/ISlice.h"
#include "WireCellIface/ISliceFanout.h"
#include "WireCellIface/ISliceFrame.h"
#include "WireCellIface/ISliceFrameSink.h"
#include "WireCellIface/ISliceStriper.h"
#include "WireCellIface/ISplitNode.h"
#include "WireCellIface/IStripe.h"
#include "WireCellIface/IStripeSet.h"
#include "WireCellIface/ITerminal.h"
#include "WireCellIface/ITensorSetFilter.h"
#include "WireCellIface/ITiling.h"
#include "WireCellIface/ITrace.h"
#include "WireCellIface/IWaveform.h"
#include "WireCellIface/IWireGenerator.h"
#include "WireCellIface/IWireSchema.h"
#include "WireCellIface/IWireSource.h"
#include "WireCellIface/IWireSummarizer.h"
#include "WireCellIface/IWireSummary.h"
#include "WireCellIface/SimpleDepoSet.h"
#include "WireCellIface/SimpleWire.h"
#include "WireCellIface/SimpleBlob.h"


using namespace WireCell;

IWireParameters::~IWireParameters() { }
IAnodeFace::~IAnodeFace() {}
IAnodePlane::~IAnodePlane() {}
IApplication::~IApplication() {}
IBlob::~IBlob() {}
IBlobSet::~IBlobSet() {}
IBlobSetFanin::~IBlobSetFanin() {}
IBlobSetFanout::~IBlobSetFanout() {}
IBlobSetSink::~IBlobSetSink() {}
IChannelFilter::~IChannelFilter() {}
IChannelNoiseDatabase::~IChannelNoiseDatabase() {}
IChannelResponse::~IChannelResponse() {}
IChannelSpectrum::~IChannelSpectrum() {}
IChannelStatus::~IChannelStatus() {}
ICluster::~ICluster() {}
IClusterFanin::~IClusterFanin() {}
IClusterFilter::~IClusterFilter() {}
IClusterFramer::~IClusterFramer() {}
IClustering::~IClustering() {}
IClusterSink::~IClusterSink() {}
IConfigurable::~IConfigurable() {}
IDataFlowGraph::~IDataFlowGraph() {}
IDeconvolution::~IDeconvolution() {}
IDepo::~IDepo() {}
IDepoCollector::~IDepoCollector() {}
IDepoFanout::~IDepoFanout() {}
IDepoFilter::~IDepoFilter() {}
IDepoFramer::~IDepoFramer() {}
IDepoMerger::~IDepoMerger() {}
IDepoSet::~IDepoSet() {}
IDepoSetFanout::~IDepoSetFanout() {}
IDepoSink::~IDepoSink() {}
IDepoSource::~IDepoSource() {}
IDiffusion::~IDiffusion() {}
IDiffuser::~IDiffuser() {}
IDrifter::~IDrifter() {}
IDuctor::~IDuctor() {}
IFaninNodeBase::~IFaninNodeBase() {}
IFanoutNodeBase::~IFanoutNodeBase() {}
IFieldResponse::~IFieldResponse() {}
IFilterWaveform::~IFilterWaveform() {}
IFrame::~IFrame() {}
IFrameFanin::~IFrameFanin() {}
IFrameFanout::~IFrameFanout() {}
IFrameFilter::~IFrameFilter() {}
IFrameJoiner::~IFrameJoiner() {}
IFrameSink::~IFrameSink() {}
IFrameSlicer::~IFrameSlicer() {}
IFrameSlices::~IFrameSlices() {}
IFrameSource::~IFrameSource() {}
IFrameSplitter::~IFrameSplitter() {}
IFunctionNodeBase::~IFunctionNodeBase() {}
IHydraNodeBase::~IHydraNodeBase() {}
IJoinNodeBase::~IJoinNodeBase() {}
INode::~INode(){}
IImpactResponse::~IImpactResponse() {}
IPlaneImpactResponse::~IPlaneImpactResponse() {}
IPointFieldSink::~IPointFieldSink() {}
IProcessor::~IProcessor() { }
IQueuedoutNodeBase::~IQueuedoutNodeBase() {}
IRandom::~IRandom() {}
IRecombinationModel::~IRecombinationModel() {}
IScalarFieldSink::~IScalarFieldSink() {}
ISinkNodeBase::~ISinkNodeBase() {}
ISlice::~ISlice() {}
ISliceFanout::~ISliceFanout() {}
ISliceFrame::~ISliceFrame() {}
ISliceFrameSink::~ISliceFrameSink() {}
ISliceStriper::~ISliceStriper() {}
ISourceNodeBase::~ISourceNodeBase() {}
ISplitNodeBase::~ISplitNodeBase() {}
IStripe::~IStripe() {}
IStripeSet::~IStripeSet() {}
ITerminal::~ITerminal() {}
ITensorSetFilter::~ITensorSetFilter() {}
ITiling::~ITiling() {}
ITrace::~ITrace() {}
IWaveform::~IWaveform() {}
IWireGenerator::~IWireGenerator() {}
IWireSchema::~IWireSchema() {}
IWireSource::~IWireSource() {}
IWireSummarizer::~IWireSummarizer() {}
IWireSummary::~IWireSummary() {}
SimpleDepoSet::~SimpleDepoSet() {}
SimpleWire::~SimpleWire() {}
SimpleBlob::~SimpleBlob() {}
SimpleBlobSet::~SimpleBlobSet() {}
