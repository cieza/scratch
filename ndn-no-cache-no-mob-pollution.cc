/* -*- Mode: C++; c-file-style: "gnu"; indent-tabs-mode:nil -*- */
/*
 * Copyright (c) 2012-2013 University of California, Los Angeles
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation;
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 * Author: Alexander Afanasyev <alexander.afanasyev@ucla.edu>
 */

#include "ns3/core-module.h"
#include "ns3/network-module.h"
#include "ns3/applications-module.h"
#include "ns3/wifi-module.h"
#include "ns3/mobility-module.h"
#include "ns3/internet-module.h"

#include "ns3/ndnSIM-module.h"

using namespace std;
using namespace ns3;

NS_LOG_COMPONENT_DEFINE ("ndn.WifiExample");

//////////////////////////////////////////////////////////////////////////
//
// Modificado em outubro 2014 por Elise G Cieza
//
//////////////////////////////////////////////////////////////////////////

int
main (int argc, char *argv[])
{

  uint32_t numberOfNodes = 50;

  if(argc > 1)
  {
     numberOfNodes = atoi(argv[1]);
     //cout<<"Numero: "<<atoi(argv[1])<<"\n";
     //cout<<"Primeiro parametro: "<<argv[0]<<"\n";
  }

  // disable fragmentation
  Config::SetDefault ("ns3::WifiRemoteStationManager::FragmentationThreshold", StringValue ("2200"));
  Config::SetDefault ("ns3::WifiRemoteStationManager::RtsCtsThreshold", StringValue ("2200"));
  Config::SetDefault ("ns3::WifiRemoteStationManager::NonUnicastMode", StringValue ("OfdmRate24Mbps"));

  CommandLine cmd;
  cmd.Parse (argc,argv);

//--------------------------------------------------------------------------
//
// Configurando Wifi
//
//--------------------------------------------------------------------------


  WifiHelper wifi = WifiHelper::Default ();
  //wifi.SetRemoteStationManager ("ns3::AarfWifiManager");
  wifi.SetStandard (WIFI_PHY_STANDARD_80211a);
  wifi.SetRemoteStationManager ("ns3::ConstantRateWifiManager",
                                "DataMode", StringValue ("OfdmRate24Mbps"));

  YansWifiChannelHelper wifiChannel;// = YansWifiChannelHelper::Default ();
  wifiChannel.SetPropagationDelay ("ns3::ConstantSpeedPropagationDelayModel");
  wifiChannel.AddPropagationLoss ("ns3::ThreeLogDistancePropagationLossModel");
  wifiChannel.AddPropagationLoss ("ns3::NakagamiPropagationLossModel");

  //YansWifiPhy wifiPhy = YansWifiPhy::Default();
  YansWifiPhyHelper wifiPhyHelper = YansWifiPhyHelper::Default ();
  wifiPhyHelper.SetChannel (wifiChannel.Create ());
  wifiPhyHelper.Set("TxPowerStart", DoubleValue(5));
  wifiPhyHelper.Set("TxPowerEnd", DoubleValue(5));


  NqosWifiMacHelper wifiMacHelper = NqosWifiMacHelper::Default ();
  wifiMacHelper.SetType("ns3::AdhocWifiMac");

//--------------------------------------------------------------------------
//
// Mobilidade
//
//--------------------------------------------------------------------------


  Ptr<UniformRandomVariable> randomizer = CreateObject<UniformRandomVariable> ();
  randomizer->SetAttribute ("Min", DoubleValue (83));
  randomizer->SetAttribute ("Max", DoubleValue (483));

  MobilityHelper mobility;
  mobility.SetPositionAllocator ("ns3::RandomBoxPositionAllocator",
                                 "X", PointerValue (randomizer),
                                 "Y", PointerValue (randomizer),
                                 "Z", PointerValue (NULL));

  //sem mobilidade
  mobility.SetMobilityModel ("ns3::ConstantPositionMobilityModel");

  //com mobilidade
  /*mobility.SetMobilityModel ("ns3::RandomWalk2dMobilityModel",
                             "Bounds", StringValue ("0|400|0|483"),
                             "Time", StringValue ("10s"),
                             "Speed", StringValue ("ns3::ConstantRandomVariable[Constant=2.0]"));
*/

//--------------------------------------------------------------------------
//
// Configurando nós
//
//--------------------------------------------------------------------------

  // Create nodes
  NodeContainer nodes;
  nodes.Create (numberOfNodes);

  // 1. Install Wifi
  NetDeviceContainer wifiNetDevices = wifi.Install (wifiPhyHelper, wifiMacHelper, nodes);

  // 2. Install Mobility model
  mobility.Install (nodes);

  // 3. Install NDN stack
  NS_LOG_INFO ("Installing NDN stack");
  ndn::StackHelper ndnHelper;
  ndnHelper.SetForwardingStrategy ("ns3::ndn::fw::BestRoute");
  //ndnHelper.SetContentStore ("ns3::ndn::cs::Lru", "MaxSize", "50");
  ndnHelper.SetContentStore ("ns3::ndn::cs::Nocache");
  ndnHelper.SetDefaultRoutes (true);
  ndnHelper.Install(nodes);

  // 4. Set up applications << nos regulares da rede
  NS_LOG_INFO ("Installing Applications");

  std::string prefix = "/prefix";

  // Consumer will request /prefix/0, /prefix/1, ...

  ndn::AppHelper consumerHelper ("ns3::ndn::ConsumerCbr");
  consumerHelper.SetPrefix (prefix);
  consumerHelper.SetAttribute ("Frequency", DoubleValue (10.0));
  consumerHelper.SetAttribute ("MaxSeq", DoubleValue (50));
  consumerHelper.Install (nodes.Get (2));
  consumerHelper.Install (nodes.Get (3));
  consumerHelper.Install (nodes.Get (6));
  consumerHelper.Install (nodes.Get (9));
  consumerHelper.Install (nodes.Get (12));


  // Producer will reply to all requests starting with /prefix

  ndn::AppHelper producerHelper ("ns3::ndn::Producer");
  producerHelper.SetPrefix (prefix);
  producerHelper.SetAttribute ("PayloadSize", StringValue("1024"));
  producerHelper.Install (nodes.Get (0));

  // 5. Set up applications << nos atacantes
  NS_LOG_INFO ("Installing Applications - Malicious Nodes");

  std::string prefixAttack = "/polluted";

  // Consumer will request /polluted/0, /polluted/1, ...

  ndn::AppHelper consumerHelperAttack ("ns3::ndn::ConsumerCbr");
  consumerHelperAttack.SetPrefix (prefixAttack);
  consumerHelperAttack.SetAttribute ("Frequency", DoubleValue (20.0));
  consumerHelper.SetAttribute ("MaxSeq", DoubleValue (50));
  consumerHelperAttack.Install (nodes.Get (5));
  consumerHelperAttack.Install (nodes.Get (10));
  consumerHelperAttack.Install (nodes.Get (15));


  // Producer will reply to all requests starting with /polluted

  ndn::AppHelper producerHelperAttack ("ns3::ndn::Producer");
  producerHelperAttack.SetPrefix (prefixAttack);
  producerHelperAttack.SetAttribute ("PayloadSize", StringValue("1024"));
  producerHelperAttack.Install (nodes.Get (1));

//--------------------------------------------------------------------------
//
// Simulacao
//
//--------------------------------------------------------------------------

  Simulator::Stop (Seconds (180.0));

  // Tracers

  std::string cstracer("resultados/ndn-no-cache-no-mob-pollution/experimento_");
  cstracer = cstracer.append(argv[2]);
  cstracer = cstracer.append("/rodada_");
  cstracer = cstracer.append(argv[3]);
  cstracer = cstracer.append("/trace-cs.txt");
  ndn::CsTracer::InstallAll (cstracer, Seconds (1));
 
  std::string appdelaytracer("resultados/ndn-no-cache-no-mob-pollution/experimento_");
  appdelaytracer = appdelaytracer.append(argv[2]);
  appdelaytracer = appdelaytracer.append("/rodada_");
  appdelaytracer = appdelaytracer.append(argv[3]);
  appdelaytracer = appdelaytracer.append("/trace-app-delays.txt");
  ndn::AppDelayTracer::InstallAll (appdelaytracer);
 
  std::string l3agg("resultados/ndn-no-cache-no-mob-pollution/experimento_");
  l3agg = l3agg.append(argv[2]);
  l3agg = l3agg.append("/rodada_");
  l3agg = l3agg.append(argv[3]);
  l3agg = l3agg.append("/trace-aggregate.txt");
  ndn::L3AggregateTracerModified::InstallAll(l3agg, Seconds (1));
 
  std::string l2rate("resultados/ndn-no-cache-no-mob-pollution/experimento_");
  l2rate = l2rate.append(argv[2]);
  l2rate = l2rate.append("/rodada_");
  l2rate = l2rate.append(argv[3]);
  l2rate = l2rate.append("/trace-l2Drop.txt");
  ns3::L2RateTracer::InstallAll(l2rate, Seconds (1));

  std::string l3rate("resultados/ndn-no-cache-no-mob-pollution/experimento_");
  l3rate = l3rate.append(argv[2]);
  l3rate = l3rate.append("/rodada_");
  l3rate = l3rate.append(argv[3]);
  l3rate = l3rate.append("/trace-rate.txt");
  ndn::L3RateTracer::InstallAll (l3rate, Seconds (1.0));

  Simulator::Run ();
  Simulator::Destroy ();

  return 0;
}
