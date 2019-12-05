//
//  ReferenceLogs.swift
//  iLinX
//
//  Created by Vikas Ninawe on 04/02/19.
//  Copyright © 2019 Redbytes Software. All rights reserved.
//


//"#@ALL:AFRIEND#SOLICIT 239.255.16.90,8000,ALL"
//"#@ALL:AFRIEND#SOLICIT \(broadcastAddress),15000,ALL",
//#@ALL:AFRIEND#DEVICE_ID REQUEST,239.255.16.90,15000

//"#@ALL#QUERY RENDERER"
//"#@Family Room Player#QUERY CURRENT_SOURCE",
//"#@Family Room Player~root#QUERY SERVICE {{Family Room Player}}",
//"#REGISTER ON,{{Family Room Player}}",
//"#@Family Room Player#QUERY RENDERER {{Family Room Player}}",
//"#@Family Room Player#MENU_LIST 1,8,SOURCES"

//#@Family Room Player~root#QUERY NETWORK



// This is reference log for Data coming from netstream system(Used to create data model)


// {{<report type="source" song="Sharp Dressed Man" sngPlTotal="19" next="Crazy Train" elapsed="169195" controlState="PLAY" genre="" sngPlIndex="13" album="Eliminator" display="song/artist/album/genre" time="258" artwork="http://192.168.0.105/ipodart.jpg" caption="" shuffle="0" pwrOn="1" artist="ZZ Top" /> }}
//

 //Report
 
// #@TL38006251001161008A9E_1~UDP192.168.0.230_51319:SL25110005001161026448_4#REPORT {{<report type="state" DHCP_EN="1" staticIP_EN="0" IP="192.168.0.238" IPMask="255.255.0.0" gatewayIP="0.0.0.0" />}}
//
//#@TL380062440011610089F5_1~UDP192.168.0.162_63424:IpodRoom Player#REPORT {{<report type="state" currentSource="Ipod" sourceType="MEDIASERVER" controlType="SCRIPT" currentSourceIP="192.168.0.168" permId="SL25110005001161026448_1" />}}
//
//  #@TL38006251001161008A9E_1~UDP192.168.0.230_56111:IpodRoom Player#REPORT {{<report type="state" serviceName="IpodRoom Player" serviceType="audio/renderer" IP="192.168.0.238" permId="SL25110005001161026448_3" enabled="1" controlType="BuiltIn" IRPort="1" currentSource="SL25110005001161026448_1" roomName="IpodRoom" groupName="ALL" groupName="Audio_Renderers" />}}
//
//#@TL38006251001161008A9E_1~UDP192.168.0.162_49608:Ipod#REPORT {{<report type="state" serviceName="Ipod" serviceType="audio/source" IP="192.168.0.168" permId="SL25110005001161026448_1" enabled="1" sourceType="MEDIASERVER" roomName="IpodRoom" groupName="ALL" />}}
//
//#REPORT {{<report type=\"state\" vol=\"30\" balance=\"50\" bass=\"50\" treb=\"50\" loud=\"0\" mute=\"0\" audioSession=\"\" audioSessionActive=\"0\" ampOn=\"0\" sleep=\"0\" />}}
//
//#REPORT {{<report type=\"state\" vol=\"30\" balance=\"50\" bass=\"50\" treb=\"50\" loud=\"0\" mute=\"0\" audioSession=\"\" audioSessionActive=\"0\" band_1=\"50\" band_2=\"50\" band_3=\"50\" band_4=\"50\" band_5=\"0\" ampOn=\"0\" active=\"0\" sleep=\"0\" />}}
//
//#REPORT {{<report type=”state” currentSource=”myXm” currentSourceIP=”10.15.96.149” permId=”mLA10105151001161008019_1” />}}
//
//
//#@TL38006251001161008A9E_1~UDP192.168.0.152_58745:Ipod#REPORT {{<report type="source" song="Everlong" sngPlTotal="19" next="Nothin&apos; But A Good Time" elapsed="40646" controlState="PLAY" genre="" sngPlIndex="1" album="Greatest Hits - Foo Fighters" display="song/artist/album/genre" time="250" artwork="http://192.168.0.173/def_src_img_1.jpg" caption="" shuffle="0" pwrOn="1" artist="Foo Fighters" /> }}

