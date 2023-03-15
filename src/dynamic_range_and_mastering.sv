// Implementation of HDMI SPD InfoFrame packet.
// By Sameer Puri https://github.com/sameer

// See CEA-861-D Section 6.5 page 72 (84 in PDF)
module dynamic_range_and_mastering
(
    output logic [23:0] header,
    output logic [55:0] sub [3:0]
);
/*
HB:  87 01 1a 27
SP0: 5c 02 00 00 00 00 00 b5
SP1: 01 00 00 00 00 00 00 00
SP2: 00 00 00 00 00 00 00 00
SP3: 00 00 00 00 00 00 00 00
*/

assign header = { 8'h1a, 8'h01, 8'h87 };

// PB0-PB6 = sub0
// PB7-13 =  sub1
// PB14-20 = sub2
// PB21-27 = sub3
logic [7:0] packet_bytes [27:0];

//assign packet_bytes[0] = 8'd1 + ~(header[23:16] + header[15:8] + header[7:0] + packet_bytes[25] + packet_bytes[24] + packet_bytes[23] + packet_bytes[22] + packet_bytes[21] + packet_bytes[20] + packet_bytes[19] + packet_bytes[18] + packet_bytes[17] + packet_bytes[16] + packet_bytes[15] + packet_bytes[14] + packet_bytes[13] + packet_bytes[12] + packet_bytes[11] + packet_bytes[10] + packet_bytes[9] + packet_bytes[8] + packet_bytes[7] + packet_bytes[6] + packet_bytes[5] + packet_bytes[4] + packet_bytes[3] + packet_bytes[2] + packet_bytes[1]);


//byte vendor_name [0:7];
//byte product_description [0:15];

genvar i;
generate
//    for (i = 0; i < 8; i++)
//    begin: vendor_to_bytes
//        assign vendor_name[i] = VENDOR_NAME[(7-i+1)*8-1:(7-i)*8];
//    end
//    for (i = 0; i < 16; i++)
//    begin: product_to_bytes
//        assign product_description[i] = PRODUCT_DESCRIPTION[(15-i+1)*8-1:(15-i)*8];
//    end
    assign packet_bytes[0] = 8'h27;
    assign packet_bytes[1] = 8'h5c;
    assign packet_bytes[2] = 8'h02;
    assign packet_bytes[3] = 8'h00;
    assign packet_bytes[4] = 8'h00;
    assign packet_bytes[5] = 8'h00;
    assign packet_bytes[6] = 8'h00;
    assign packet_bytes[7] = 8'hb5;
    assign packet_bytes[8] = 8'h00;
    assign packet_bytes[9] = 8'h00;
    assign packet_bytes[10] = 8'h00;
    assign packet_bytes[11] = 8'h00;
    assign packet_bytes[12] = 8'h00;
    assign packet_bytes[13] = 8'h00;
    assign packet_bytes[14] = 8'h00;
    assign packet_bytes[15] = 8'h00;
    assign packet_bytes[16] = 8'h00;
    assign packet_bytes[17] = 8'h00;
    assign packet_bytes[18] = 8'h00;
    assign packet_bytes[19] = 8'h00;
    assign packet_bytes[20] = 8'h00;
    assign packet_bytes[21] = 8'h00;
    assign packet_bytes[22] = 8'h00;
    assign packet_bytes[23] = 8'h00;
    assign packet_bytes[24] = 8'h00;
    assign packet_bytes[25] = 8'h00;
    assign packet_bytes[26] = 8'h00;
    assign packet_bytes[27] = 8'h00;
//    for (i = 1; i < 9; i++)
//    begin: pb_vendor
//        assign packet_bytes[i] = vendor_name[i - 1] == 8'h30 ? 8'h00 : vendor_name[i - 1];
//    end
//    for (i = 9; i < LENGTH; i++)
//    begin: pb_product
//        assign packet_bytes[i] = product_description[i - 9] == 8'h30 ? 8'h00 : product_description[i - 9];
//    end
//    assign packet_bytes[LENGTH] = SOURCE_DEVICE_INFORMATION;
//    for (i = 26; i < 28; i++)
//    begin: pb_reserved
//        assign packet_bytes[i] = 8'd0;
//    end
    for (i = 0; i < 4; i++)
    begin: pb_to_sub
        assign sub[i] = {packet_bytes[6 + i*7], packet_bytes[5 + i*7], packet_bytes[4 + i*7], packet_bytes[3 + i*7], packet_bytes[2 + i*7], packet_bytes[1 + i*7], packet_bytes[0 + i*7]};
    end
endgenerate

endmodule
