RSRC
 LVCCLBVW  Z�  u      Z�      	VRI.lvlib     � �  0           < � @�      ����            	�9wu�-@�W;����o   
       ���8@��w��#�,��ُ ��	���B~                                             ����K�H.�sf���          N LVCCVRI.lvlib:PhInt IH.ctl       VILB      PTH0       	VRI.lvlib               &   *x�c�f`j`�� Č?@4��D3p@H �p!     I  $x�c`��� H120�� �,h�`Ʀ6@6��셊33@��
e��@ř�j r,
@��n��&�      & VIDSVRI.lvlib:PhInt IH.ctl              �x��ӽkA 𷻃n±{�!Grńl���%�-��98ȕ���`���Y��aYZ�X��B.$p��,im�JA!IH��ٯ��Ap���{�{�,̛ /�����܀-X��x0Z1Kc^s�(F�yk,F�� �+wrnot���2��&���]������ś8���.⤐��.����>�;�r#��Y����p�?ԋ~����Y� 8������۱�m"��ү����Haoד�)����f*n7���M��d|}e*���R�%,UC��t�*�׈׈א�T�N�N����������9q����C�!� wT�%�w��*�$�$�Dޔ|oi�j���b &���?�J�V�.�0���K��bt����5�)k��о\�Сl���_����ecA�_?iWA'���YQ�"�(sE���3?���I��?N
Sߓ�-�K��3��0���Y�{�=�0����H�o1ʣ^=?+������87f����?��j����qi�K��7�      �  13.0.1       �   13.0    �  13.0.1       �   13.0    �  13.0.1                        ^  ZPhCon.dll

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
     ���������������h���-��-M���m���m������������������  �  � D� �� ��� ��� ��� �������R������T�aɊd�  �dOɒf��\�M���C�R�]����   �����������������UUUUUUUUUUUUUU_�UUUUUUUUUUUUUU_��U�\U�U�\\�\U\_�U��\U�U�\U�\��_��U��\U���U�\\\_�UU�\\���\U�\U\_�UU�\\U��\U�\U\_�UUUUUUUUUUUUUU_�UUUUUUUUUUUUUU_�UUUUUUUUUUUUUU_��������������������  �  �   ��������� �   ������������   ��������������� �������������  �������������   �������������    ������������� � ������������ � ��������� ��  ��������� � ���� �� ���  � �              �� �� �  ��� �� ���� �� �� � ��  �� ���   ��  � �� �����������������   �������������������������������������������������������������������������������������������������+++��+��+��++��+��+�+++�+���+���+��+�+��+��++��++�+��+��++�++���+++��++++�+��+�+�++��+��+�+�+���+����+��+�++++�+��+��+��+���+���+����+��+�+��+�+��+��+��+���+���������������������������������������������������������������������������������������������������������������������������������������+�      ���     ��        ������VV�������+��    VV+       ��+�����VVVVVVVVVV�V+V�VV       ��  +����VVVVVVVV������V�VV�VV� ��    ���VVVVVVVV������V������� ��      +�VVVVVVV��������������+��       �+VVVVVV�����������������         ��VVVV�����V���V����+�� ��   ��   ��VV����������������� ��  �  � �  �+�V��+��������� ���  � �    �  � �+ � � ������+ ������ �  � � �  �  � �  +�� �  ���  �  ��   � �  ��  �    +    ��                              �����   ��  ���   ��  �   �  ������  �  ��  �  �  ��  �� �� �   �����  �  � ���  �  � � � �  �� ���    ���� �  � ���� �   �    ����    �  � �  � �  � �   � ��� ���������������������������������         & FPHPVRI.lvlib:PhInt IH.ctl            �  I�x��\ol�u�=���$ŧ��-�*G,�m�9���M�GɗH}�b[������m��{�������Q�n?u��p�A���[�҂)�Iۤ�����.(�����ٻ#�#��x}ܝy��{�y�7�"$�������-��.o�����>�$�g�&I_���h�~R�"w%�����=��}��Jfs/����ڭ������#� ,�����q���l��������� �үh�O��"�ʚ
�Z�'F��D˝��Y��m�6�w{G�'���-����qw`�C T�3�X���R$���oF�>��8������=n��.st��l��9)>��
���n�������F�¼��5��r}[i;����6��'��?���ko�hk�����$����D6�~bc�g|�1xAK/��-�cl|����? ״��~�rb�]��ͽ�&Q0һ�&H�t�'ן\�#=(L��d ��ŃJ��=���Gq��G��~ңM�U��7�x �hj��?���5��9�o�Ǎ�shH�9��|�^'�[��a�:<��-r��h���������3,+��*��0=�7���^c>s=���y�Z~~�0uea8��W��`e��n��S_�(�S�NQ����[��ړ��W'��3>���F��l4y�ǙY������E4���l2���QnF�fW��p�dLWp����غ�x��؆7�L�b`j�@3l�g��j��z�,�R��ļ������Z��嘥���-|DˮS�~�Q4˵uc�Y�6��j�P�iWh�1�NF�/r_{��X��5+�M�\]ƌӰ�ɸڒi3�7L\��e�Aۂ���2���+�MJ��S�/�,ᆑ�!��;��唞��C��%�&#���bb|\�;4h���l�Y<�3-�58'� �f�L]�3fL�D�i���ٙpb��|�?8-����W/S�Wzb`�ô�{ԕ�n�������<�/馥��u�uQ�t aQ@o�5���n$@�H'�.����kTO-�)]6N
F;�(ጿ,�̞?K�'�5p�qG����ЁBn樺��>GX�A�<@��-�Ϥ�hRMI�f�j�2_G���J]���|��s��qǂ�	X�������uBDq�� �L�j7jE��AK�h��>Vl��2sx�'� O�>���D�.^�����w��D��k{�v"'*ɴ�:e0S)���սxi^h����X`q(��G3� ������I��U��g&�?;LϫY�B����*}�CQ\'A*��;H�ctʲbh�:�XL�UEX��d~ͨ%yx�q`�S�U��3q�BY��|�F���J�owm����Uj@Z�͖17DJT"�)כ�B�S��N�_���`��<r��A��<f4J@Z0��]��z@��t��1"�ĩ�oE4F�;��:�J�#�e�g��s����a< Z	O0b��Z�kg����� >eK�@+�l?>�Y���
�]�B�y֎d�>wp1\1�i����ˌv�dJ��p�|�qAgGB�������vI7�B�����|�TeB�W�I���t`���� �-�\r�~>�5^�@)\� �?Y5a�uK�K�C��T�Q�si�4l�ɖ��$`|�b9`��È/T>췫�r�2U�eM_�����?wD�Q�8ՆtHQ3�3/��S�<C�1Zl�N|R�ŧAur��6Y�3�t�� �Ve`�y%׬c~{�l���`0�#`�|�0�����g�S�}x^����y��>������������,�!�euhEu�����3@p��fy��םe���pgG�·64��sgV�?�Y:;���D������s�BV��xŢ igR��y����s��ip��D]j]k�b��M�����׀��ХG/�ǲٕ�٬0̴K.�EY*�k����Aδ�)�S��չ�tf�0F��L����J%ov�L\Ǉ�T�r�.�.P��#���S$.ZVDqX���K@o���ذ��Kj*��8M�Ĵ�fh7<l��%b�nR�O���
X��a�Ez"��  �p�J(�.����߾��G�.�fc������j�!�x�!
E�d�Q��ǣR�WeN	���Y�JPa#�%ц��%�pl����c�jχ�Ǆ!��{�$G?x(E�y�Ϫf�
V�vU|�c"sOp-���!%m�^<C(@FϠ��n����2�B�ڈ�U�0�*�H�-~},��
L�) :V�i��?��f������2�6d����g� ��� ���f���i�
=97�l�XߵID��&�Ev��l��3�V,~�'�2yh�rЀ�@�/2���src�J�Y0��O-
&�a�d1�jڎ��HW��Lc%�Vo�H/�`�� �y
X8@I�l�־-O��U�5p�nyN���S���^Yuܰ
��k���gة�JN�upm�Hb��+X R.|�����^�� M��ѫ�1X�l���\g$:8bF�;�l����V�X��в0����3СG�H�P��(I`^��'�,�&�Lvu�d�����W������X�8ȍM�B�r�+(L�T�;�g�<�6�V椅�R`�oC9GW�+�7,O&�}���{���y(�lan�2X[g��:W�n��NX�A�o<(���]Z��>%��m���>X��, �
?߀9Q0+�?�cC����|l�*o�/8ߑk_��6o�%�ְ|�SĮB� [���F�TG�T^DBm�se#Ji�Mj�m �MM�w" �?ӱ��	v�-�(n �1�����VN��V|���K�����*J�}XRB^�����t�_�Ȋ�~�'��T$x|�(�*�Gۄ�
a�����7�#	OVh��}��R3�(0�s�A4�z�q�Q^��3LCͤ�B�֔����")CS�t�&(>o�lP�f�|kY_�hv\�\�4��H9,�ba�s��(͈�&ߓ�#Y2qÀ��Mm¦�֎���d��2�ƃ^�
Ӻ�6b�[.,li��Ҍ������H��1��+���V��V�Zu0�e9-#�1g>+��	�u*�x� �W��gO�e���9�<�p�"�����;�7��
���B�[j�Id�n<�'K�ӝdur �t,�}��UX9��������� ]�)�>��>x!�+r�ц��o�k�j�;���G��	~�ɯ��51ɯ~�?�����91��!-��ZA읓�/���Jn�ԋMoj�����HULR�9y����]�0��;'��G=��s��wNt��4�rQ�Ҟ�9�Ѵ���WןKnw�ߵe�>��8�1�06��iT�-��������'����}��(��;�gr��g�ޟ�4^��b�Ζ�#c�����fJy��>r/"�}�/���߇��U�_;M>�C��N��?8�-K�Ƕ���F�������F�A�C�Hz���A\O��J���]t�O ��|�i���e�J�~�:���^��p��틬y��5ޥX�0���[Sܻ5Ř5G��ws'/l�+������5����k7�­�U��[Y��W>�)�G�Ͽ������7�N �&Sw|H���&P�("{��]C77�ga���/moo��!� �/��� ��Mވ���hG8���Ӗ^z�=�������Mp&�
k���ǿz8��������g8'
!�W ί���9��#�?��� ��?P4g,7_�;���~��҉�w�Ov���҉��	���6�� =D���8�'C0��o���`~|G0O�̽�׀���808�hW��c]��ˇ��+���\i�c�j��� �<�1�lG{��E��yfy�̽��V�����?�&4�/t���h|i�D�/ڠ���x�Mc#!0M �7c��_����x0�������gA��5����`��C�����ڂ��B>�UH��O4D'+��@���Oy��J�+;"����h.�77�����]��Ow��P������Q�t���g/����[��g�o���#�K)�Z�e��ִ6���`�~�M�����ȋ��!4��~�M�hC^Rm���S�}�|�\���ww�=�9U4�M���
����
��]�C rn�@�m�����4�y��X��#�/��ɢ9o�6�Z)H�`(��c�v��w��/i����0����#�F3�w&��w�?�n����
�U��t� �@+�~iiG+��r2�N�=�(4�Y��̏���M��2z0��t7aY��S�����,��,w:j�;�
?�⇕. ���Ȏ��#⏈^H+�G�]�����! >�_�O���w ��q��;������4�)�0���m@z4������|��<jM擳�/'nkږv-����gsY�~�(�_Nn}{0q+���w�����ԗ|��(�FK        �   & BDHPVRI.lvlib:PhInt IH.ctl             e   ux�c``(�`��P���Z�+�!���FЏ�7���a �( 	���h/��>��� �l���9�2-���W)b��z�\�8Se�<� ��G                  NI.LV.ALL.VILastSavedTarget �      0����      Dflt       NI.LV.ALL.goodSyntaxTargets �      0����  @ ����          Dflt       NI_IconEditor �     @0����data string     513008047    Load & Unload.lvclass       	  ddPTH0                 Layer.lvclass         �          � (  �                 ��� ��   ������  ������  ������  ����ff  ����33  ����    ������  ������  ���̙�  ����ff  ����33  ����    ������  ������  ������  ����ff  ����33  ����    ��ff��  ��ff��  ��ff��  ��ffff  ��ff33  ��ff    ��33��  ��33��  ��33��  ��33ff  ��3333  ��33    ��  ��  ��  ��  ��  ��  ��  ff  ��  33  ��      ������  ������  ������  ����ff  ����33  ����    ������  ������  ���̙�  ����ff  ����33  ����    �̙���  �̙���  �̙���  �̙�ff  �̙�33  �̙�    ��ff��  ��ff��  ��ff��  ��ffff  ��ff33  ��ff    ��33��  ��33��  ��33��  ��33ff  ��3333  ��33    ��  ��  ��  ��  ��  ��  ��  ff  ��  33  ��      ������  ������  ������  ����ff  ����33  ����    ������  ������  ���̙�  ����ff  ����33  ����    ������  ������  ������  ����ff  ����33  ����    ��ff��  ��ff��  ��ff��  ��ffff  ��ff33  ��ff    ��33��  ��33��  ��33��  ��33ff  ��3333  ��33    ��  ��  ��  ��  ��  ��  ��  ff  ��  33  ��      ff����  ff����  ff����  ff��ff  ff��33  ff��    ff����  ff����  ff�̙�  ff��ff  ff��33  ff��    ff����  ff����  ff����  ff��ff  ff��33  ff��    ffff��  ffff��  ffff��  ffffff  ffff33  ffff    ff33��  ff33��  ff33��  ff33ff  ff3333  ff33    ff  ��  ff  ��  ff  ��  ff  ff  ff  33  ff      33����  33����  33����  33��ff  33��33  33��    33����  33����  33�̙�  33��ff  33��33  33��    33����  33����  33����  33��ff  33��33  33��    33ff��  33ff��  33ff��  33ffff  33ff33  33ff    3333��  3333��  3333��  3333ff  333333  3333    33  ��  33  ��  33  ��  33  ff  33  33  33        ����    ����    ����    ��ff    ��33    ��      ����    ����    �̙�    ��ff    ��33    ��      ����    ����    ����    ��ff    ��33    ��      ff��    ff��    ff��    ffff    ff33    ff      33��    33��    33��    33ff    3333    33        ��      ��      ��      ff      33  ��      ��      ��      ��      ��      ww      UU      DD      ""              ��      ��      ��      ��      ��      ww      UU      DD      ""              ��      ��      ��      ��      ��      ww      UU      DD      ""        ������  ������  ������  ������  ������  wwwwww  UUUUUU  DDDDDD  """"""          �������������������������������������������������������������������������������������������������+++��+��+��++��+��+�+++�+���+���+��+�+��+��++��++�+��+��++�++���+++��++++�+��+�+�++��+��+�+�+���+����+��+�++++�+��+��+��+���+���+����+��+�+��+�+��+��+��+���+����������������������������������������������������������������������������������������������������������������������������������                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                ������������������������������������������������                                                                                   
NI_Libraryd     Layer.lvclass         �          � (  �                 ���                                                                                                              ���   ���   ���         ���   ������   ���         ���         ���   ���������            ���   ���   ���   ���   ���   ���      ���   ������   ������   ���   ���      ���                     ���         ���         ���            ������   ������   ���   ���                        ���������   ���   ���   ���   ���   ���      ������   ������   ���   ���   ���   ���            ���������   ���   ���   ���   ���   ������   ������   ������         ���   ���������         ������������������������������������������������������������������������������������������      ������������         ���         ���         ���   ���         ���         ���������������      ������������   ���������   ���������   ���   ���   ���   ���������   ���������������������      ������������         ���      ������      ������   ���      ������         ���������������      ������������������   ���   ���������   ���   ���   ���   ���������������   ���������������      ������������         ���         ���   ���   ���   ���         ���         ���������������      ��������������������������������������������������������������ݪ��������������������������      ��������������������������������������������ݪ��������������������������������������������      ��̪��������������������������������������������www�����̙��www���������������������������      ��������̪�����������������������������������wwwwwwffffffDDDwww���������������������������      ��������������ݪ�����������������������������wwwfffffffffffffff���fffDDDffffffDDDDDDDDD���      ��������������������̪�����������������������wwwffffffffffffwwwffffff333fffffffffDDDDDD���      ��������������������������̙�����������������wwwfffDDDffffffwwwfffffffffwwwwwwfffDDDDDD���      �����������������������������ݪ��������������wwwffffffffffff���fffffffff���fffDDDDDDDDD���      ���      ���������      ���������      ������   wwwwww   fff   wwwfffwwwwwwffffffDDDDDD���      ���      ������   ������   ���   ������   ���   ������   ���   wwwfffffffffDDDDDDDDDfff���         ������   ���   ������������   ������   ���   ������   ���   ������fffDDDDDDDDDDDD������                  ���   ������   ���   ���   ������   ������   ���   ���������DDDDDD������������         ������   ������      ���������   ���   ������      ������   ���������������������������      ������������������������������������������������������������������������������������������               ���������      ������         ���������      ������   ���������   ������                  ������   ������      ������   ������   ������      ������      ���      ���   ���������               ������   ������   ���         ������   ������   ���   ���   ���   ������      ���         ������������            ���   ������   ���            ���   ���������   ������������            ������������   ������   ���   ������   ���   ������   ���   ���������   ���         ���                                                                                                   ��������������������������������������������������������������������������������������������������������������������������������   VI Icond                  ���               Small Fonts 	              Z   (         1        ���C              �                   ��	     LUU�@ �	�                                                   
�#>
�#>�@'>�@'>     L   ?          �  vx��P�N�@=t��7��~�q�ʥk"��D��k'�L�iGc\�=~���W��B�7�f�9��9���E�e#�s�,A `��Jf�*�㫎TÑa.���Md�	�:R�>L�oШ�v8��d�*�$�lg��7�|%P�յ'u���L}�7��*�y���"�������}�^�Y��p�{��S�(uJ\���)q�����W V����G���7r'��v�Fc���X�b9�p�GE�,�rs  �A�@���a�y�/z��"®�2�F�����jS��w�	5����{��)`���%�Rb%��|�i�8f��u*+�ژ�gUI�/��ٜ�l��x�#qw���QE�X�6s���&;d�Q������8V�+���[�      w       X      � �   a      � �   j      � �   s� � �   � �   u� � �  � �Segoe UISegoe UISegoe UI00 RSRC
 LVCCLBVW  Z�  u      Z�               4  h   LIBN      xLVSR      �RTSG      �OBSG      �CCST      �LIvi      �CONP      �TM80      DFDS      LIds      ,VICD      @vers     TGCPR      �STRG      �ICON      �icl4      �icl8      CPC2      LIfp      0FPHb      DFPSE      XLIbd      lBDHb      �BDSE      �VITS      �DTHP      �MUID      �HIST      �PRT       �VCTP      FTAB           ����                                   ����       �        ����       �        ����       �        ����       �        ����      $        ����      ,        ����      X        ����      �        ����      �       ����      �       ����      �       ����             	����              
����      0        ����      D        ����      X        ����      #�        ����      $@        ����      &D        ����      *H        ����      *P        ����      *|        ����      <`        ����      <h        ����      <�        ����      =         ����      =        ����      X        ����      X        ����      X        ����      XH        ����      X�       �����      Z\    PhInt IH.ctl