//Radio response
//#@TL38006251001161008A9E_1~UDP192.168.0.152_58745:Ipod#REPORT {{<report type="source" caption="FM 98.10" band ="FM" pwrOn="1" frequency = "98.10"  /> }}

//Menuresp


//#MENU_RESP {{<source idpath=\"sources\" itemnum=\"1\" id=\"IOS2ipod_Stream\" disppath=\"sources\" display=\"IOS2ipod_Stream\" children=\"0\" ip=\"192.168.0.179\" type=\"audio/source\" />}}
//
//#MENU_RESP {{<menuName id=”itemId” children=”0” itemnum=”1” idpath=”menuName” disppath=”menu Name” display=”Item ID” otherData=”123456” moreData=”xyz” />}}
//
// #@TL38006251001161008A9E_1~UDP192.168.0.162_53706:Ipod#MENU_RESP {{<item disppath="media" itemnum="7" itemselectable="0" display="Audio Book" id="7" children="0" idpath="media" />}}*/
//
//
//#@TL38006251001161008A9E_1~UDP192.168.0.162_53706:Ipod#MENU_RESP {{<item; disppath="media" itemnum="8" itemselectable="0" display="Podcast" id="8" children="0" idpath="media" />}}
//
//#@TL380062440011610089F5_1~UDP192.168.0.162_53176:Ipod#MENU_RESP {{<error disppath="media" itemnum="-1" display="No iPod is docked" id="" children="0" idpath="media>Playlists" />}}
//
//#@TL38006251001161008A9E_1~UDP192.168.0.144_63606:Ipod#MENU_RESP {{<song disppath="media>Playlist>Song" itemnum="8" display="Haven't Met You Yet" id="7" children="0" idpath="media>1>1" />}}
//
//#@TL38006251001161008A9E_1~UDP192.168.0.149_54004:Ipod#MENU_RESP {{<item disppath="media>Artist" itemnum="-1" display="" id="" children="0" idpath="media>2" />}}





// This is reference log for creating signals string

 
 //#@Ipod#PLAY
 
 //#@IpodRoom Player#LOUDNESS 16
 
// #@Room 2 Player~root#QUERY SERVICE {{Room 2 Player}}
// #@TL38006251001161008A9E_1~UDP192.168.0.230_56111:Room 2 Player#REPORT {{<report type="state" serviceName="Room 2 Player" serviceType="audio/renderer" IP="192.168.0.240" permId="SL2200554001161005255_3" enabled="1" controlType="BuiltIn" IRPort="1" currentSource="" roomName="Room 2" groupName="ALL" groupName="Audio_Renderers" />}}
//
// #@IpodRoom Player~root#QUERY SERVICE {{IpodRoom Player}}
// #@TL38006251001161008A9E_1~UDP192.168.0.230_56111:IpodRoom Player#REPORT {{<report type="state" serviceName="IpodRoom Player" serviceType="audio/renderer" IP="192.168.0.238" permId="SL25110005001161026448_3" enabled="1" controlType="BuiltIn" IRPort="1" currentSource="SL25110005001161026448_1" roomName="IpodRoom" groupName="ALL" groupName="Audio_Renderers" />}}
//

