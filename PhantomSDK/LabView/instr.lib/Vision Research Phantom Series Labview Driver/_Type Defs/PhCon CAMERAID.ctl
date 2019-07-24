RSRC
 LVCCLBVW  [4  {      [      	VRI.lvlib     � �  0           < � @�      ����            s�`CmyZL�*�S�s<�   
       �u��J�T\�h�e���ُ ��	���B~                                             ��ۀ��(�5cod          R LVCCVRI.lvlib:PhCon CAMERAID.ctl       VILB    PTH0       	VRI.lvlib               #   x�c�``j`�� Č@� H�&    J  $x�c`��� H120�d i4q0cS ���\�Bř �e�	�Pq&�	������w � �&�     , VIDSVRI.lvlib:PhCon CAMERAID.ctl          ]  Dx��U�kA�]75j�(UP!�S�$Zkj��֤N$h�"��B+���B	���a��*��AJڊlLI�ZP�ŋzP�[|ov�IZ������1o������D����9!�B��4�x0y�0�4��[���#���YT_�I�r�͸@L��r�4j,�DY�>&�6�!�1W呫�"ͻ�Unp�і|�H)~H5'����'n�F%fX��z�3e�l�嵥E3���x���|�<��2�e\IQcLI2�)��fR�6�����m�����I�:���%7�KqВ�ݑh9����K�;іpKWv�n�,9wm樏����n����%�cK�9R�̩�9H��,��@�.�G�yKΪ��"��G��;����E��ݍ����b�TOҰ�L�~��bk��؃j�D�
u�Lm'f��;�L#�i��$�:��A�����h���F���#|3�F�AMj|az�@����,��1Q�t��c�jݜ0º x��-�)?y��~�� �`W�^��f�q��F�����oFIh,\hI�h��װ:���vD Bչ�X�h�DV�!?�U�L��>Z�L]�����]����0<A�A�[��g�� �zAS�8��fJ�S���v�%%�����b�֏�ِ��|�S������`��|��h'���a�3�8�/��W��=�y��q��"��Dg��L���E�J��6?�^�,daO^���6����G;i��Cjh	��65����e�����9����fĖ�y�>4�O��<�~�e��rP��3��>���m?�Ē�ѭt/����+��g�s�s�C�c]��������`��a      �  13.0.1       �   13.0    �  13.0.1       �   13.0    �  13.0.1                        ^  ZPhCon.dll

Acquisition Parameters (ACQUIPARAMS)

typedef struct tagACQUIPARAMS
{
    UINT ImWidth;             //Image dimensions
    UINT ImHeight;

    UINT FrameRate;        //Frame rate
    UINT Exposure;           //Exposure duration (nanoseconds)
    UINT EDRExposure;    //EDR (extended dynamic range)
                                        //exposure duration (nanoseconds)
    UINT ImDelay;             //Image delay from the external strobe
                                        //in the SyncImaging mode (nanoseconds)
    UINT PTFrames;          //post trigger frames
    UINT ImCount;            //cine size in images (read only field)

    UINT SyncImaging;     //sync imaging mode: internal, external or   
                                        //lock to IRIG time
    UINT AutoExposure;   //auto exposure
    UINT AutoExpLevel;    //Level for autoexposure control
    UINT AutoExpSpeed;  //Speed for autoexposure control
    RECT AutoExpRect;    //Rectangle for autoexposure control
    BOOL Recorded;         //The cine was recorded and it is                              
                                        //available for playback 
                                        //TriggerTime,RecordedCount, ImCount, 
                                        //FirstIm are valid and final (read only 
                                        //field)
    TIME64 TriggerTime;   //Trigger time for the recorded cine 
                                        //(read-only field)
    UINT RecordedCount; //initially recorded count; ImCount may be
                                         //smaller if the cine was partially saved to
                                         //NonVolatile memory (read-only field)
    INT FirstIm;                  //First image number of this cine; may be
                                         //different from PTFrames-ImCount if the 
                                         //cine was partially saved to Non-Volatile                                 
                                         //memory(read-only field)
    
                                         //Frame rate profile
    UINT FRPSteps;           //Supplementary steps in frame rate profile
                                         //0 means no frame rate profile    
    INT FRPImgNr[16];      //Image number where to change the rate 
                                         //and/or the exposure. All image numbers
                                         //have to be positive (post trigger).
                                         //Allocated for 16 points (4 available in   
                                         //current ethernet cameras)
    UINT FRPRate[16];      //new value for frame rate (fps)
    UINT FRPExp[16];        //new value for exposure (nanoseconds)                       

    UINT Decimation;          //Reduces the frame rate when sending the 
                                          //images to the i3 external memory through
                                          //fiber
    UINT BitDepth;              //Bit depth of cines (read-only field) 
                                          //- usefull for flash; the
                                          //images from flash have to be requested 
                                          //at the bit depth used when stored.
                                          //The images from RAM can be requested at 
                                          //different bit depths
    UINT CamGainRed;        //Gains attached to a cine saved in the                     
                                           //magazine
    UINT CamGainGreen;     //Normally they tell the White balance at 
                                           //recording time
    UINT CamGainBlue;
    UINT CamGain;               //global gain
    BOOL ShutterOff;           //go to max exposure for piv mode
    
    UINT CFA;                       //Color Filter Array at the recording of 
                                            //the cine
    char CineName[256];      //cine name
    char Description[4096];  //Cine description on max 4095 chars 
}ACQUIPARAMS, *PACQUIPARAMS;



The Phantom cameras can record cines at various frame rates depending on the image size. The image dimensions in pixels are power of 2 at v4-v6 cameras up to 512x512 (v4) and 1024x1024 (v5). The new Ethernet camera allow setting any resolution, based on the minimum resolution, maximum resolution (for example, v7: 800x600) and increments. This is called "Continuous Adjustable Resolution" - CAR.  A list of the available image dimensions can be got using the function PhGetResolutions. The available resolutions depend only on camera version. 

FrameRate is the frame rate required by the user for the current preview and recording operations.  Exposure is the duration of the exposure in nanoseconds and EDRExposure is the value of the "extended dynamic range exposure" parameter.

Changing the exposure during frame rate profile may not be implemented in the cameras and it is requested that the exposure have the same value on all steps equal to the one in the pretrigger period. Of course that value has to be smaller than the period of the highest frame rate on the profile.

The range of the accepted frame rates depends on the image dimensions and may span from a few tens to a few hundreds of thousands of frames per second (fps). The exposure range is from 1000...10000 nanoseconds (1...10 microseconds, depending on camera and on options), up to near the inverse of the frame rate. 

ImDelay is the delay from the external strobe to the start of the image exposure; it is not used in all camera models.

There may be a small difference between the required and the effective frame rate and exposure values. The effective frame rate during a recording can be computed from the difference between the successive images time. The real exposure duration for every image is also available in a table that you can get by calling the function PhGetAuxData.

PTFrames is the number of the frames that will be recorded after the trigger and can be any non-zero, positive integer, up to 4 billions. Large values of PTFrames have the effect of an adjustable delay of the recording from the trigger moment. 

ImCount is the capacity of the FBM in images. It is a read only field and it depends on the memory DIMM installed and on image size.

The SyncImaging defines the source of  image acquisition pulses. It can be : 
"	SYNC_INTERNAL repetitive acquisition at the specified  FrameRate  frequency 
"	SYNC_EXTERNAL starts the exposure of each frame when an external signal rises 
"	SYNC_LOCKTOIRIG mode allows the synchronization of multiple cameras using the common IRIG time signal.
 
In the AutoExposure mode, the camera continuously adjusts the exposure duration to get the best images, even when illumination conditions change. The next fields (AutoExpLevel, AutoExpSpeed and AutoExpRect) allow the adjustment of the auto exposure algorithm based on the contents of a specified area from the image.

TriggerTime is the exact trigger moment and its value is somewhere between the time of image -1 and the time of image 0.

RecordedCount is the exact number of images recorded for the current cine and it can be larger than ImCount if the cine was partially saved to the NonVolatile memory and restored. 

FirstIm always gives the number of the first image of the cine.

FRP� parameters  (Frame Rate Profile) provide a way to change the frame rate and the exposure during the cine recording (only after trigger). After the acquisition of the image number FRPImgNr[i] (i=0�FRPSteps, FRPImgNr[i] is positive or zero) the frame rate is changed to FRPRate[i] and the exposure is changed to FRPExp[i]. The normal cine parameters (set by PhSetCineParams() are used before FRPImgNr[0].

The ACQUIPARAMS structure is stored in the nonvolatile memory of the camera so the last settings from camera remain active even after the camera is powered off and restarted.
     ���������������h���-��-M���m���m������������������  �  � D� �� ��� ��� ��� �������R������T�aɊd�  �dOɒf��\�M���C�R�]����   �����������������UUUUUUUUUUUUUU_�UUUUUUUUUUUUUU_��U�\U�U�\\�\U\_�U��\U�U�\U�\��_��U��\U���U�\\\_�UU�\\���\U�\U\_�UU�\\U��\U�\U\_�UUUUUUUUUUUUUU_�UUUUUUUUUUUUUU_�UUUUUUUUUUUUUU_��������������������  �  �   ��������� �   ������������   ��������������� �������������  �������������   �������������    ������������� � ������������ � ��������� ��  ��������� � ���� �� ���  � �              �� �� �  ��� �� ���� �� �� � ��  �� ���   ��  � �� �����������������   �������������������������������������������������������������������������������������������������+++��+��+��++��+��+�+++�+���+���+��+�+��+��++��++�+��+��++�++���+++��++++�+��+�+�++��+��+�+�+���+����+��+�++++�+��+��+��+���+���+����+��+�+��+�+��+��+��+���+���������������������������������������������������������������������������������������������������������������������������������������+�      ���     ��        ������VV�������+��    VV+       ��+�����VVVVVVVVVV�V+V�VV       ��  +����VVVVVVVV������V�VV�VV� ��    ���VVVVVVVV������V������� ��      +�VVVVVVV��������������+��       �+VVVVVV�����������������         ��VVVV�����V���V����+�� ��   ��   ��VV����������������� ��  �  � �  �+�V��+��������� ���  � �    �  � �+ � � ������+ ������ �  � � �  �  � �  +�� �  ���  �  ��   � �  ��  �    +    ��                              �����   ��  ���   ��  �   �  ������  �  ��  �  �  ��  �� �� �   �����  �  � ���  �  � � � �  �� ���    ���� �  � ���� �   �    ����    �  � �  � �  � �   � ��� ���������������������������������         , FPHPVRI.lvlib:PhCon CAMERAID.ctl          0  8x��[]lו�#Q2�8	���V6��J%]����Z�niQ�rk�*eo���tĹ$'%g���~�h���S�<(о�o-�yؗ<���=l�alZT�S�(��M6��zνwf�P������3���s��s��y��١���]��>�/׻d����7'�g�.I����h>�u�p�v�WC��'�ڗ���x��&��\=\����`�hj�%����gN�mz'��ɓ�7G|��ȹ�w��C_J��Ζ�V?OMk��V:�mM,��J���t|��Lt�WJ�;�� G�s�r8?\ђ%���;�D_)m��)��s@3\����с�M��8M�Ӏ��/�4~���;�����S@
t�i*���x��}�]��޹���x��/n�ш����w�����6�?�������W��
|_钘��C��$����3�1�2
�Юq_$Jo�H���:JJ�K�{���J�\^IM
M`Ig4P|Rq9Q�N<�F@q#gH��%�F���o�v�ϐ4�g�;ݟ��o���7B�"�I8�"�|��>�UGS�^�7?뒓�΢���v�_Zn,�V�h6��b���隞i[tYw����Lqዷ���J��J6��6��`5�zN��QO�+�����s��t��[/��ט����L���5��\����zÛO�Ϯ��c�!��:�0\��Ѷݎ��#������r�W��-�eU�2ܬB^�D8 i�B3l�c��jlZzˬ�P���Q~ff�Q5(�J��o�c-|Ek�ݢ^�QT˱�&��^e�cZ��ʦUEΦU�-�`�)�|��ڝWy����Y�3t���6���G�VM�Q�|�QP��-��Զ��1�5���uE�y�G����
�fȅ�X<�=�v��Գi�R~�z��P�bǳUL������ݳ�:[cM	���@�	0 ��5����3摐;����VXՓ"�+�����z��u
km��"K�Xp7��.u��[5=j�r ��k���W��m���>��-�[ଡ଼������ 쮙��[TK��MSl�f"���Q��q�|c��UT�W��!��QX��a �\�i5��9GX�@�<@�כ�4'�I�����
�f�n��G ���HY���<{�K��wv�&`��Z��I�o��	���~��;�v��i���6j
�FU珱cì՘��Z<)�yrڷ��� ,�SL�8�g�®��:��$Ӷc�@M��W�W<�v��y��n74��uq�ZFGT� @�-�ZvF���R�V}�yy��y���Bd�F�WX�E�"�A�T2#��O�yZl6#ht�� L�V��/�5�gF-��� �@�
�Eg�20��
�y����2����;�h���jk��.b��c
�x0Sk��B�SH��/��죰�y�X\��Z��0�S������-"6%�<�b��3��|&lcd���ݩ7bZ3Q�~��^��{�pX/���7�1��{��`ۙ���:M��Ԛ�RagǱ	Ϫ�U ��:�E��S���W������g;� bd���	���Ud�4,(��JW�����M���l33��A�^m�2���+ʆl��������|���Ø���K���E����&�ɪ�ԭ*�*�U�(<�"͹��*������M��L�i�
�/�.x��� �n�j��T�і-}#L"�U5���#��B�b��C�Z��@y�l�Zt�3$ÍA�b���X���C�_K��^�xII�pnU��[u�6淗�
�����_A���+.q:�&����s�²�O8�'��P)=���yT����_���Ju�2����:�1O�pSf��.o������.r	s�k�:m��ً�ͬ�ey?[�8����RVH�
��X m�C��<TO��mv�f͔\c&�J���nuZ�`ŞgP�xy�[����ڳW�s����BA(fZU��E.*-*v��^tbr��A��W;�ǫs%�=A��B����H�&��hC�J�kH���Yѯb��US�������N!�p[��a	H��֠���y���(��SH1q����*O ����\�wm����#4�?m&&+�]0�ESi� �@Jc�Y*3 �\��v��4(�9�������}��S |֧9�3�^XE'��8��>���xXj���)�Q2X	Z�&,Ĳl��ҡl<l��b���`�j�F�ެ���q��#�5tW�d��/%N�۬a����a�����CX҇k�
�[�=9f�h����-Q�uZ���\Q�_��e �\!
I��?������+�4e�-
�|�W��)3�CF�:��\4���G`�8����b���ia �	�%G���ކ���AX�S.-�'>Č��_�s�<4�]9���@�_e�:t����Ɲr�`Y��ZL����b2��]-�HW��LcU����H+죖���.2��p���	]p�����ؔVC�M׎�t*r2��M���C9���Y��-v6J���i�A��Su\�|�r��&}U�5�	��!�V����e����̱s��'��҇�4��#O��u������E�߁=�G�R��E�K|�Z6�8d95qe�k�U�x\�z#��i�/D�G��~n�I�(U*�@&�"/�2�>C�!u0n�oZ8^ VyJ]�]I��t�b��Whr"�����+�".V���A�6��UZ���6�;a�A�d���f�n�K�c7��A;g*�|�y�����^����[7����"��;r�`8�Z��A	mu��	�)쮂�B���A�G�dYxB�sa9���!��m��M=�"��!��t̟�A���Ķ�h��rL���Q�(���6<���2��E��*ʸ=+[B^�����t��"��u�1�F+�(�V��㡣�ZY=�+�e8;��Ǫ�G���а҅�b��f>�,`<=$��H�̎��ü$�g��z�6~��)����E�=Ӄ�����LXt�� �m�?�o��.�C��ͥ�P��ö�U���r.�1��1�,ږ,�/k&���3&�l�:�`�a���\&Ӹ?ˣ� ��i#R��Ƃ��y�f����^s�W�� ����"d{�6�P��Gu@�g;{V�`μ#C���>�f\Q�+�ó'�e������<V���z���;�o�� ~#�n�'��E�q��:�@��dW'�!Lǂ.��Z�
+�pS��C�V��řR�l���+C���^Ѳ��~���_"y4�Db�SZ���@�I���I��}��=�H�{�&�?�BHC��H`=!o���1���%�yh~�%�W�\"AڞK$��']���%����H�?�K$�����ڣ���Rw�����	���X�;#Y�}�wFb�{�`F���.�c�d�big�j�'O�ߜC�)X�#Y��_��.9gl�Nz'��%9J�%��=vOq{|���`���"[��1��Ƨ��-o2_�INv�S������0�L5����$y�����>O��:Cx�e���x�P��<~�&�CW��~�ҷ�z��gtib<�f\h3ĵ)Wt9�6գkS�h�蒧A�u��0y�=�NZ��c"'�O�
YX���y
6*C�'��ݠ�aA2@��^+�&���B�{E� �~؟!wBZ�����OȰ����4��>!ÞF�|���r��ۑ�OYK�p�O�6o�Ǧ���alc{45��C���$�G���C�=���,{o��R��Y=�bD�3�c��<B%����_�y��=�'~N����.9b�����hsIh3�h����k�'��M4�<�%�A�+�G��Z�1�����5hӹ����@.�8�}F��W�O��?��hyd��4@��x8��S�\yH�y2�%S�w�&H|e���c��I>v�q�����_�H�h<P��qvO���Ǿ5�q����c��E.��G,r���Ċ\�����>z��\쿏Y�b�)r�j��u�[�b��_�b��(r#d�"7��ȍ�ȍ�)r'�"7z��"7�ԟ�ȍ�bEn�>HEn���T�F'��En��c��t�"?v�[�3��=D��J��b��x�J�Ԙ�T�!� �+ z������Q,^=p?u����J\�B=�קumbo}�3�
Ե��B]X�������ÌS��G��6���3�����޿�äD$ �g��υ^�v_��=�K��^��>�O?P(�?P(��P^8.�g�E��!(OFQ�XRZ���~�	�/��.�� ����.�N�4UF��r|1�������nǿ�`���{��w�z|�w'�>zm�ڋګ�����7'O�      m   , BDHPVRI.lvlib:PhCon CAMERAID.ctl           e   ux�c``(�`��P���Z�+�!���FЏ�7���a �( 	���h/��>��� �l���9�2-���W)b��z�\�8Se�<� ��G                  NI.LV.ALL.VILastSavedTarget �      0����      Dflt       NI.LV.ALL.goodSyntaxTargets �      0����  @ ����          Dflt       NI_IconEditor �     @0����data string     513008047    Load & Unload.lvclass       	  ddPTH0                 Layer.lvclass         �          � (  �                 ��� ��   ������  ������  ������  ����ff  ����33  ����    ������  ������  ���̙�  ����ff  ����33  ����    ������  ������  ������  ����ff  ����33  ����    ��ff��  ��ff��  ��ff��  ��ffff  ��ff33  ��ff    ��33��  ��33��  ��33��  ��33ff  ��3333  ��33    ��  ��  ��  ��  ��  ��  ��  ff  ��  33  ��      ������  ������  ������  ����ff  ����33  ����    ������  ������  ���̙�  ����ff  ����33  ����    �̙���  �̙���  �̙���  �̙�ff  �̙�33  �̙�    ��ff��  ��ff��  ��ff��  ��ffff  ��ff33  ��ff    ��33��  ��33��  ��33��  ��33ff  ��3333  ��33    ��  ��  ��  ��  ��  ��  ��  ff  ��  33  ��      ������  ������  ������  ����ff  ����33  ����    ������  ������  ���̙�  ����ff  ����33  ����    ������  ������  ������  ����ff  ����33  ����    ��ff��  ��ff��  ��ff��  ��ffff  ��ff33  ��ff    ��33��  ��33��  ��33��  ��33ff  ��3333  ��33    ��  ��  ��  ��  ��  ��  ��  ff  ��  33  ��      ff����  ff����  ff����  ff��ff  ff��33  ff��    ff����  ff����  ff�̙�  ff��ff  ff��33  ff��    ff����  ff����  ff����  ff��ff  ff��33  ff��    ffff��  ffff��  ffff��  ffffff  ffff33  ffff    ff33��  ff33��  ff33��  ff33ff  ff3333  ff33    ff  ��  ff  ��  ff  ��  ff  ff  ff  33  ff      33����  33����  33����  33��ff  33��33  33��    33����  33����  33�̙�  33��ff  33��33  33��    33����  33����  33����  33��ff  33��33  33��    33ff��  33ff��  33ff��  33ffff  33ff33  33ff    3333��  3333��  3333��  3333ff  333333  3333    33  ��  33  ��  33  ��  33  ff  33  33  33        ����    ����    ����    ��ff    ��33    ��      ����    ����    �̙�    ��ff    ��33    ��      ����    ����    ����    ��ff    ��33    ��      ff��    ff��    ff��    ffff    ff33    ff      33��    33��    33��    33ff    3333    33        ��      ��      ��      ff      33  ��      ��      ��      ��      ��      ww      UU      DD      ""              ��      ��      ��      ��      ��      ww      UU      DD      ""              ��      ��      ��      ��      ��      ww      UU      DD      ""        ������  ������  ������  ������  ������  wwwwww  UUUUUU  DDDDDD  """"""          �������������������������������������������������������������������������������������������������+++��+��+��++��+��+�+++�+���+���+��+�+��+��++��++�+��+��++�++���+++��++++�+��+�+�++��+��+�+�+���+����+��+�++++�+��+��+��+���+���+����+��+�+��+�+��+��+��+���+����������������������������������������������������������������������������������������������������������������������������������                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                ������������������������������������������������                                                                                   
NI_Libraryd     Layer.lvclass         �          � (  �                 ���                                                                                                              ���   ���   ���         ���   ������   ���         ���         ���   ���������            ���   ���   ���   ���   ���   ���      ���   ������   ������   ���   ���      ���                     ���         ���         ���            ������   ������   ���   ���                        ���������   ���   ���   ���   ���   ���      ������   ������   ���   ���   ���   ���            ���������   ���   ���   ���   ���   ������   ������   ������         ���   ���������         ������������������������������������������������������������������������������������������      ������������         ���         ���         ���   ���         ���         ���������������      ������������   ���������   ���������   ���   ���   ���   ���������   ���������������������      ������������         ���      ������      ������   ���      ������         ���������������      ������������������   ���   ���������   ���   ���   ���   ���������������   ���������������      ������������         ���         ���   ���   ���   ���         ���         ���������������      ��������������������������������������������������������������ݪ��������������������������      ��������������������������������������������ݪ��������������������������������������������      ��̪��������������������������������������������www�����̙��www���������������������������      ��������̪�����������������������������������wwwwwwffffffDDDwww���������������������������      ��������������ݪ�����������������������������wwwfffffffffffffff���fffDDDffffffDDDDDDDDD���      ��������������������̪�����������������������wwwffffffffffffwwwffffff333fffffffffDDDDDD���      ��������������������������̙�����������������wwwfffDDDffffffwwwfffffffffwwwwwwfffDDDDDD���      �����������������������������ݪ��������������wwwffffffffffff���fffffffff���fffDDDDDDDDD���      ���      ���������      ���������      ������   wwwwww   fff   wwwfffwwwwwwffffffDDDDDD���      ���      ������   ������   ���   ������   ���   ������   ���   wwwfffffffffDDDDDDDDDfff���         ������   ���   ������������   ������   ���   ������   ���   ������fffDDDDDDDDDDDD������                  ���   ������   ���   ���   ������   ������   ���   ���������DDDDDD������������         ������   ������      ���������   ���   ������      ������   ���������������������������      ������������������������������������������������������������������������������������������               ���������      ������         ���������      ������   ���������   ������                  ������   ������      ������   ������   ������      ������      ���      ���   ���������               ������   ������   ���         ������   ������   ���   ���   ���   ������      ���         ������������            ���   ������   ���            ���   ���������   ������������            ������������   ������   ���   ������   ���   ������   ���   ���������   ���         ���                                                                                                   ��������������������������������������������������������������������������������������������������������������������������������   VI Icond                  ���               Small Fonts 	        
 
     $   (         ,        ���C              �                   ��	     LUU�@ �	�                                                   
�#>
�#>�@'>�@'>     L   ?            �x�mO�N�P����E���~��T�,�L�kmr+��ƥ����:@Iz'�93�5�)������6{[�eE:0f��^@��jO�4����`�ӭ�|�5r��/��T�ȗ�r���/��u4	�WI]��R�,���L��f�)�C�F
��$bK1�I3�wUw�\>�>E����9v졋�ؤ9 i��p�}#ʏ��b�����ʑ^}
����5\�`���p�L}���.3��\�฾hP;�����N۴��D�\�,�>k:�      w       X      � �   a      � �   j      � �   s� � �   � �   u� � �  � �Segoe UISegoe UISegoe UI00 RSRC
 LVCCLBVW  [4  {      [               4  h   LIBN      xLVSR      �RTSG      �OBSG      �CCST      �LIvi      �CONP      �TM80      DFDS      LIds      ,VICD      @vers     TGCPR      �STRG      �ICON      �icl4      �icl8      CPC2      LIfp      0FPHb      DFPSE      XLIbd      lBDHb      �BDSE      �VITS      �DTHP      �MUID      �HIST      �PRT       �VCTP      FTAB           ����                                   ����       �        ����       �        ����       �        ����       �        ����      (        ����      0        ����      X        ����      �        ����      �       ����      <       ����      P       ����      `       	����      t       
����      �        ����      �        ����      �        ����      %        ����      %�        ����      '�        ����      +�        ����      +�        ����      +�        ����      =        ����      =        ����      =@        ����      =�        ����      =�        ����      X�        ����      X�        ����      X�        ����      X�        ����      Yx       �����      Z�    PhCon CAMERAID.ctl