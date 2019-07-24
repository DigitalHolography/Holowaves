RSRC
 LVCCLBVW  Zx  p      ZX      	VRI.lvlib     � �  0           < � @�      ����            ����C��F�qn8u��y   
       תH-c�C��	!�o҅��ُ ��	���B~                                             ������B(��+�W          F LVCCVRI.lvlib:TCU.ctl      VILB    PTH0       	VRI.lvlib               $   (x�c�b`j`�� Č?@4��D3p H �O   I  $x�c`��� H120�T i4q0cS ���\�Bř �e��2�X��LP529 �@7��� �A&U        VIDSVRI.lvlib:TCU.ctl         B  �x����kA�gv]5f&�/��=%X*���"�fo
U��E0�l]�R
���=��-%��A/�[�C��xYgvf�
��������fWE�y{u��R1BW��6�>z|���i"Ƶ����Q���W��s-���L!�k<���h���i�:_N"r�<�A�(�D������޼�H�*o�Y�S�Wǧ[W��޳�R�sٷ5=o�ck�W��E���f4�M�
��m��4k���W�:�:�:���N�)�S���J�/�<x��~W�Y��1nofy=��6�#s�Yٯ�H�2�e�ߧ�	��D�4�A��l�K4�~Ð988�t���'N��t�I�p
��)H��t��S�NQ:<��ߟR�W��#C�#곑�J�Ӹ���0\�=�+:��Ѡ"��XQ(�P�����-�׼S���}�k.���o���}~��N��\M��l^�Z4 +Ӡ�ƙ����|�9�
�@G�r�S�]�[h˷}C�o���h��u]U�X\b��<RⳲ�z�~R��3��zIC���ܫ����[����;�     �  13.0.1       �   13.0    �  13.0.1       �   13.0    �  13.0.1                        ^  ZPhCon.dll

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
     ���������������h���-��-M���m���m������������������  �  � D� �� ��� ��� ��� �������R������T�aɊd�  �dOɒf��\�M���C�R�]����   �����������������UUUUUUUUUUUUUU_�UUUUUUUUUUUUUU_��U�\U�U�\\�\U\_�U��\U�U�\U�\��_��U��\U���U�\\\_�UU�\\���\U�\U\_�UU�\\U��\U�\U\_�UUUUUUUUUUUUUU_�UUUUUUUUUUUUUU_�UUUUUUUUUUUUUU_��������������������  �  �   ��������� �   ������������   ��������������� �������������  �������������   �������������    ������������� � ������������ � ��������� ��  ��������� � ���� �� ���  � �              �� �� �  ��� �� ���� �� �� � ��  �� ���   ��  � �� �����������������   �������������������������������������������������������������������������������������������������+++��+��+��++��+��+�+++�+���+���+��+�+��+��++��++�+��+��++�++���+++��++++�+��+�+�++��+��+�+�+���+����+��+�++++�+��+��+��+���+���+����+��+�+��+�+��+��+��+���+���������������������������������������������������������������������������������������������������������������������������������������+�      ���     ��        ������VV�������+��    VV+       ��+�����VVVVVVVVVV�V+V�VV       ��  +����VVVVVVVV������V�VV�VV� ��    ���VVVVVVVV������V������� ��      +�VVVVVVV��������������+��       �+VVVVVV�����������������         ��VVVV�����V���V����+�� ��   ��   ��VV����������������� ��  �  � �  �+�V��+��������� ���  � �    �  � �+ � � ������+ ������ �  � � �  �  � �  +�� �  ���  �  ��   � �  ��  �    +    ��                              �����   ��  ���   ��  �   �  ������  �  ��  �  �  ��  �� �� �   �����  �  � ���  �  � � � �  �� ���    ���� �  � ���� �   �    ����    �  � �  � �  � �   � ��� ���������������������������������           FPHPVRI.lvlib:TCU.ctl         �  H|x��\]p�u�R2��V��Z�2��!F�m1nK��D���e����^ +���"U�g&�;n��$U&n���3m�f\?�~H=�Ng�i܇����M�ԗ>8c�)Ğs��ݻ��"d��М�
ܽ��~��,Mȧ��7ɗ�DK�>�m����rc$I����$}^�9�~��$]���77����o��\�9��ruW����o����C@,�Ծ`�޳�3��t���e���S�O��i72��$�������u��v�h�#��+}���V2x�g$y���ijO�W�v2k� ���UN�+�U ֒$����_7}1�z6p1�=].nv�=:�q3k�|O��>E�O���7Qv�Ժu!�����o�7M���m�z�JS+f�N%%�2��������h+�����dr�o׿���������1pG�I-=�皤�X�"�F�� Oj��r_tK_����4�EO��4	�q��Π�I�H��蛟</���2�c��@�~�E��jσ�>2踇t�о���&/��X ���$l�'���E����J`r#4
�����'�I���21}��]�����qh���leҶ�F��JM�n��陶EguG�1�9.������ى�ģsC���\g+Q�sE�zzYy�������3�t���ix�q����N��2��Yc��\uç�Y�x���i��{l<���Qn�릖��p�x���X�zZ�e��h[�;�l�"`k�@ْ�,��X���Y�V��}[�e[�`��gU}yk�#Zr��*��X��W���@��断"R6�2���H��ynkw\�
���\fȄ�U5&��G�M�Q׼�(`�J +����*(f��1�x]�o\�p����|h	3��X܁=�v�)��t�0}�z��P���g�����ڶ�,[dU	���@�` ���m��3f��F�i󍅩�`c�=�?8�l�ݧΝ;Ka���e`�y�w�ݥ�\@uˠ�GMwsCv`q}Q7������^��P�Лo��p�����i�q����R�z�J�L����(J8�/�ӏN�8F��U8�!0*�s?t���9�����h�g H�z����3i<Z�T�AR�جA��,q=�uG�r�E`�ٝP�����UH������2�W��	���8B��H;�j�@R%T��㷡�a�J�a`-���<9��PZ���X��)F[���®�f�NX�iݱK �R��s����<ר׫� OǺ� �C)����Pt˥�C(�I
5]+�8O=qi��>�B�J��/V��Er��dTF����t�Z����b0�R-�^66k��Z�����Y�"h%���@�*T�c4������Pl8<8(�X̣Ep����8 ۺ��-vSpC�DŃ��z�^(~����A�t6�tyV�`��y
�h�iAG*rF,�B��MIg��X4B�L�j~2lcd��*��(W:"Z2Q�>�L/��]8���V�̅�{���ڙ:#��R�*�RUw�+hv;6�Y���
��t��֎h�7�B�1�iH�y�Ì"FvJ��p�|[Q�gGDÂ��tՓz�nZ�e�;.0��bE�	]�^Q6d��ӁdX#��~趉s�a����۩�L�� ����	q��Wu��:�
P=
��Hs.%8�>�v��	-Wm���a��U�۹R)Z��6ڲ�/�I����"?w��Q�<=�tHR�vv�6���N8���b~����=��ɡ���d�'Ǝ+锃έ��<s��Y���ı��|1����t�\Xq��si�K�)�>0��
��T
�b*�!�=�
���0����v�U���p�9����Y��23@p��%Vuy�^����n�s86�x"��QGo?:�����cC��?�;���u|Hp�
2�X m_��y(�na�����ip��D
]�ֺ֨E�[�A-��I�A�3L<I��N�rB0�*:�-rQ(hQ�K��ڠ}�p�3��o¸�p=^��>:B''
YJ'hՄ��m�R�[)W�� +�U�԰�b
T9ü��+����(K�U�o�x���rP��B��ӄLLx���"���;l������31Y�1��"��HK RNR���E?!���O��}ع��Y6��Į�7�:�{1�)�A,��:Iv�a�����R�UdN	���Y�JP��˲ц��e�a[�g�;`U�6��\	χ��A����$�G?x(I�}��*f�R�
�>+�wVdaI��"�?lI�r��
��2hC��[�.�`���6�o��e �\�
I��/b���S�	�s
��b�����r�l��E�4x�߆�Pt����,�1�a�a��,��P`�� Prd`}�!��mHN��Y0�вx2�C�HY��U]�0��C3ؕC��T��]��@�9ب)���E�>��!&SM�jD��d+ڵzC GZa��`�u��߅�O肫�}n��6xcYZ�W];zLҩ��<V�����f��;�X����	�O�q�Aʉ_1����H/yL��a��4.˶F�2��8A��>�A�	2�TzVwʾ/� Y�\�o����z$p(E]���fc�@�SW&��^4����S��s�,��������[�<J�E" "/�2�>C�!u0n�oZ8^ y�=��]I�Qu�`��'i��g���'�E�*�L�i��VW�������	j4�ƃ��0�[����I���M� ���~�q�<`���a�g�M~v��/x�#u[��2�%�֨z&���
z�,
��R���@�3VJR��*�Ԣ^��T)~�c�d,D�%�7��1���G���[�r�+.e�?�s�(��!��B��D�K�� V�m��*�h���b��CGq=��z&\+�e8;��Ǣ�G���а҅�b��f>�`,`<r4H��9��Gy�yI�� �6m�"CSFGS�lZ��A�y�LXt�� �m�?ϯ^ї]Z���ͥ�P���ڧ�_[9��A1��19+ږ!�_Mw�eL�R��:�@�0A�\&Ӹ?ˣAZW�F�~Kł��y�����^�#���A�_aEj���C�����6u�V�`μ$C�����A]Qg+s�ó'����9�y,0���]�	Z9v�o�� ~#�n�'��E�q��:�@��dW'�!Lǂ.��Z�
+�pS��C�T
��řR������	�e�=�e������}�z�_��kb�����_��
���hb�Z��U�ȋ&��E�r~��[^4ў!/i�6yi�"6�/������3��1a�W�M��3��ڭ_4����	�myѤ�5�JS{*xѤ[ӂM.�?�/��������5�������_%�D^�Rӓ��{%g��������⽒��F߮RU/k���&y+��3�Y�<'��>L>N�hu�g�^����\��]�F�0��o��%G����C��K�u\
�[/}�T{zC�t������r#�AP�W^�����K��5�o��"�^�~����K�?UU�����W��:��O�����^0�K��5`�o�&v)��VvNT��?���8�(�^X'L%¢�$����T����?����/�#�:��d�����(��mG�n5J?����D����(�����Q��1Q���yD���(�|0�t�=J�?Q:�ӣ�;>J�?J�b�tWL��Pt��ɋ�h��胉ң�Q�/�(�ם�?��Q���G�1Q�;&J�&:�ˤNnD����������F����xm��������p�Ǝ�k����w��kbL����q�j$\m���w�]�8Z��hM���њ��њ�ԶGk⑘hM�F�l��m��&	1�#h�����Y�_��gJ{��'|kW�����IS�sc�#6��!����G���~>�~���,p@��v����Y����R``�/��'2k	N5ǥN���޶0ID������m����wk/��ԥHs?����Yغ4i�4��̯:�Y�'<����@���o M���piv!��nN��G��Y��H���Vx�4��j���� ���-��S��
�=�=�&(8�>�GB$_G$�B�$^�*�ɷ7D��VOt|o����m�0��;	��O�$����c�|�61L���T<����0l��b��-b���i5<��_��wG������?��.�i��ģ�P<$kE����b�j;���W�(��([���Eq=�{�Q�z�bۂ�w6D��;�����v��= ��;
���Q ��� ���]7c@|w�=3��H�7����~�s���f�S��+M�D~�c?HO�49��J?���iM�|���Ϧ���z��q6������wO���e��2ԛ<��P�      �     BDHPVRI.lvlib:TCU.ctl          e   ux�c``(�`��P���Z�+�!���FЏ�7���a �( 	���h/��>��� �l���9�2-���W)b��z�\�8Se�<� ��G                  NI.LV.ALL.VILastSavedTarget �      0����      Dflt       NI.LV.ALL.goodSyntaxTargets �      0����  @ ����          Dflt       NI_IconEditor �     @0����data string     513008047    Load & Unload.lvclass       	  ddPTH0                 Layer.lvclass         �          � (  �                 ��� ��   ������  ������  ������  ����ff  ����33  ����    ������  ������  ���̙�  ����ff  ����33  ����    ������  ������  ������  ����ff  ����33  ����    ��ff��  ��ff��  ��ff��  ��ffff  ��ff33  ��ff    ��33��  ��33��  ��33��  ��33ff  ��3333  ��33    ��  ��  ��  ��  ��  ��  ��  ff  ��  33  ��      ������  ������  ������  ����ff  ����33  ����    ������  ������  ���̙�  ����ff  ����33  ����    �̙���  �̙���  �̙���  �̙�ff  �̙�33  �̙�    ��ff��  ��ff��  ��ff��  ��ffff  ��ff33  ��ff    ��33��  ��33��  ��33��  ��33ff  ��3333  ��33    ��  ��  ��  ��  ��  ��  ��  ff  ��  33  ��      ������  ������  ������  ����ff  ����33  ����    ������  ������  ���̙�  ����ff  ����33  ����    ������  ������  ������  ����ff  ����33  ����    ��ff��  ��ff��  ��ff��  ��ffff  ��ff33  ��ff    ��33��  ��33��  ��33��  ��33ff  ��3333  ��33    ��  ��  ��  ��  ��  ��  ��  ff  ��  33  ��      ff����  ff����  ff����  ff��ff  ff��33  ff��    ff����  ff����  ff�̙�  ff��ff  ff��33  ff��    ff����  ff����  ff����  ff��ff  ff��33  ff��    ffff��  ffff��  ffff��  ffffff  ffff33  ffff    ff33��  ff33��  ff33��  ff33ff  ff3333  ff33    ff  ��  ff  ��  ff  ��  ff  ff  ff  33  ff      33����  33����  33����  33��ff  33��33  33��    33����  33����  33�̙�  33��ff  33��33  33��    33����  33����  33����  33��ff  33��33  33��    33ff��  33ff��  33ff��  33ffff  33ff33  33ff    3333��  3333��  3333��  3333ff  333333  3333    33  ��  33  ��  33  ��  33  ff  33  33  33        ����    ����    ����    ��ff    ��33    ��      ����    ����    �̙�    ��ff    ��33    ��      ����    ����    ����    ��ff    ��33    ��      ff��    ff��    ff��    ffff    ff33    ff      33��    33��    33��    33ff    3333    33        ��      ��      ��      ff      33  ��      ��      ��      ��      ��      ww      UU      DD      ""              ��      ��      ��      ��      ��      ww      UU      DD      ""              ��      ��      ��      ��      ��      ww      UU      DD      ""        ������  ������  ������  ������  ������  wwwwww  UUUUUU  DDDDDD  """"""          �������������������������������������������������������������������������������������������������+++��+��+��++��+��+�+++�+���+���+��+�+��+��++��++�+��+��++�++���+++��++++�+��+�+�++��+��+�+�+���+����+��+�++++�+��+��+��+���+���+����+��+�+��+�+��+��+��+���+����������������������������������������������������������������������������������������������������������������������������������                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                ������������������������������������������������                                                                                   
NI_Libraryd     Layer.lvclass         �          � (  �                 ���                                                                                                              ���   ���   ���         ���   ������   ���         ���         ���   ���������            ���   ���   ���   ���   ���   ���      ���   ������   ������   ���   ���      ���                     ���         ���         ���            ������   ������   ���   ���                        ���������   ���   ���   ���   ���   ���      ������   ������   ���   ���   ���   ���            ���������   ���   ���   ���   ���   ������   ������   ������         ���   ���������         ������������������������������������������������������������������������������������������      ������������         ���         ���         ���   ���         ���         ���������������      ������������   ���������   ���������   ���   ���   ���   ���������   ���������������������      ������������         ���      ������      ������   ���      ������         ���������������      ������������������   ���   ���������   ���   ���   ���   ���������������   ���������������      ������������         ���         ���   ���   ���   ���         ���         ���������������      ��������������������������������������������������������������ݪ��������������������������      ��������������������������������������������ݪ��������������������������������������������      ��̪��������������������������������������������www�����̙��www���������������������������      ��������̪�����������������������������������wwwwwwffffffDDDwww���������������������������      ��������������ݪ�����������������������������wwwfffffffffffffff���fffDDDffffffDDDDDDDDD���      ��������������������̪�����������������������wwwffffffffffffwwwffffff333fffffffffDDDDDD���      ��������������������������̙�����������������wwwfffDDDffffffwwwfffffffffwwwwwwfffDDDDDD���      �����������������������������ݪ��������������wwwffffffffffff���fffffffff���fffDDDDDDDDD���      ���      ���������      ���������      ������   wwwwww   fff   wwwfffwwwwwwffffffDDDDDD���      ���      ������   ������   ���   ������   ���   ������   ���   wwwfffffffffDDDDDDDDDfff���         ������   ���   ������������   ������   ���   ������   ���   ������fffDDDDDDDDDDDD������                  ���   ������   ���   ���   ������   ������   ���   ���������DDDDDD������������         ������   ������      ���������   ���   ������      ������   ���������������������������      ������������������������������������������������������������������������������������������               ���������      ������         ���������      ������   ���������   ������                  ������   ������      ������   ������   ������      ������      ���      ���   ���������               ������   ������   ���         ������   ������   ���   ���   ���   ������      ���         ������������            ���   ������   ���            ���   ���������   ������������            ������������   ������   ���   ������   ���   ������   ���   ���������   ���         ���                                                                                                   ��������������������������������������������������������������������������������������������������������������������������������   VI Icond                  ���               Small Fonts 	              =   (         2        ���C              �                   ��	     LUU�@ �	�                                                   
�#>
�#>�@'>�@'>     L   ?          D  x��Q�N�Pz)my����M\���KӨ!�#D][��&�k�0.�>������3I3s�93� ,4l� v�~���ߕ/Y�y��R>�(���	:��,��0�qR]�jx�|�.�ș�g[MWF2ޔP�-5 ;)�i��
v�K|�_ �qz7�ޢ�Y��~�i�c{��JP P��
4�0P�V��S����0��6x��t�C�i�*�2@��t�%2/�Xk�~��D��1|°v8�`��O	L}Bn1f��]�q�����5�V6/K�n,��E��p�Zh�a�ʐ�&u�����Y)�:%_��nC�   w       X      � �   a      � �   j      � �   s� � �   � �   u� � �  � �Segoe UISegoe UISegoe UI00 RSRC
 LVCCLBVW  Zx  p      ZX               4  h   LIBN      xLVSR      �RTSG      �OBSG      �CCST      �LIvi      �CONP      �TM80      DFDS      LIds      ,VICD      @vers     TGCPR      �STRG      �ICON      �icl4      �icl8      CPC2      LIfp      0FPHb      DFPSE      XLIbd      lBDHb      �BDSE      �VITS      �DTHP      �MUID      �HIST      �PRT       �VCTP      FTAB           ����                                   ����       �        ����       �        ����       �        ����       �        ����              ����      $        ����      L        ����      �        ����      �       ����             ����             ����      ,       	����      @       
����      P        ����      d        ����      x        ����      #�        ����      $`        ����      &d        ����      *h        ����      *p        ����      *�        ����      <0        ����      <8        ����      <\        ����      <�        ����      <�        ����      W�        ����      W�        ����      W�        ����      X        ����      X�       �����      Y�    TCU.ctl