// OutSocket: didConnectToAddress
// BroadcastSocket: Unable to bind to port 15000
// Incoming message from BroadcastSocket: 51 bytes
// Recieved string from BroadcastSocket:  #@ALL:AFRIEND#DEVICE_ID REQUEST,192.168.3.255,15000
// Incoming message from BroadcastSocket: 51 bytes
// Recieved string from BroadcastSocket:  #@ALL:AFRIEND#DEVICE_ID REQUEST,192.168.3.255,15000
// Incoming message from BroadcastSocket: 51 bytes
// Recieved string from BroadcastSocket:  #@ALL:AFRIEND#DEVICE_ID REQUEST,192.168.3.255,15000
// Incoming message from BroadcastSocket: 51 bytes
// Recieved string from BroadcastSocket:  #@ALL:AFRIEND#DEVICE_ID REQUEST,192.168.3.255,15000
// Incoming message from BroadcastSocket: 83 bytes
// Recieved string from BroadcastSocket:  #@DealerSetup:TL380062440011610089F5_1#DEVICE_ID RESPONSE,TL380062440011610089F5_1
//
// #@ALL:AFRIEND#DEVICE_ID REQUEST,239.255.16.90,15000
// #@ALL:AFRIEND#DEVICE_ID REQUEST,239.255.16.90,15000
// #@ALL:AFRIEND#DEVICE_ID REQUEST,239.255.16.90,15000
// #@ALL:AFRIEND#SOLICIT 239.255.16.90,8000, ALL
//

 
// DecodedString BroadcastSocket:
// #@ALL:AFRIEND#DEVICE_ID REQUEST,239.255.16.90,15000
// #@ALL:AFRIEND#DEVICE_ID REQUEST,239.255.16.90,15000
// #@ALL:AFRIEND#DEVICE_ID REQUEST,239.255.16.90,15000
// #@ALL:AFRIEND#DEVICE_ID REQUEST,239.255.16.90,15000
// #@ALL:AFRIEND#DEVICE_ID REQUEST,239.255.16.90,15000
// #@ALL:AFRIEND#DEVICE_ID REQUEST,239.255.16.90,15000
// #@ALL:AFRIEND#DEVICE_ID REQUEST,239.255.16.90,15000
// #@ALL:AFRIEND#DEVICE_ID REQUEST,239.255.16.90,15000
//
// #@ALL:AFRIEND#SOLICIT 239.255.16.90,8000,ALL
//

 
// 2018-11-20 15:28:43.446194+0530 iLinX HD[2776:52005] NetStreamComms <NetStreamsComms: 0x6000001979d0>: adding discovery socket to run loop
// 2018-11-20 15:28:43.446194+0530 iLinX HD[2776:52005] NetStreamComms <NetStreamsComms: 0x6000001979d0>: adding discovery socket to run loop
//
// 2018-11-20 15:27:29.831999+0530 iLinX HD[2776:52005] +[CATransaction synchronize] called within transaction
// 2018-11-20 15:28:43.418717+0530 iLinX HD[2776:52005] Retained objects: (null)
// 2018-11-20 15:28:43.433545+0530 iLinX HD[2776:52005] NetStreamComms <NetStreamsComms: 0x6000001979d0>: starting discovery on: 239.255.16.90:8000
// 2018-11-20 15:28:43.444754+0530 iLinX HD[2776:52005] NetStreamComms <NetStreamsComms: 0x6000001979d0>: created discovery socket
// 2018-11-20 15:28:43.444931+0530 iLinX HD[2776:52005] NetStreamComms <NetStreamsComms: 0x6000001979d0>: set discovery socket re-use option
// 2018-11-20 15:28:43.445103+0530 iLinX HD[2776:52005] NetStreamComms <NetStreamsComms: 0x6000001979d0>: enabling (1) broadcast on discovery socket
// 2018-11-20 15:28:43.445342+0530 iLinX HD[2776:52005] NetStreamComms <NetStreamsComms: 0x6000001979d0>: enable broadcast returned 0; adding discovery socket to multicast group: 239.255.16.90
// 2018-11-20 15:28:43.445601+0530 iLinX HD[2776:52005] NetStreamComms <NetStreamsComms: 0x6000001979d0>: discovery init multicast: 0, broadcast: 0
// 2018-11-20 15:28:43.445715+0530 iLinX HD[2776:52005] NetStreamComms <NetStreamsComms: 0x6000001979d0>: setting discovery socket local address
// 2018-11-20 15:28:43.445883+0530 iLinX HD[2776:52005] CFSocketSetAddress listen failure: 102
// 2018-11-20 15:28:43.446194+0530 iLinX HD[2776:52005] NetStreamComms <NetStreamsComms: 0x6000001979d0>: adding discovery socket to run loop
// 2018-11-20 15:28:43.446449+0530 iLinX HD[2776:52005] NetStreamComms <NetStreamsComms: 0x6000001979d0>: creating and starting broadcast ping object
// 2018-11-20 15:28:43.446841+0530 iLinX HD[2776:52005] local address: 192.168.0.147, netmask: 255.255.252.0, addr parts: (
// 192,
// 168,
// 0,
// 147
// ), mask parts: (
// 255,
// 255,
// 252,
// 0
// )
// 2018-11-20 15:28:43.447192+0530 iLinX HD[2776:52005] NetStreamComms <NetStreamsComms: 0x6000001979d0>: ready for discovery on: 239.255.16.90:8000
// 2018-11-20 15:28:46.448865+0530 iLinX HD[2776:52005] NetStreamComms <NetStreamsComms: 0x6000001979d0>: send discovery timeout fired
// 2018-11-20 15:28:46.449597+0530 iLinX HD[2776:52005] NetStreamComms <NetStreamsComms: 0x6000001979d0>: sending discovery messages with response address: 239.255.16.90
// 2018-11-20 15:28:46.449835+0530 iLinX HD[2776:52005] NetStreamComms <NetStreamsComms: 0x6000001979d0>: sent discovery messages (broadcast: 0, multicast: 0)
// 2018-11-20 15:28:46.449978+0530 iLinX HD[2776:52005] NetStreamComms <NetStreamsComms: 0x6000001979d0>: sending discovery messages with response address: 192.168.0.147
// 2018-11-20 15:28:46.450226+0530 iLinX HD[2776:52005] NetStreamComms <NetStreamsComms: 0x6000001979d0>: sent discovery messages (broadcast: 0, multicast: 0)
// 2018-11-20 15:28:46.453292+0530 iLinX HD[2776:52005] <NetStreamsComms: 0x6040001953a0>: Connected to: 192.168.0.187
// 2018-11-20 15:28:46.453575+0530 iLinX HD[2776:52005] Sending: #@ALL#QUERY RENDERER
// 2018-11-20 15:28:46.529839+0530 iLinX HD[2776:52005] Received: #@SL2200604800116100CA9C_4~TCP192.168.0.147_56419:Kitchen Player#REPORT {{<report type="state" vol="29" balance="50" bass="50" treb="50" loud="0" mute="0" audioSession="" audioSessionActive="0" ampOn="1" sleep="0" />}}
// 2018-11-20 15:28:46.530394+0530 iLinX HD[2776:52005] Sending: #@Kitchen Player~root#QUERY NETWORK
// 2018-11-20 15:28:46.558295+0530 iLinX HD[2776:52005] Received: #@SL2200604800116100CA9C_4~TCP192.168.0.147_56419:SL2200604800116100CA9C_4#REPORT {{<report type="state" DHCP_EN="1" staticIP_EN="0" IP="192.168.0.187" IPMask="255.255.0.0" gatewayIP="0.0.0.0" />}}
// 2018-11-20 15:28:46.558670+0530 iLinX HD[2776:52005] Sending: #@Kitchen Player~root#QUERY SERVICE {{Kitchen Player}}
// 2018-11-20 15:28:46.559062+0530 iLinX HD[2776:52005] <NetStreamsComms: 0x6040001953a0>: Disconnected from: 192.168.0.187
// 2018-11-20 15:28:48.416670+0530 iLinX HD[2776:52005] NetStreamsComms 001979D0: discovery socket callback
// 2018-11-20 15:28:48.416936+0530 iLinX HD[2776:52005] NetStreamComms: <NetStreamsComms: 0x6000001979d0>: received discovery data: <000bcdab 00000400 c0a800bb 00100400 ffff0000 00010200 07080002 1a01534c 32323030 36303438 30303131 36313030 43413943 5f320000 000f0a01 30312e34 302e3031 00000003 12015265 645f4d65 6469615f 53747265 616d0000 00040801 4b697463 68656e00 00050e01 61756469 6f2f736f 75726365 00000006 1e01534c 32323030 36303438 30303131 36313030 43413943 5f322e78 6d6c0000 00093802 000a0400 00000000 000b0200 0000000c 02000200 000d0200 0100000e 1a01534c 32323030 36303438 30303131 36313030 43413943 5f320000 00093802 000a0400 00000000 000b0200 0000000c 02000100 000d0200 0000000e 1a01534c 32323030 36303438 30303131 36313030 43413943 5f320000>
// 2018-11-20 15:28:48.417093+0530 iLinX HD[2776:52005] NetStreamComms <NetStreamsComms: 0x6000001979d0>: discovered service: Red_Media_Stream (type: audio/source, version: 01.40.01, perm id: SL2200604800116100CA9C_2, room: Kitchen, addr: 192.168.0.187, netmask: 255.255.0.0)
// 2018-11-20 15:28:48.417410+0530 iLinX HD[2776:52005] NLRoomList <NLRoomList: 0x6000000eb600>: discovered audio/source service Red_Media_Stream on 192.168.0.187
// 2018-11-20 15:28:50.338461+0530 iLinX HD[2776:52005] NetStreamsComms 001979D0: discovery socket callback
// 2018-11-20 15:28:50.338695+0530 iLinX HD[2776:52005] NetStreamComms: <NetStreamsComms: 0x6000001979d0>: received discovery data: <000acdab 00000400 c0a800ae 00100400 fffffc00 00010200 07080002 1801534c 32323030 35353430 30313136 31303035 3235355f 3300000f 0a013032 2e39302e 30320000 00031401 46616d69 6c792052 6f6f6d20 506c6179 65720000 00040c01 46616d69 6c792052 6f6f6d00 00051001 61756469 6f2f7265 6e646572 65720000 00130801 4275696c 74496e00 00092a02 000a0400 efff1b9d 000b0200 1d1e000c 02000100 000d0200 0000000e 0c014661 6d696c79 20526f6f 6d00>
// 2018-11-20 15:28:50.338880+0530 iLinX HD[2776:52005] NetStreamComms <NetStreamsComms: 0x6000001979d0>: discovered service: Family Room Player (type: audio/renderer, version: 02.90.02, perm id: SL2200554001161005255_3, room: Family Room, addr: 192.168.0.174, netmask: 255.255.252.0)
// 2018-11-20 15:28:50.339330+0530 iLinX HD[2776:52005] NLRoomList <NLRoomList: 0x6000000eb600>: discovered audio/renderer service Family Room Player on 192.168.0.174
// 2018-11-20 15:28:50.339814+0530 iLinX HD[2776:52005] NLRoomList <NLRoomList: 0x6000000eb600>: adding validate host operation to queue
// 2018-11-20 15:28:50.340485+0530 iLinX HD[2776:53043] Download and parse (null) started.
// 2018-11-20 15:28:50.341726+0530 iLinX HD[2776:53043] NLValidateHostOperation <NLValidateHostOperation: 0x6040002a6e40>: checking reachability of 192.168.0.174
// 2018-11-20 15:28:50.342858+0530 iLinX HD[2776:53043] NLValidateHostOperation <NLValidateHostOperation: 0x6040002a6e40>: reachability check complete
// 2018-11-20 15:28:50.343077+0530 iLinX HD[2776:53043] NLValidateHostOperation <NLValidateHostOperation: 0x6040002a6e40>: Checking renderer 192.168.0.174 is usable
// 2018-11-20 15:28:50.365386+0530 iLinX HD[2776:53043] NLValidateHostOperation <NLValidateHostOperation: 0x6040002a6e40>: Renderer usability check for 192.168.0.174 returned: (null)
// 2018-11-20 15:28:50.365729+0530 iLinX HD[2776:52005] NLValidateHostOperation <NLValidateHostOperation: 0x6040002a6e40>: Fetching GUI data: http://192.168.0.174:80/gui.xml
// 2018-11-20 15:28:51.408868+0530 iLinX HD[2776:52005] NLRoomList <NLRoomList: 0x6000000eb600>: Successfully parsed GUI data: http://192.168.0.174:80/gui.xml
// 2018-11-20 15:28:51.417536+0530 iLinX HD[2776:52005] NetStreamComms <NetStreamsComms: 0x6000001979d0>: discovery cancelled
// 2018-11-20 15:28:51.417692+0530 iLinX HD[2776:52005] NetStreamsComms <NetStreamsComms: 0x6000001979d0>: discoveryTimeoutFired
// 2018-11-20 15:28:51.417855+0530 iLinX HD[2776:52005] NetStreamComms <NetStreamsComms: 0x6000001979d0>: discovery complete with error: (null)
// 2018-11-20 15:28:51.418555+0530 iLinX HD[2776:52005] NLRoomList <NLRoomList: 0x6000000eb600>: discovery complete
// 2018-11-20 15:28:51.418763+0530 iLinX HD[2776:52005] NLRoomList <NLRoomList: 0x6000000eb600>: handleDiscoveryComplete
// 2018-11-20 15:28:51.419392+0530 iLinX HD[2776:52005] Queuing to send later: #@Family Room Player#QUERY CURRENT_SOURCE
// 2018-11-20 15:28:51.419583+0530 iLinX HD[2776:52005] Queuing to send later: #@Family Room Player~root#QUERY SERVICE {{Family Room Player}}
// 2018-11-20 15:28:51.419723+0530 iLinX HD[2776:52005] Queuing to send later: #REGISTER ON,{{Family Room Player}}
// 2018-11-20 15:28:51.419878+0530 iLinX HD[2776:52005] Queuing to send later: #@Family Room Player#QUERY RENDERER {{Family Room Player}}
// 2018-11-20 15:28:51.605555+0530 iLinX HD[2776:52005] Queuing to send later: #@Family Room Player#MENU_LIST 1,8,SOURCES
// 2018-11-20 15:28:51.639132+0530 iLinX HD[2776:52005] <NetStreamsComms: 0x6000001979d0>: Connected to: 192.168.0.174
// 2018-11-20 15:28:51.639297+0530 iLinX HD[2776:52005] Sending: #@Family Room Player#QUERY CURRENT_SOURCE
// 2018-11-20 15:28:51.639454+0530 iLinX HD[2776:52005] Sending: #@Family Room Player~root#QUERY SERVICE {{Family Room Player}}
// 2018-11-20 15:28:51.639615+0530 iLinX HD[2776:52005] Sending: #REGISTER ON,{{Family Room Player}}
// 2018-11-20 15:28:51.639753+0530 iLinX HD[2776:52005] Sending: #@Family Room Player#QUERY RENDERER {{Family Room Player}}
// 2018-11-20 15:28:51.639895+0530 iLinX HD[2776:52005] Sending: #@Family Room Player#MENU_LIST 1,8,SOURCES
// 2018-11-20 15:28:51.997321+0530 iLinX HD[2776:52005] Received: #@SL2200554001161005255_4~TCP192.168.0.147_56432:Family Room Player#REPORT {{<report type="state" currentSource="Red_Media" sourceType="Generic" controlType="IR" currentSourceIP="192.168.0.183" permId="MLA100055200116100532B_1" />}}
// 2018-11-20 15:28:51.997668+0530 iLinX HD[2776:52005] Sending: #REGISTER ON,{{Red_Media}}
// 2018-11-20 15:28:52.188256+0530 iLinX HD[2776:52005] Sending: #@Family Room Player~root#QUERY SERVICE {{Family Room Player}}
// 2018-11-20 15:28:52.188508+0530 iLinX HD[2776:52005] Sending: #@Family Room Player~root#QUERY SERVICE {{Family Room Player}}
// 2018-11-20 15:28:52.188695+0530 iLinX HD[2776:52005] Received: #@SL2200554001161005255_4~TCP192.168.0.147_56432:Family Room Player#REPORT {{<report type="state" serviceName="Family Room Player" serviceType="audio/renderer" IP="192.168.0.174" permId="SL2200554001161005255_3" enabled="1" controlType="BuiltIn" IRPort="1" roomName="Family Room" groupName="ALL" groupName="Audio_Renderers" />}}
// 2018-11-20 15:28:52.189042+0530 iLinX HD[2776:52005] Received: #@SL2200554001161005255_4~TCP192.168.0.147_56432:Family Room Player#REPORT {{<report type="state" vol="44" balance="50" bass="50" treb="50" loud="0" mute="0" audioSession="" audioSessionActive="0" ampOn="1" sleep="0" />}}
// 2018-11-20 15:28:52.189387+0530 iLinX HD[2776:52005] Received: #@SL2200554001161005255_4~TCP192.168.0.147_56432:Family Room Player#MENU_RESP {{<source idpath="sources" itemnum="1" id="Family_Room_Source" disppath="sources" display="Family_Room_Source" children="0" ip="192.168.0.174" type="audio/localsource" />}}
// 2018-11-20 15:28:52.189690+0530 iLinX HD[2776:52005] Received: #@SL2200554001161005255_4~TCP192.168.0.147_56432:Family Room Player#MENU_RESP {{<source idpath="sources" itemnum="2" id="Red_Media" disppath="sources" display="Red_Media" children="0" ip="192.168.0.183" type="audio/source" />}}
// 2018-11-20 15:28:52.189976+0530 iLinX HD[2776:52005] Received: #@SL2200554001161005255_4~TCP192.168.0.147_56432:Family Room Player#MENU_RESP {{<source idpath="sources" itemnum="3" id="Red_Media_Stream" disppath="sources" display="Red_Media_Stream" children="0" ip="192.168.0.187" type="audio/source" />}}
// 2018-11-20 15:28:52.190326+0530 iLinX HD[2776:52005] Received: #@SL2200554001161005255_4~TCP192.168.0.147_56432:Family Room Player#MENU_RESP {{<source idpath="SOURCES" itemnum="-1" />}}
// 2018-11-20 15:28:52.212005+0530 iLinX HD[2776:52005] Received: #@SL2200554001161005255_4~TCP192.168.0.147_56432:Family Room Player#REPORT {{<report type="state" serviceName="Family Room Player" serviceType="audio/renderer" IP="192.168.0.174" permId="SL2200554001161005255_3" enabled="1" controlType="BuiltIn" IRPort="1" roomName="Family Room" groupName="ALL" groupName="Audio_Renderers" />}}
// 2018-11-20 15:28:52.212470+0530 iLinX HD[2776:52005] Received: #@SL2200554001161005255_4~TCP192.168.0.147_56432:Family Room Player#REPORT {{<report type="state" serviceName="Family Room Player" serviceType="audio/renderer" IP="192.168.0.174" permId="SL2200554001161005255_3" enabled="1" controlType="BuiltIn" IRPort="1" roomName="Family Room" groupName="ALL" groupName="Audio_Renderers" />}}
//
//
// 2018-11-20 15:28:52.310030+0530 iLinX HD[2776:52005] Received: #@~STATUS:Red_Media#REPORT {{<report type="source" artwork="http://192.168.0.183/def_src_img_1.jpg" display="song/artist/album/genre" pwrOn="1" active="1" controlState="" caption="Red_Media" source="Red_Media" />}}
// 2018-11-20 15:28:52.391737+0530 iLinX HD[2776:52005] Sending: #@Red_Media#MENU_LIST 1,8,{{presets}}
// 2018-11-20 15:28:52.423379+0530 iLinX HD[2776:52005] Received: #@SL2200554001161005255_4~TCP192.168.0.147_56432:Red_Media#MENU_RESP {{<preset idpath="presets" itemnum="-1" />}}
// 2018-11-20 15:28:52.423813+0530 iLinX HD[2776:52005] <NLBrowseListNetStreams: 0x6000001c87f0> (presets): pendingRequests - current request removed:
// 2018-11-20 15:28:53.316563+0530 iLinX HD[2776:52005] Received: #@~STATUS:Red_Media#REPORT {{<report type="source" artwork="http://192.168.0.183/def_src_img_1.jpg" display="song/artist/album/genre" pwrOn="1" active="1" controlState="" caption="Red_Media" source="Red_Media" />}}
// 2018-11-20 15:28:54.314449+0530 iLinX HD[2776:52005] Received: #@~STATUS:Red_Media#REPORT {{<report type="source" artwork="http://192.168.0.183/def_src_img_1.jpg" display="song/artist/album/genre" pwrOn="1" active="1" controlState="" caption="Red_Media" source="Red_Media" />}}
// 2018-11-20 15:28:55.307344+0530 iLinX HD[2776:52005] Received: #@~STATUS:Red_Media#REPORT {{<report type="source" artwork="http://192.168.0.183/def_src_img_1.jpg" display="song/artist/album/genre" pwrOn="1" active="1" controlState="" caption="Red_Media" source="Red_Media" />}}
//
//
//
//
//
