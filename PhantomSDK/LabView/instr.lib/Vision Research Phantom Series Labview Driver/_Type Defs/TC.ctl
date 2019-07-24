RSRC
 LVCCLBVW  Z�  o      Z�      	VRI.lvlib     � �  0           < � @�      ����            �|�K6I���YBT   
       @�n�+�E��p�f
��ُ ��	���B~                                             S�R|6a�D�\�6hP]�          F LVCCVRI.lvlib:TC.ctl       VILB    PTH0       	VRI.lvlib               $   (x�c�b`j`�� Č?@4��D3p H �O   I  $x�c`��� H120�d i4q0cS ���\�Bř �e��2�X,��LP5"9 @7��� �9&-        VIDSVRI.lvlib:TC.ctl            Lx��ԽkA ��ڏ���!�͊��G��n�`�X*Q�D0vY.�#����?!U�6\ !�il���Z,�ݝ}����y��w�0o"A�ۍ{+{9%��$믞��	�ȩ���u���Ѡ���hN.�&������[7�l��A8J���ftp:��R�s�L��E�0��K�6�-���u](�X��{a��xnv�`��h-�|�Z��m��'�"�����W�w*+8�I�c�S�	�q��!g���s�9�m\ �pa�r�ܱq����ڸ��C��l�G�#���6�B�B�޲� y�< �xyyx��;�;�;�;6�E�E�޵�>�᳴�>H���+�m8:�[���Iu��2s+�߄T�D}��W���{w���ɒ��$=��(3�P���[��3�[��Ϳ|�WL�?�ҞT�M&�H�pKu��,+�[�l^g?�D$��Yy4���Q�%w�U�J(9�x�o^͗��M�z�af�0w�W>��3�ZL�����p����^���JGC   �  13.0.1       �   13.0    �  13.0.1       �   13.0    �  13.0.1                        ^  ZPhCon.dll

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
     ���������������h���-��-M���m���m������������������  �  � D� �� ��� ��� ��� �������R������T�aɊd�  �dOɒf��\�M���C�R�]����   �����������������UUUUUUUUUUUUUU_�UUUUUUUUUUUUUU_��U�\U�U�\\�\U\_�U��\U�U�\U�\��_��U��\U���U�\\\_�UU�\\���\U�\U\_�UU�\\U��\U�\U\_�UUUUUUUUUUUUUU_�UUUUUUUUUUUUUU_�UUUUUUUUUUUUUU_��������������������  �  �   ��������� �   ������������   ��������������� �������������  �������������   �������������    ������������� � ������������ � ��������� ��  ��������� � ���� �� ���  � �              �� �� �  ��� �� ���� �� �� � ��  �� ���   ��  � �� �����������������   �������������������������������������������������������������������������������������������������+++��+��+��++��+��+�+++�+���+���+��+�+��+��++��++�+��+��++�++���+++��++++�+��+�+�++��+��+�+�+���+����+��+�++++�+��+��+��+���+���+����+��+�+��+�+��+��+��+���+���������������������������������������������������������������������������������������������������������������������������������������+�      ���     ��        ������VV�������+��    VV+       ��+�����VVVVVVVVVV�V+V�VV       ��  +����VVVVVVVV������V�VV�VV� ��    ���VVVVVVVV������V������� ��      +�VVVVVVV��������������+��       �+VVVVVV�����������������         ��VVVV�����V���V����+�� ��   ��   ��VV����������������� ��  �  � �  �+�V��+��������� ���  � �    �  � �+ � � ������+ ������ �  � � �  �  � �  +�� �  ���  �  ��   � �  ��  �    +    ��                              �����   ��  ���   ��  �   �  ������  �  ��  �  �  ��  �� �� �   �����  �  � ���  �  � � � �  �� ���    ���� �  � ���� �   �    ����    �  � �  � �  � �   � ��� ���������������������������������           FPHPVRI.lvlib:TC.ctl          �  N|x��\op�u�#)	��
