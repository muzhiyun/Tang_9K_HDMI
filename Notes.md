## Definitions
|abbreviation|meaning|
|-|-
|DSC                 |Display Stream Compression|
|DDC                 |Display Data Channel|
|SCDC                |Status and Control Data Channel sink会透过写入SCDCStatus Flags中的FLT_Ready，来告知Source可以进行LinkTraining，SCDC的I2C从机地址是0xA8/0xA9|
|EDID                |Extended Display Identification Data|
|HF-VSDB|

## Package Type
|abbreviation|special|type|meaning|Implementation|
|-|-|-|-|-|
|ACR|                 |0x01|     Audio Clock Regeneration (N/CTS)              |https://github.com/hdl-util/hdmi/blob/master/src/audio_clock_regeneration_packet.sv|
|ASAMPLE|             |0x02|     Audio Sample (L-PCM and IEC 61937 compressed)  |https://github.com/hdl-util/hdmi/blob/master/src/audio_sample_packet.sv|
|ACP|                 |0x04|     ACP Packet| |
|EMP  |携带VRR        |0x7F|     Extend Metadata Package                       | |
|AVI  |               |0x82|     Auxiliary Video Information                    |https://github.com/hdl-util/hdmi/blob/master/src/auxiliary_video_information_info_frame.sv|
|VSIF |携带ALLM       |0x81|     Vendor Specific InfoFrame|             |
|SPD  |携带Freesync   |0x83|     Source Product Description InfoFrame           |https://github.com/hdl-util/hdmi/blob/master/src/source_product_description_info_frame.sv  |
|AUI  |               |0x84|     AudioInfoFrame                                 |https://github.com/hdl-util/hdmi/blob/master/src/audio_info_frame.sv|
|HDR  |               |0x87|     Dynamic Range and Mastering                    |HDMI2.1的动态HDR功能实际就是通过不断发送0x87 package来实现|


### Note
- 改名后
    - HDMI2.0(TMDS) + NoeARC  == HDMI1.4b
    - HDMI2.0(TMDS) + eARC    == HDMI2.1 TMDS
    - HDMI2.1 FRL             == HDMI2.1 FRL
    - add FRL模式：3CH Data+ 1CH CLK改为4CH Data(原data+clk混合从4CH出) 
        - 由TMDS的8b/10b 改为 FRL的16b/18b编码方式(9+7转为10+8)
        - 加入Feed Forward Equalizer(FFE)以对抗高频下衰减

    - HDMI定义的ARC升级为eARC：
        - 2CH升级到8CH
        - 由仅DD增加了Atmos

- 区别：
    -  3CH TMDS Data + 1CH TMDS Clock == HDMI的DVI模式                                                       (特点:能出画面，没有audio)
    - 3CH TMDS Data + 1CH TMDS Clock + AudioInfoFrame + AVI + SPD == HDMI1.4                               (特点:...有audio,10.2Gbps,4K30Hz)
    - 3CH TMDS Data + 1CH TMDS Clock + AudioInfoFrame + AVI + SPD + EMP ? HDMI2.1的TMDS模式(原HDMI2.0)      (特点:...18Gbps,4K60Hz)
    - 3CH TMDS Data + 1CH TMDS Clock + Audio + AVI + SPD + SCDC(声明FRL) ==  最高6Gbps*3CH的HDMI2.1 FRL模式 (特点:...18Gbps)
    - 4CH FRL Data + Audio + AVI + SPD + SCDC(声明FRL) == 最高12Gbps*4CH的HDMI2.1 FRL模式                   (特点:...48Gbps，10k)

参见：https://www.graniteriverlabs.com/zh-tw/technical-blog/hdml-2-1-fixed-rate-link-frl-mode-overview