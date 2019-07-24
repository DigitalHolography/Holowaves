RSRC
 LVCCLBVW  [0  |      [      	VRI.lvlib     � �  0           < � @�      ����            aJX���B� Ë�WdJ   
       ������JH���y�a�N��ُ ��	���B~                                             5R�$-[*Btsn�          R LVCCVRI.lvlib:PhFile ToneDesc.ctl      VILB    PTH0       	VRI.lvlib               $   x�c�d`j`�� Č@� t`  R�/   J  $x�c`��� H120�d i4q0cS ���\�Bř �e�	�Pq&�	������w � �&�     , VIDSVRI.lvlib:PhFile ToneDesc.ctl         9  x��TAkA�]7�����K�E[I��j�&�����B���`�6]�Ђ=T�x� eۊllhl
Z*�^��E�=hZ��7��ɶ/oޛ7߾c)�<���N9$r�d���Ƚ�}�[�z�Nׂ��ؠ�B��?��t3�3���4�{,�M9:$���HD��̺�,u.����E����Z�fd�_��I�ŔYI�v"�Z��s8����fUcCn{�Ù/�����)a�i3¦�q0��L���Ca@3�6�eR��j
��;*��Z�`U%������M��<V
������� *P �؂�L�E`n]̭��u�J��2�F6��}x��n|���=�Sf��:[we��xU\�u������~n��эg]13\�&_��M�&��k�%�JL���*Ҁa��v���D3�]�kmB�<�3�� '/���;EF����7���W�uMj�������N���au�G���b���:��P_��m��t]��N��c���~Na�S�>N*�Տ3��T`-`���Y�y���^T��~���0��wja�^�� Ec��m��r�:.vh�ܧ�(}����h���*��ؠ�^a�k��%��&���ą�[ϕ�D뉱�6�]�����E+�>#0�-���Ҵ����t�h��*{����v�sp�w�Ҟ��?�
V���X���𰥇�ˉW�m�}��Qu�6_�E7{�8o�9���2>E���Q��v�}�8�5����Z�٫}�T�yL��|S~+-�� ��q�V<��-�_Xy�      �  13.0.1       �   13.0    �  13.0.1       �   13.0    �  13.0.1                        ^  ZPhCon.dll

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
     ���������������h���-��-M���m���m������������������  �  � D� �� ��� ��� ��� �������R������T�aɊd�  �dOɒf��\�M���C�R�]����   �����������������UUUUUUUUUUUUUU_�UUUUUUUUUUUUUU_��U�\U�U�\\�\U\_�U��\U�U�\U�\��_��U��\U���U�\\\_�UU�\\���\U�\U\_�UU�\\U��\U�\U\_�UUUUUUUUUUUUUU_�UUUUUUUUUUUUUU_�UUUUUUUUUUUUUU_��������������������  �  �   ��������� �   ������������   ��������������� �������������  �������������   �������������    ������������� � ������������ � ��������� ��  ��������� � ���� �� ���  � �              �� �� �  ��� �� ���� �� �� � ��  �� ���   ��  � �� �����������������   �������������������������������������������������������������������������������������������������+++��+��+��++��+��+�+++�+���+���+��+�+��+��++��++�+��+��++�++���+++��++++�+��+�+�++��+��+�+�+���+����+��+�++++�+��+��+��+���+���+����+��+�+��+�+��+��+��+���+���������������������������������������������������������������������������������������������������������������������������������������+�      ���     ��        ������VV�������+��    VV+       ��+�����VVVVVVVVVV�V+V�VV       ��  +����VVVVVVVV������V�VV�VV� ��    ���VVVVVVVV������V������� ��      +�VVVVVVV��������������+��       �+VVVVVV�����������������         ��VVVV�����V���V����+�� ��   ��   ��VV����������������� ��  �  � �  �+�V��+��������� ���  � �    �  � �+ � � ������+ ������ �  � � �  �  � �  +�� �  ���  �  ��   � �  ��  �    +    ��                              �����   ��  ���   ��  �   �  ������  �  ��  �  �  ��  �� �� �   �����  �  � ���  �  � � � �  �� ���    ���� �  � ���� �   �    ����    �  � �  � �  � �   � ��� ���������������������������������         , FPHPVRI.lvlib:PhFile ToneDesc.ctl         =  5dx��[]l#�u�#RZ�^��&�]��u%S���(��]�+$�VԺj�Z��։ݭ=�\��g虡~\$^ʢ.����H��}k���}�CZ,����������h�ֵ낫�s;$W�6���R�{~�9����W�\y-{q��V�hُ���60�5B�Ϥ����G����!��G�6I�ng1�@{�����?�*��&������d	K��#�,����ؿ0����l�GO��������|-7�q�{${S�:<�= Zi,��_�m���O�3��2��^-�?���A��s��B��%K,��{��V�
�&��M���-A���;�s��9�@Ni�����H�I�Y��)���)�J����IWok�����H��������h{?=�Gpǫ�ÿ>���7��U��8�e���z�$���H~��־B���")}A����t��,��q�hg�R+%6���W^�NM`�Mi����(r���~���F.�$�[���!��.�^#��^��t�i�?oDDEB�4p��d�eR�d���̾O��M�_Dm����V_r�aY��b卖陾��tMw���ѩť��^Y[,/��>����Mf�*�|�U�ה�?�P�����AW/��__�����JC�1j�f{ �S	~�������>��j�u�-D�gԅ�u�;M�k�l!&+��-X����u��XűoZ!/�c��T�Sl�g��j��zì�P���I~fg�I5Xi����>�Z��V]�A�:���k����d}�cڜ���]AΦ]��`Sjm���[Py�����Y�1t���6����/��VL�Q�|�QP��-�\�Ա-ؘ�,cZ�߂d��G�4���f�Gq\X܇=,���;t�������-�Q11;��'4ph�l�Y<�=��6Hb ���Hכ�H��MX^^
	ˬ�K���i����ߺu��Z�5��� �mݣ�\@u۠�OM�hC�aq}K7-}S��\o���>8l�m����N8�������a���Ҡ:XjK�L�骉pR0�G	g�ec����TQyA��7Fehu�>r5g�P��9�bZ� �n��H�x&�G�j�H*�`�1�|!���+ey��~��:�:$M�J�5w���(���g"�P���M�P��.�bǆY�2���xR��L`Ci�~Xa5
��	mq�O?B�]{��>QI�Mש��J	/������K�z�ٴ4���p�joF'T�@�m��NFឤR+�ڪ���w�"�up0�RǢ/"�����Y�A:.�Eˊ���c0�Zm¾l���)�$O�a�8ؕ(:��S(�P��i���/����ryp0ظk3�V����� l�b���6���H�����Z(~
i7qX�b��CV:���k�Q��<ef�*д�#� #6��EĦ����T,!p&���Fm�Lw~�uZ�z_L�& *��u�/�fg�����s!��;������X�e�Ƨj�H����&<�rT���h1��O���wz�w��2�������&�{ �v\A��Ө��j*]���xA7��Ҳ���'��J]�	]�^Q6d���ͰF�5�M�ۥ�.cvП�:n�-
/`��_��'����֧U���QxtŚs��u���O;���ٚ�
��.x���!�nU���TsЖ}'J"�U5���#��B��M�d��X@yô@]t]�3$��A��c��X���K��U�J��]Q�)�[��8�p�&�W拿����ЈA���+�p:�f������Қ�+��3��5��>D���<*�Fe���o��<%�zw�CZQ��X�a�)3w��a������-z�9.a~f�j�C��޼ryn�ѩ��i��_.����|teZH�
��X �lC��}TO��m���f��1�H��Z7Z���b�gP�xy������s�������bQ(f���E*-*v��^t|	r��B�-��<�W�r�{��Х�r��Ej��8�U*y�!e�9>dŠ�U[vEL��/0?��	;E�mN�% ��ۂ��Ɔ��RG!��iB&��<�`�v�sQ�M4]�e���LJ�4����v�(N]�% )�g�̀r�OH���Ӡ��8v�bhV�d��k�N���)�Al��&:Iv�Q��ǣR��eN	���Y�J�7a#�e���e���,;`U�1
�Vχ�Ǆ���{�$G?x(Yp��fu�V-�;�(���\+�ؒv�/�! �eІ^S�E]�i�.�Dm���-� �yB�n�_������+�4e�\,��W��i�2�2B�>�ǳ\�^x� �9���2]�L�7m��2�A0���0���C��ې4�01+�p�%�e�d �����b�<�0��C3ؕC�T�M�oCg �l�)W�U��E�>��!&SM��2�t%	�4Vq͖@���C��Z�1�C�AP2��h�ܖ�m�Ʈ�J�<'~Lҩ��<Vv�W���f��v��S�}L���
��3�6����H��L�&a��4.۱g�d����8A�����y*�����(?�,L.�7�d�Q=8�*G.
]��p0�	 ˩�'�]S��~������q��������8ȍ�B�J+/"P��RwJ�!�:7X�7-/�+<%��|W�lY�TL��͌�׿���*�����ś�m����*�L�^Ν��F�xP0&y���[��d��؋�}Ў�Y@�
?߀:Q0k��k��!Û���`��/x�#����m���F��M(NQw�zXҥ88ZeV�'ԁ:�WJR��*�Ա�0�R�Lǂ�$X�N[lP܂vL,��k�E�r�no������~>6��PQ��Ӳ%䅊��(K����9����F�������Q��]!,��q �=V��8���d���|.�Xj����3���Pɱ�q\v��d��Pg��!24etX�Zd��10=j��{̄E7(��f�|k[��h"�g.U��N$�}�������(��M�k�m���e�Āuw;Ƅ��Wn6J�S<��4���b��մ��rc�HӼC��/�^�G��0����"Lwjm���ꀸk;]+q0gޑ!�gb��A�<Q����ǳ'��ٛ��9�yl2���.ޑ	Z9v�o�� A#�n�'��E���,@ Ow�����cA�O-Q��k�)�艡]��H��L)}1��ĵ���H��h����7~}�����a�Oj�Ϋ��#����#���S��>B �;�*H]E�G`=!?&w��1��-������}����#H�q}���D��}#�>�Դ��H����ȿ�+���%�>��ep�/ F\n�tp[d��m�4��=�m�d�����w�k|��ʳs���t�c�M~��?��+�^�������(��)�i�� _�a�<e�'�n� ��'9�\$�e��e>��S��
�����$���'�=�P�J�g����~z.w��\��\�O�ǀ�����uxT��.	zT��1XB��1|͎K�n�Ƒ}��w�y��k|iz4�fTh3��)�Wt;�6��kS�i�n�g@�m�N�<
��>�NN��c"$'�%&�D���_�<���N/�|�nPwp�)���׊F�y��0�q�h:�t�#�ND+0�!�R�i�㪼�4_
�?-�<.磇m/ۻ���<�&�1w��gT�ׅ͓���vZ�������:��\�j�x?�yr�W�͵��Ϭ��:�'���,D��\<����	��#�D�HW4?�j-�����H��9K�?���#�?���MB�s�N�M���0m��6�
�\�<.�����A�����A�ֽrmQr��(��������~&z��?�3�s S�ȧ��@�G��
�ˏ4B��",��c������m����]��y`n�dΟ{"x�Ĺ��RP�T�u^a�0���pw|J��1pHV���o2�A�U���y����>,�G��ǟ����T���}����G�R�_�}��|p��<<E�$��A���op���o0ѣ�������#���ӿ��74z��wL4��R��,���_�z��o(ף�� �LR29v89�_�[���?@���gI�ڗz�����=A�ÿ�|���[���y��<���7L�#���@ڸ~�����BwQ}�~#��f��/,��|����À�K' �v����7����7��K!FNi�{�.p�7���!����RPS����t����Q�� ���v��t�'���ZI-g0�@�����R-�4r��¿|�3u��É�O����6F~���h����Ř�         b   , BDHPVRI.lvlib:PhFile ToneDesc.ctl          e   ux�c``(�`��P���Z�+�!���FЏ�7���a �( 	���h/��>��� �l���9�2-���W)b��z�\�8Se�<� ��G                  NI.LV.ALL.VILastSavedTarget �      0����      Dflt       NI.LV.ALL.goodSyntaxTargets �      0����  @ ����          Dflt       NI_IconEditor �     @0����data string     513008047    Load & Unload.lvclass       	  ddPTH0                 Layer.lvclass         �          � (  �                 ��� ��   ������  ������  ������  ����ff  ����33  ����    ������  ������  ���̙�  ����ff  ����33  ����    ������  ������  ������  ����ff  ����33  ����    ��ff��  ��ff��  ��ff��  ��ffff  ��ff33  ��ff    ��33��  ��33��  ��33��  ��33ff  ��3333  ��33    ��  ��  ��  ��  ��  ��  ��  ff  ��  33  ��      ������  ������  ������  ����ff  ����33  ����    ������  ������  ���̙�  ����ff  ����33  ����    �̙���  �̙���  �̙���  �̙�ff  �̙�33  �̙�    ��ff��  ��ff��  ��ff��  ��ffff  ��ff33  ��ff    ��33��  ��33��  ��33��  ��33ff  ��3333  ��33    ��  ��  ��  ��  ��  ��  ��  ff  ��  33  ��      ������  ������  ������  ����ff  ����33  ����    ������  ������  ���̙�  ����ff  ����33  ����    ������  ������  ������  ����ff  ����33  ����    ��ff��  ��ff��  ��ff��  ��ffff  ��ff33  ��ff    ��33��  ��33��  ��33��  ��33ff  ��3333  ��33    ��  ��  ��  ��  ��  ��  ��  ff  ��  33  ��      ff����  ff����  ff����  ff��ff  ff��33  ff��    ff����  ff����  ff�̙�  ff��ff  ff��33  ff��    ff����  ff����  ff����  ff��ff  ff��33  ff��    ffff��  ffff��  ffff��  ffffff  ffff33  ffff    ff33��  ff33��  ff33��  ff33ff  ff3333  ff33    ff  ��  ff  ��  ff  ��  ff  ff  ff  33  ff      33����  33����  33����  33��ff  33��33  33��    33����  33����  33�̙�  33��ff  33��33  33��    33����  33����  33����  33��ff  33��33  33��    33ff��  33ff��  33ff��  33ffff  33ff33  33ff    3333��  3333��  3333��  3333ff  333333  3333    33  ��  33  ��  33  ��  33  ff  33  33  33        ����    ����    ����    ��ff    ��33    ��      ����    ����    �̙�    ��ff    ��33    ��      ����    ����    ����    ��ff    ��33    ��      ff��    ff��    ff��    ffff    ff33    ff      33��    33��    33��    33ff    3333    33        ��      ��      ��      ff      33  ��      ��      ��      ��      ��      ww      UU      DD      ""              ��      ��      ��      ��      ��      ww      UU      DD      ""              ��      ��      ��      ��      ��      ww      UU      DD      ""        ������  ������  ������  ������  ������  wwwwww  UUUUUU  DDDDDD  """"""          �������������������������������������������������������������������������������������������������+++��+��+��++��+��+�+++�+���+���+��+�+��+��++��++�+��+��++�++���+++��++++�+��+�+�++��+��+�+�+���+����+��+�++++�+��+��+��+���+���+����+��+�+��+�+��+��+��+���+����������������������������������������������������������������������������������������������������������������������������������                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                ������������������������������������������������                                                                                   
NI_Libraryd     Layer.lvclass         �          � (  �                 ���                                                                                                              ���   ���   ���         ���   ������   ���         ���         ���   ���������            ���   ���   ���   ���   ���   ���      ���   ������   ������   ���   ���      ���                     ���         ���         ���            ������   ������   ���   ���                        ���������   ���   ���   ���   ���   ���      ������   ������   ���   ���   ���   ���            ���������   ���   ���   ���   ���   ������   ������   ������         ���   ���������         ������������������������������������������������������������������������������������������      ������������         ���         ���         ���   ���         ���         ���������������      ������������   ���������   ���������   ���   ���   ���   ���������   ���������������������      ������������         ���      ������      ������   ���      ������         ���������������      ������������������   ���   ���������   ���   ���   ���   ���������������   ���������������      ������������         ���         ���   ���   ���   ���         ���         ���������������      ��������������������������������������������������������������ݪ��������������������������      ��������������������������������������������ݪ��������������������������������������������      ��̪��������������������������������������������www�����̙��www���������������������������      ��������̪�����������������������������������wwwwwwffffffDDDwww���������������������������      ��������������ݪ�����������������������������wwwfffffffffffffff���fffDDDffffffDDDDDDDDD���      ��������������������̪�����������������������wwwffffffffffffwwwffffff333fffffffffDDDDDD���      ��������������������������̙�����������������wwwfffDDDffffffwwwfffffffffwwwwwwfffDDDDDD���      �����������������������������ݪ��������������wwwffffffffffff���fffffffff���fffDDDDDDDDD���      ���      ���������      ���������      ������   wwwwww   fff   wwwfffwwwwwwffffffDDDDDD���      ���      ������   ������   ���   ������   ���   ������   ���   wwwfffffffffDDDDDDDDDfff���         ������   ���   ������������   ������   ���   ������   ���   ������fffDDDDDDDDDDDD������                  ���   ������   ���   ���   ������   ������   ���   ���������DDDDDD������������         ������   ������      ���������   ���   ������      ������   ���������������������������      ������������������������������������������������������������������������������������������               ���������      ������         ���������      ������   ���������   ������                  ������   ������      ������   ������   ������      ������      ���      ���   ���������               ������   ������   ���         ������   ������   ���   ���   ���   ������      ���         ������������            ���   ������   ���            ���   ���������   ������������            ������������   ������   ���   ������   ���   ������   ���   ���������   ���         ���                                                                                                   ��������������������������������������������������������������������������������������������������������������������������������   VI Icond                  ���               Small Fonts 	        	      $   (         .        ���C              �                   ��	     LUU�@ �	�                                                   
�#>
�#>�@'>�@'>     L   ?          ,  �x�m��J�@�O:�I�����.�v�EŮ��	Eܔ�6�h`�@��K�O�a|�����;��o��0ƈ3�}������ts��8	�����'�D>�a|҂a�������l�!k����\�NO�+p|�9�w ����j"�e����y$�{�bq!6��O%����fe , �D�V������;m��L���"-
B����v�aYR��׭-�(�J�D�,}	���=Zӓ5�f��;���9.�8$Gk@N�f����s�����:�Z���6Y6���bH����5=���O~   w       X      � �   a      � �   j      � �   s� � �   � �   u� � �  � �Segoe UISegoe UISegoe UI00 RSRC
 LVCCLBVW  [0  |      [               4  h   LIBN      xLVSR      �RTSG      �OBSG      �CCST      �LIvi      �CONP      �TM80      DFDS      LIds      ,VICD      @vers     TGCPR      �STRG      �ICON      �icl4      �icl8      CPC2      LIfp      0FPHb      DFPSE      XLIbd      lBDHb      �BDSE      �VITS      �DTHP      �MUID      �HIST      �PRT       �VCTP      FTAB           ����                                   ����       �        ����       �        ����       �        ����       �        ����      (        ����      0        ����      X        ����      �        ����      �       ����             ����      ,       ����      <       	����      P       
����      `        ����      t        ����      �        ����      $�        ����      %p        ����      't        ����      +x        ����      +�        ����      +�        ����      <�        ����      <�        ����      =,        ����      =�        ����      =�        ����      X�        ����      X�        ����      X�        ����      X�        ����      Yd       �����      Z�    PhFile ToneDesc.ctl