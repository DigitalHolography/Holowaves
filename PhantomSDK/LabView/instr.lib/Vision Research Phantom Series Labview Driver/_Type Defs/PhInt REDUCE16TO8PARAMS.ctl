RSRC
 LVCCLBVW  V�  �      V�      	VRI.lvlib     � �  0           < � @�      ����            �IKP�2�K�(�h֖B�   
       �֛U]D�H��S��0���ُ ��	���B~                                             5��Q]!�z�v��K          Z LVCC%VRI.lvlib:PhInt REDUCE16TO8PARAMS.ctl      VILB    PTH0       	VRI.lvlib               %   *x�c�b`j`�� Č��� �8�� ��@      I  $x�c`��� H1200}Ҭh�`Ʀ6@6��셊31�͌@1�P1f��� ~�n���(�      4 VIDS%VRI.lvlib:PhInt REDUCE16TO8PARAMS.ctl         v  dx�K`d`�4�0� ���X���!9?%���g� &8p�҆��`F��O���@s���P��#㸣H����E帋
��Y@�����#<��}TD:}TX�*^���]��4���B���U���jB)�a� �.�$PO7ȼF��CT:'� Y�����#�_�+P%���w,:� ���
��<	��D>`��� �m �`s]%����x�����Ú�pt� U��B�$
V��v�A��_"3�T�#��� �
�� ��G�a�C?�3��(��-����iM �� ie r ;$B8t�k[�'1�d�ǈ�X�����+2�n �Qm�        	x�c```dd         �Q  13.0     �   13.0     �Q  13.0     �   13.0     �Q  13.0                      ^  ZPhCon.dll

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
     ���������������h���-��-M���m���m������������������  �  � D� �� ��� ��� ��� �������R������T�aɊd�  �dOɒf��\�M���C�R�]����   �����������������UUUUUUUUUUUUUU_�UUUUUUUUUUUUUU_��U�\U�U�\\�\U\_�U��\U�U�\U�\��_��U��\U���U�\\\_�UU�\\���\U�\U\_�UU�\\U��\U�\U\_�UUUUUUUUUUUUUU_�UUUUUUUUUUUUUU_�UUUUUUUUUUUUUU_��������������������  �  �   ��������� �   ������������   ��������������� �������������  �������������   �������������    ������������� � ������������ � ��������� ��  ��������� � ���� �� ���  � �              �� �� �  ��� �� ���� �� �� � ��  �� ���   ��  � �� �����������������   �������������������������������������������������������������������������������������������������+++��+��+��++��+��+�+++�+���+���+��+�+��+��++��++�+��+��++�++���+++��++++�+��+�+�++��+��+�+�+���+����+��+�++++�+��+��+��+���+���+����+��+�+��+�+��+��+��+���+���������������������������������������������������������������������������������������������������������������������������������������+�      ���     ��        ������VV�������+��    VV+       ��+�����VVVVVVVVVV�V+V�VV       ��  +����VVVVVVVV������V�VV�VV� ��    ���VVVVVVVV������V������� ��      +�VVVVVVV��������������+��       �+VVVVVV�����������������         ��VVVV�����V���V����+�� ��   ��   ��VV����������������� ��  �  � �  �+�V��+��������� ���  � �    �  � �+ � � ������+ ������ �  � � �  �  � �  +�� �  ���  �  ��   � �  ��  �    +    ��                              �����   ��  ���   ��  �   �  ������  �  ��  �  �  ��  �� �� �   �����  �  � ���  �  � � � �  �� ���    ���� �  � ���� �   �    ����    �  � �  � �  � �   � ��� ���������������������������������   4 FPHP%VRI.lvlib:PhInt REDUCE16TO8PARAMS.ctl         �  '�x��ZMl���X/ ִ�D��u�M��NCc!u�u�-�c�N��4�w����,���T��2H8U�P	���+�C/heу���T��r�ʡ���q���̼];&��R6�y�������_�n��f�<��1r��i[�yC}��n/��5�o1w�C�K�Or7͇v̟�������j�y#�Q�Sl��x�
;�O���~4z�8���F߸#�:d<\|Ӽ�{ft�����>�c�=4i�4��с�͑%�㛣�vp2D��1�V��F�?� ��2�e~�
��cƻﾛ=_�~@����L��u ��p����)й�Щ��5�N@�����"@���泄Vex��µv����3�#�O�����?�an~���q5o��.wnkh�l! �9��6��x^�1���"�+��W�a�e�N��<+l1Xy�hd�x�`c��Q9Z��-T.�/�̮\||�\+_X��)�,a�1:fB�c�Ō�*ۃ��6��t���l,����w�y
�w�胣�S�o�ڂQM-`g�$FRM���g�c��ʍ�&�x+�1�:L�n���Ԛ��)�u�r���	���=�dV�G<�Xy��KU)�x�mt��,�����jj녟>���+��~ڱ���?��ն���v��A)�~ȝf+�+d��5+�s�x��[X��a�.Z�[f��Nr�y�燼�{v8��Wj] Z��1�q��6�7<���A�kr	w;��i~�T��Z��-�F�Y���
<�%���vO X��������VL-�]�s:�N���D��~�Es�d��Y��pH$�U�-��������5����h��i��j����܇>\��"�|V�Uϱ>��P�#_���ioXb�=��5�*�Ϭn&��s��.w8��P<X[�Ok�)���t���g.^<ϰ�lA2��
�B���@m`�g3'bNx�"�и�f9�������W-ؠ+��V`��D�t��M���Q��,hj�r)t�!w�|��ʝ鏕ꅅٓLcyN�A��PEe�ua�>
6'�P���ú4'2 ��bkFN�)�6RMI�b����i9R7�X��Zk ��`]���.�&|���~���T�	iŹ��5�v��W��O�«�չo ��4<�ЖH�I��Lt�4���Ơ��T_�釨���j�OV�Y'�`S+ᵥ�w��Ҽw:.GY0lH�84�Gt�l��(�2��Q*�b��n.���^�K����\k����z����PB�CH%�*��t<�ʮ��a?[�	�jr�Ԭ��1�$�O����uH%���,����:�dY��]�s�z���<�x��0F`�@m]��=~�Rp,S�f��F��O������k�G��ajԺz���:�2��|�c!ZDjJ�xJŲ�1	��^�ƨt�?n��B�p�Q�<g���;�]8�am%V(R�	�f��ędq��+��k��
ɾ�NDV(���)�!9k_8�H(x5�|��v�p���Q���&�=�o��A��iVPR6��z�j�����l���&�Ȫ�d��d�eC���}���j�մ^�=�8���|�ڢh�(�8܀�?�r'��kyuާV�U�("���s����ܞ��M��t���kb1낗[q�x��htW��O�l[�Y���&�Ym�4ϖ�i:�y��Y�V��3�~��X�K��:l-"+=w┖N�3�ܪm��8�oϝ,}_l���Ζ��
��㔀Y���)�=�����z�@Q��J!"T�Q!U¯Y��ǡ�ECrw�C}鴲:ҁq����ȹ;�:wCѶw�k��;!(��\�My�;d�S3'�񏍭���L���u�«S�
U�������5��("�,����wcR���2�b��ֺ��6@�=�P�Dy��h&��c�����l�$s�z ڢ��B�J]*��6��A��bR_�~!#Q�k)�6��˵)���u����*y�"U�j��bR��W�S��9e�C��]&VbDyX����,O�Ʀ����R�t��٪H ����\�t���9��I����p�����Ei"�h8����(���������]ͦ
�y���S z�OsJgVX%#��8��7g���D-�SR*�d���S!<�e�h�P5��2�p2؁Vߞbt>B.�Hd-+T%99�aQ�p��ZN�.u�����{Jf���]�u�?jI�䈰;Ch�L�!�˓u�b8L��H�bφ������r�E�3����*V���?S*�����R�7�͈��� y9ѝ��"">,x|B�+�[���(�L�
(52L}��!abm$� MR�<�rI��D2��G>�x����`W�f�U� KT�U]Cg��
l�T��muqj�|�S%S�f��*�,-	�4V�۝Xz���-�
c�X��+I��]�wn+�6����EYn�w�,&s���?�5QN��(��a��zŊ,�6$$6��<qR�����jC#�q�4I�V�b�py�7�2����HT�L��$�O�(R�y+h&� �)gir���5а�z$�P���(5I�^ۧ'YMMB��:V݉Rg�\���S�*6�����In�I�(U�^ $`Q�RwZ�!�>�yC4-�_��"���V҉�P1��}�F��]���q��X>n;<�Z�aU�;8wB�e�x0����W�H�-<�Љ0��>��8�P�����I��M��8���E1�?�~G�]� �9/�%�����uWiπ�kcS:HW�p�*T�%� 6��61���*��G�4�R�LǓ�,�ӓbËc�cr;�_G�(r��t{����K��Ot�八h��q��B%�$/NK��v6���Z��F�D�O��fz��V&B*r�lv���z�G��CU��3�{9��3��K7��Is�B	��f�ݴ����g��z�6qQ���åԢZ����ACPZ�g&,�Au��63��׬��5q��Rm(�g�!����kY+26&��"&�d�2N�˚Cv7zƄ=�m�06K�c"��4���X9M�z���J�t��\ac��ג��D���؊*�x/�N*B�ɨ�{�ٳ�s�bb& ��:ʂ��Z��=ŏ��ظ8̉�c�Ïx�w�J�ڱS�����4��uk=~�Y��P��k�	��Nuujat�}�ԒUX�G�GO
�F#�D�.͔�/;��;b�gwGl{��Y��uw����;Ҭl?�J��~Ԩp�%���#�osF� 0��wG SL���������*��1_L��fzw���{�;r���'�K�ݑ%����9����D�������0@�6�6h"53{��S�{ǜ��O�^/h�B0�3�O$��	Y���+Ȋ�����Q���(��܌�}�jS��gǜ�lΎ^�	�%�w�2����{��=4asti���:�[��r���#�X���߻�����V|woθ�7�������C���ܬ�>7�]�ܽcNW����~������ 7���_�&~����;�a�Q�����<�=Of�_�]�	�.�\��i.}�K<�v��v�v��<�\�)�ި������s�����
�G�&�#��6p���p���lmy��{І�8yuǜ����~�J�������oHu��o�X����?ҫq[���=���{i�C�o���o������       ,   4 BDHP%VRI.lvlib:PhInt REDUCE16TO8PARAMS.ctl          e   ux�c``(�`��P���Z�+�!���FЏ�7���a �( 	���h/��>��� �l���9�2-���W)b��z�\�8Se�<� ��G                  NI.LV.ALL.VILastSavedTarget �      0����      Dflt       NI.LV.ALL.goodSyntaxTargets �      0����  @ ����          Dflt       NI_IconEditor �     @0����data string     513008047    Load & Unload.lvclass       	  ddPTH0                 Layer.lvclass         �          � (  �                 ��� ��   ������  ������  ������  ����ff  ����33  ����    ������  ������  ���̙�  ����ff  ����33  ����    ������  ������  ������  ����ff  ����33  ����    ��ff��  ��ff��  ��ff��  ��ffff  ��ff33  ��ff    ��33��  ��33��  ��33��  ��33ff  ��3333  ��33    ��  ��  ��  ��  ��  ��  ��  ff  ��  33  ��      ������  ������  ������  ����ff  ����33  ����    ������  ������  ���̙�  ����ff  ����33  ����    �̙���  �̙���  �̙���  �̙�ff  �̙�33  �̙�    ��ff��  ��ff��  ��ff��  ��ffff  ��ff33  ��ff    ��33��  ��33��  ��33��  ��33ff  ��3333  ��33    ��  ��  ��  ��  ��  ��  ��  ff  ��  33  ��      ������  ������  ������  ����ff  ����33  ����    ������  ������  ���̙�  ����ff  ����33  ����    ������  ������  ������  ����ff  ����33  ����    ��ff��  ��ff��  ��ff��  ��ffff  ��ff33  ��ff    ��33��  ��33��  ��33��  ��33ff  ��3333  ��33    ��  ��  ��  ��  ��  ��  ��  ff  ��  33  ��      ff����  ff����  ff����  ff��ff  ff��33  ff��    ff����  ff����  ff�̙�  ff��ff  ff��33  ff��    ff����  ff����  ff����  ff��ff  ff��33  ff��    ffff��  ffff��  ffff��  ffffff  ffff33  ffff    ff33��  ff33��  ff33��  ff33ff  ff3333  ff33    ff  ��  ff  ��  ff  ��  ff  ff  ff  33  ff      33����  33����  33����  33��ff  33��33  33��    33����  33����  33�̙�  33��ff  33��33  33��    33����  33����  33����  33��ff  33��33  33��    33ff��  33ff��  33ff��  33ffff  33ff33  33ff    3333��  3333��  3333��  3333ff  333333  3333    33  ��  33  ��  33  ��  33  ff  33  33  33        ����    ����    ����    ��ff    ��33    ��      ����    ����    �̙�    ��ff    ��33    ��      ����    ����    ����    ��ff    ��33    ��      ff��    ff��    ff��    ffff    ff33    ff      33��    33��    33��    33ff    3333    33        ��      ��      ��      ff      33  ��      ��      ��      ��      ��      ww      UU      DD      ""              ��      ��      ��      ��      ��      ww      UU      DD      ""              ��      ��      ��      ��      ��      ww      UU      DD      ""        ������  ������  ������  ������  ������  wwwwww  UUUUUU  DDDDDD  """"""          �������������������������������������������������������������������������������������������������+++��+��+��++��+��+�+++�+���+���+��+�+��+��++��++�+��+��++�++���+++��++++�+��+�+�++��+��+�+�+���+����+��+�++++�+��+��+��+���+���+����+��+�+��+�+��+��+��+���+����������������������������������������������������������������������������������������������������������������������������������                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                ������������������������������������������������                                                                                   
NI_Libraryd     Layer.lvclass         �          � (  �                 ���                                                                                                              ���   ���   ���         ���   ������   ���         ���         ���   ���������            ���   ���   ���   ���   ���   ���      ���   ������   ������   ���   ���      ���                     ���         ���         ���            ������   ������   ���   ���                        ���������   ���   ���   ���   ���   ���      ������   ������   ���   ���   ���   ���            ���������   ���   ���   ���   ���   ������   ������   ������         ���   ���������         ������������������������������������������������������������������������������������������      ������������         ���         ���         ���   ���         ���         ���������������      ������������   ���������   ���������   ���   ���   ���   ���������   ���������������������      ������������         ���      ������      ������   ���      ������         ���������������      ������������������   ���   ���������   ���   ���   ���   ���������������   ���������������      ������������         ���         ���   ���   ���   ���         ���         ���������������      ��������������������������������������������������������������ݪ��������������������������      ��������������������������������������������ݪ��������������������������������������������      ��̪��������������������������������������������www�����̙��www���������������������������      ��������̪�����������������������������������wwwwwwffffffDDDwww���������������������������      ��������������ݪ�����������������������������wwwfffffffffffffff���fffDDDffffffDDDDDDDDD���      ��������������������̪�����������������������wwwffffffffffffwwwffffff333fffffffffDDDDDD���      ��������������������������̙�����������������wwwfffDDDffffffwwwfffffffffwwwwwwfffDDDDDD���      �����������������������������ݪ��������������wwwffffffffffff���fffffffff���fffDDDDDDDDD���      ���      ���������      ���������      ������   wwwwww   fff   wwwfffwwwwwwffffffDDDDDD���      ���      ������   ������   ���   ������   ���   ������   ���   wwwfffffffffDDDDDDDDDfff���         ������   ���   ������������   ������   ���   ������   ���   ������fffDDDDDDDDDDDD������                  ���   ������   ���   ���   ������   ������   ���   ���������DDDDDD������������         ������   ������      ���������   ���   ������      ������   ���������������������������      ������������������������������������������������������������������������������������������               ���������      ������         ���������      ������   ���������   ������                  ������   ������      ������   ������   ������      ������      ���      ���   ���������               ������   ������   ���         ������   ������   ���   ���   ���   ������      ���         ������������            ���   ������   ���            ���   ���������   ������������            ������������   ������   ���   ������   ���   ������   ���   ���������   ���         ���                                                                                                   ��������������������������������������������������������������������������������������������������������������������������������   VI Icond                  ���               Small Fonts 	              k   (         ,        ���C              �                   ��	     LUU�@ �	�                                                   
�#>
�#>�@'>�@'>     L   ?           �  ox�u��N�@��v�^DE����MòDѐHl���B��4��ĥ���ƽO�1'39�������>^z�0�u���|-[������N�Ȧ���e8������t���zQ?�ƝI�qFX��H��I��Ɩ0kI@El"V��������3n�n�q�2��)u�\<|�Z�C�\T5�["�s�]E6���K5.�e���QW\�!����_�_b��9�'f�.G�Yt�J9���,�      w       X      � �   a      � �   j      � �   s� � �   � �   u� � �  � �Segoe UISegoe UISegoe UI00 RSRC
 LVCCLBVW  V�  �      V�               4  h   LIBN      xLVSR      �RTSG      �OBSG      �CCST      �LIvi      �CONP      �TM80      DFDS      LIds      ,VICD      @GCDI      Tvers     hGCPR      �STRG      �ICON      �icl4      icl8      LIfp      0FPHb      DFPSE      XLIbd      lBDHb      �BDSE      �VITS      �DTHP      �MUID      �HIST      �PRT       �VCTP      FTAB           ����                                   ����       �        ����       �        ����       �        ����       �        ����      0        ����      8        ����      d        ����      �        ����      �        ����      h       ����      �       ����      �       ����      �       	����      �       
����      �        ����      �        ����      �        ����      #H        ����      #�        ����      %�        ����      )�        ����      *        ����      8�        ����      8�        ����      9         ����      9l        ����      9t        ����      Tx        ����      T�        ����      T�        ����      T�        ����      U8       �����      V0    PhInt REDUCE16TO8PARAMS.ctl