L���ъC2�B��L+6YMK��T�h����}�-���;��@��$i:�S��&�=��M��mb������!������M:��C�w2��uJ������G�@����p����{����;$d~5uo��M��~
76I���rk$A�g�Y�����h�pB�$��˩u�����~��Hd�ϑ���;����14=�:��o��|��v�����=wȗ�C�O=���x���{���m���gD�C�쩮����b�}��{$q����Ԟ�n�����$H������Lw�ah)���Ar��Ͱӓٍ��� W�!�ә��w�C���0��}`��?N�䝯��ة��rv#]�ߪo��?V�����+oj���Ӊ�?<t�#��%�����gp���7������t�<������BK-���&�26�$]8�W�ږ�q�.�r|��q_tg�K��=�;�v��lW�wiF�#�/T���oP���#ٍ�O��q�{H�f�7Tk���_�5욀������<!�K�,n��CEˑn�\��H��}��6L]�7��$�z�Emo��:ye�<c[i�RI&�
O�M��Lۢ��W���N�<r9�0����8�Lzk5f�"u=�^𨧗����LR�\��/�\�Q��ʓT����z�Qì2˅�\��g�Y*{�������=6J�Ϩ�v��5ۭ;l22���uh���t�vY��wH��G$@�l��U�Y3��f�U� �Z%&���3:���A��e}mk�+Zt�*�ʌ�Z��W��2kB��׬J6����I��%nkwR��;f���	߫Ә��7�`Z���3��&N	`�0ݠ�U����b)^W���"\xĻ�:O�,a��� ����G�.<E=�����L�:L�=[���O���m/�V������`� `^pXe[��c�$v�w�w������!��Ya����t����c�!K,,����.ud�[5=j���	��+�Yї��5���>hB��xk؟	ݰ���f�͙���TK��SL�h"��6!Q��,�.Ξ��ʓ�8�!pUV�~hb@�戺��9GX�@�����
4���h��	R��Y�0������;r,W_��<����kvH�ReU�Y���qBxq2N'h�Z��2hj���jTu��f�������oCi�fD�b5
�	l�a�fv�7k3rLk�]5��_X�X͍���z�Va�x:8������F��[.��A���R�ji�y|���I�{N���28�_(c�+�5�Pɨ\�>��T�A�ی�2`�Z�y٘���A5$������:cgA(�U���4dj�Ksp(��8Lܱ�G�GWSp �u�[�:Rp]P����b��/?����A��d6;(�dYV �`��y�̨ iAG*zF,�B��IIs�X$B�L�j>�1�c�K妄M@T8�i�˲Zc���������ή�Mg��]V�WD�S��.�
3k�&�U�� �aOי�`mJ��q/3=�;�v��Ċ����&�{ �VTA�)�a@	�T���z^7���������BY�	]�^6d��iB3�zI�nS�Ø����S�A�����MX'�zE�
�I��T����IΥӰ�'�=mLFGKT�%xf�����R��L%mY�WCᩪ���alc�M�$RԌ]��sfơS�y�c81X~����9��ɡ3�mX��3*t�� �V�a��Ǭ!�=>�y�75�������Z<���4�ye�?LO/(_a��L�X�H����l�W���d����v�UX�E�K�hEt�c��M� �k�*��<m���ENw��0>�r6С^Co>8vf�����!�ߏeΌ��=8$F�2�X m_��<TO�0mv�J�4�F&�JW!��֫�`ņg�xxҫ��ӕOOЇ2�ճ��P̴
O�\T
RT�R1�6h�l�L���2��]�G�| ���Й�|��)Z1!%�E�D�FCJ�*���Ŋu� �@�����N��pZ��f	�J��@z��c�RN�!�"q���t�2���l��|�fR�O���
h���!����D��@Jb�E*5 ���'d���jP �3wQ4K'�3�5�U�@�,&9�=�^XF'��8dq��~<5^YrJ0��e��`bY&���P&���a��~a�j�F�^*���q�G+����^J��o��Y*���m(>�`aI���?LI�q�e�h��[�-�uZ���\�[�n 3WI��Q�B�����9��
5M��2�L:���24�����8e9�^��s K���.�oZ��˄�%K��w-���pbVdA�K@��d �����b��a��f�+� ����̻���sra�L�ZЬ�w-
&�e`d1I5���"��4V����@���j�u���`?(�1!���u[N���5i50�^q��6I����ZY��\���5d�x����fuO���ߧj��� �¯�`�e�h�=&@�/a��4.˶F�a�=n��
-}؍C�	:r*��;%�8~�Y@.�7����x$p(U]��W�j#�	 ˪�+ɮ�L/�17}1��i�7D�G��>76��JesQ��C�\wJ�!xH-��ȓ���_�����VR�W\��4�M�v/~n~�	Hg��S@���վ����;a�`2$y����}L���؍�>h�`/ �
�߀:!�%��1A�@��K3��t����<ߑs[��2�	Bh�^�LNav�����((���`k��	O�u>ذ�x�Z�6�P����+��K���_����i�i�됎��H���QD)���V=���K��G��*J�}H��<Pq5�A�R"��%�1�r5�(�T1��KGq=��z�L���a��_ �=��u$���-]x.�X*�q����#c1G_d`�H�8:v�K�>jL��&D.M�:*H-2eh(��V��15a�ʍ<��~=�r]_si	V\,�*Ea;�=�_�r�ʹ���&_�"m��e���5�	"[\L6$�A�e���Z�
h]��H��J��U:h��|�/�G^��_aDj����
7�_���ۦ��%�̫r�񚀘�b�AWą�"�p��lv��f�g�p�B�3W%A+�N���B �Od!֭4��w��W੢��Nfu�l�t�"���FXن������� � ]�)uߛ��?��9�ϊ��W�!~o�x~�_���O��~}�_���y߇��~������'��1���DΟ?��'����_h8B^�#o�r��,:��O�=�L��.}L��E��	�y�����O�m;�}Ο4�(ojO�O�4-8ru�%<���w�����'�y�p��q�t�rir���?�����gN��>�!gN�3'�z�����368��7�o]�g�n'��&w��d���g���g���l�*X?E~������u�?�)J��6�W��g�nwp��u
F��Io��&H�k�I�j�餷N
d�&�79��T�tU!ы�7�q�4�k�i��P�WA�c���'���ֵY޻6�m�nj�e7NL��>.<����w�6���m��~�ks�@)�g�p�~T�O+�#��{?P�<�eñ���i2��ǂ�o+ǂ�G����vP2pjk��o
H��ӈ�N@�y%�����c{:=u��H����'ƶ��k��⯷����P|� P�B�(~1�]�(�⣘������G���P\�?�V(v�
����k���E��p����5�n#�/��_�#�e,�.M��������񥶂�����Va�����x2~1��o�_m�1�Ύ0>��/O�o�1��/0&����_���_��Ø|�E�7b`|$�w0~`��F�49ř�����?�V(l+ �O���OŠ8��'
P|�܌�_�Ź=�8Y5��� �x`{V�;��U<�N@�~������d_m5�x>���@~A)Tm�G���[���*����_���PL��N(&� ��*���d<��1:>�X8>�rḑ��c�����v��h' k�@��V��h�����R� �]�g�����dy�*v������o����	������UF�� ���ZAȫČ��v��G �
xB��/��#.�xi���m�?i+8� �������b�|W<��+UB�DJQ8��p.���Ǯ�����k+4��Vh����d�h�1h��x4J����d:��k;�yz�h��m�~!O��+m��j[��: ۭ������=��>M���n��Z��E2��
���l�f�	�Z��@����o��-�������v�Ɲ���{;�x�92���?d���c�A;��� ��Z%���Dq�=�;M��o���zK,�e�vk���Q������|�{��e�D.1�z�㎦mj�/%~:��ȭw��w�Bb�;[��w<�����Z��L���%�w�      �     BDHPVRI.lvlib:TC.ctl           e   ux�c``(�`��P���Z�+�!���FЏ�7���a �( 	���h/��>��� �l���9�2-���W)b��z�\�8Se�<� ��G                  NI.LV.ALL.VILastSavedTarget �      0����      Dflt       NI.LV.ALL.goodSyntaxTargets �      0����  @ ����          Dflt       NI_IconEditor �     @0����data string     513008047    Load & Unload.lvclass       	  ddPTH0                 Layer.lvclass         �          � (  �                 ��� ��   ������  ������  ������  ����ff  ����33  ����    ������  ������  ���̙�  ����ff  ����33  ����    ������  ������  ������  ����ff  ����33  ����    ��ff��  ��ff��  ��ff��  ��ffff  ��ff33  ��ff    ��33��  ��33��  ��33��  ��33ff  ��3333  ��33    ��  ��  ��  ��  ��  ��  ��  ff  ��  33  ��      ������  ������  ������  ����ff  ����33  ����    ������  ������  ���̙�  ����ff  ����33  ����    �̙���  �̙���  �̙���  �̙�ff  �̙�33  �̙�    ��ff��  ��ff��  ��ff��  ��ffff  ��ff33  ��ff    ��33��  ��33��  ��33��  ��33ff  ��3333  ��33    ��  ��  ��  ��  ��  ��  ��  ff  ��  33  ��      ������  ������  ������  ����ff  ����33  ����    ������  ������  ���̙�  ����ff  ����33  ����    ������  ������  ������  ����ff  ����33  ����    ��ff��  ��ff��  ��ff��  ��ffff  ��ff33  ��ff    ��33��  ��33��  ��33��  ��33ff  ��3333  ��33    ��  ��  ��  ��  ��  ��  ��  ff  ��  33  ��      ff����  ff����  ff����  ff��ff  ff��33  ff��    ff����  ff����  ff�̙�  ff��ff  ff��33  ff��    ff����  ff����  ff����  ff��ff  ff��33  ff��    ffff��  ffff��  ffff��  ffffff  ffff33  ffff    ff33��  ff33��  ff33��  ff33ff  ff3333  ff33    ff  ��  ff  ��  ff  ��  ff  ff  ff  33  ff      33����  33����  33����  33��ff  33��33  33��    33����  33����  33�̙�  33��ff  33��33  33��    33����  33����  33����  33��ff  33��33  33��    33ff��  33ff��  33ff��  33ffff  33ff33  33ff    3333��  3333��  3333��  3333ff  333333  3333    33  ��  33  ��  33  ��  33  ff  33  33  33        ����    ����    ����    ��ff    ��33    ��      ����    ����    �̙�    ��ff    ��33    ��      ����    ����    ����    ��ff    ��33    ��      ff��    ff��    ff��    ffff    ff33    ff      33��    33��    33��    33ff    3333    33        ��      ��      ��      ff      33  ��      ��      ��      ��      ��      ww      UU      DD      ""              ��      ��      ��      ��      ��      ww      UU      DD      ""              ��      ��      ��      ��      ��      ww      UU      DD      ""        ������  ������  ������  ������  ������  wwwwww  UUUUUU  DDDDDD  """"""          �������������������������������������������������������������������������������������������������+++��+��+��++��+��+�+++�+���+���+��+�+��+��++��++�+��+��++�++���+++��++++�+��+�+�++��+��+�+�+���+����+��+�++++�+��+��+��+���+���+����+��+�+��+�+��+��+��+���+����������������������������������������������������������������������������������������������������������������������������������                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                ������������������������������������������������                                                                                   
NI_Libraryd     Layer.lvclass         �          � (  �                 ���                                                                                                              ���   ���   ���         ���   ������   ���         ���         ���   ���������            ���   ���   ���   ���   ���   ���      ���   ������   ������   ���   ���      ���                     ���         ���         ���            ������   ������   ���   ���                        ���������   ���   ���   ���   ���   ���      ������   ������   ���   ���   ���   ���            ���������   ���   ���   ���   ���   ������   ������   ������         ���   ���������         ������������������������������������������������������������������������������������������      ������������         ���         ���         ���   ���         ���         ���������������      ������������   ���������   ���������   ���   ���   ���   ���������   ���������������������      ������������         ���      ������      ������   ���      ������         ���������������      ������������������   ���   ���������   ���   ���   ���   ���������������   ���������������      ������������         ���         ���   ���   ���   ���         ���         ���������������      ��������������������������������������������������������������ݪ��������������������������      ��������������������������������������������ݪ��������������������������������������������      ��̪��������������������������������������������www�����̙��www���������������������������      ��������̪�����������������������������������wwwwwwffffffDDDwww���������������������������      ��������������ݪ�����������������������������wwwfffffffffffffff���fffDDDffffffDDDDDDDDD���      ��������������������̪�����������������������wwwffffffffffffwwwffffff333fffffffffDDDDDD���      ��������������������������̙�����������������wwwfffDDDffffffwwwfffffffffwwwwwwfffDDDDDD���      �����������������������������ݪ��������������wwwffffffffffff���fffffffff���fffDDDDDDDDD���      ���      ���������      ���������      ������   wwwwww   fff   wwwfffwwwwwwffffffDDDDDD���      ���      ������   ������   ���   ������   ���   ������   ���   wwwfffffffffDDDDDDDDDfff���         ������   ���   ������������   ������   ���   ������   ���   ������fffDDDDDDDDDDDD������                  ���   ������   ���   ���   ������   ������   ���   ���������DDDDDD������������         ������   ������      ���������   ���   ������      ������   ���������������������������      ������������������������������������������������������������������������������������������               ���������      ������         ���������      ������   ���������   ������                  ������   ������      ������   ������   ������      ������      ���      ���   ���������               ������   ������   ���         ������   ������   ���   ���   ���   ������      ���         ������������            ���   ������   ���            ���   ���������   ������������            ������������   ������   ���   ������   ���   ������   ���   ���������   ���         ���                                                                                                   ��������������������������������������������������������������������������������������������������������������������������������   VI Icond                  ���               Small Fonts 	              �   (         1        ���C              �                   ��	     LUU�@ �	�                                                   
�#>
�#>�@'>�@'>     L   ?          h  �x��O�N�Pz�� �((�]�0$<�%�#����I
5�5.�>��?pJycN�fg�\ ���)��o���C��afj��55Z��F���f��k7���9lհCRx�篳?����&aC����^�]��^�u�Q���xs�V+k��%h�Redé�_��30q���r# ������掞�F�:\\�{�(% A �Ґ�@EYl ��dt@>R ��9�6q���݄���?��b���L(a;"�&Ș��̮�-��p{\�0��Ol��VIti8��kG켘E�of��&~o�I�+�s5��"�q�
�
�8#.�����P��,������:X/   w       X      � �   a      � �   j      � �   s� � �   � �   u� � �  � �Segoe UISegoe UISegoe UI00 RSRC
 LVCCLBVW  Z�  o      Z�               4  h   LIBN      xLVSR      �RTSG      �OBSG      �CCST      �LIvi      �CONP      �TM80      DFDS      LIds      ,VICD      @vers     TGCPR      �STRG      �ICON      �icl4      �icl8      CPC2      LIfp      0FPHb      DFPSE      XLIbd      lBDHb      �BDSE      �VITS      �DTHP      �MUID      �HIST      �PRT       �VCTP      FTAB           ����                                   ����       �        ����       �        ����       �        ����       �        ����              ����      $        ����      L        ����      �        ����      �       ����      �       ����      �       ����      �       	����             
����              ����      0        ����      D        ����      #�        ����      $,        ����      &0        ����      *4        ����      *<        ����      *`        ����      <@        ����      <H        ����      <l        ����      <�        ����      <�        ����      W�        ����      W�        ����      W�        ����      X         ����      X�       �����      Z    TC.ctl