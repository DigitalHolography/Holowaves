RSRC
 LVCCLBVW  Y�  �      Y�      	VRI.lvlib     � �  0           < � @�      ����            ���!$?C�L��:��   
       K����O�wOq����ُ ��	���B~                          1�����b�l�͂#�   '�N|!��rB�@W�Ʒ          V LVCC!VRI.lvlib:ACQUIPARAMS Display.ctl      VILB    PTH0       	VRI.lvlib               %   &x�c�d`j`�� Č?@4��D3p@e �b
�      I  $x�c`��� H120�t i4q0cS ���\�Bř �e��2�X<��LP5*9 N@7��� �I&}      0 VIDS!VRI.lvlib:ACQUIPARAMS Display.ctl         �  <x����K#Q�g����A�X�+�`P��b���@��A�\��#D,�8�����"RY��^qw����_e�73�3�,�k {�K�?I`a����P�j\+F��?n���+�F#��k�G�>�QY�?'闿g-�4���O����*^��=�B<�<2��`��i5�w����1X����{ׅG�U��ki�
�߻��E��	���.��������gz+e3��������3�g�p�q�q�p'�1�c<Gx.�3�g<Ox>/0^`�@x!www	w޹n�j/1�j�?��;�ݏ.�L��ѽ�Ƣ�� E%;߯dS�&��v��-ը����������H(���,�Ǥ�5PJΊ(�c
?p��N���A�2��}��d
�.N��~��|����IgI�a>M�R��8�񮔏��>g�5㋱3�
�+��+շ��g�2�      �  13.0.1       �   13.0    �  13.0.1       �   13.0    �  13.0.1                        ^  ZPhCon.dll

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
     ���������������h���-��-M���m���m������������������  �  � D� �� ��� ��� ��� �������R������T�aɊd�  �dOɒf��\�M���C�R�]����   �����������������UUUUUUUUUUUUUU_�UUUUUUUUUUUUUU_��U�\U�U�\\�\U\_�U��\U�U�\U�\��_��U��\U���U�\\\_�UU�\\���\U�\U\_�UU�\\U��\U�\U\_�UUUUUUUUUUUUUU_�UUUUUUUUUUUUUU_�UUUUUUUUUUUUUU_��������������������  �  �   ��������� �   ������������   ��������������� �������������  �������������   �������������    ������������� � ������������ � ��������� ��  ��������� � ���� �� ���  � �              �� �� �  ��� �� ���� �� �� � ��  �� ���   ��  � �� �����������������   �������������������������������������������������������������������������������������������������+++��+��+��++��+��+�+++�+���+���+��+�+��+��++��++�+��+��++�++���+++��++++�+��+�+�++��+��+�+�+���+����+��+�++++�+��+��+��+���+���+����+��+�+��+�+��+��+��+���+���������������������������������������������������������������������������������������������������������������������������������������+�      ���     ��        ������VV�������+��    VV+       ��+�����VVVVVVVVVV�V+V�VV       ��  +����VVVVVVVV������V�VV�VV� ��    ���VVVVVVVV������V������� ��      +�VVVVVVV��������������+��       �+VVVVVV�����������������         ��VVVV�����V���V����+�� ��   ��   ��VV����������������� ��  �  � �  �+�V��+��������� ���  � �    �  � �+ � � ������+ ������ �  � � �  �  � �  +�� �  ���  �  ��   � �  ��  �    +    ��                              �����   ��  ���   ��  �   �  ������  �  ��  �  �  ��  �� �� �   �����  �  � ���  �  � � � �  �� ���    ���� �  � ���� �   �    ����    �  � �  � �  � �   � ��� ���������������������������������         0 FPHP!VRI.lvlib:ACQUIPARAMS Display.ctl         $  ?px��[]l�u�YR��JB��MK�^�$�t��J�G��P\�e*S��j��2ܹ�;���z~(RE�e\�E�Z����>�Om���/��B^��<4�
��oP�iS#��{�����?��,.��r��s�=�;?��]M���;���}������Ֆ�2wtM�=���g�E-w]�_M������so���gZ���;�b�%��b�@e೹wa���i �m�n�<:���;��o�{鈤:���}K����������v������д~W�K��GW�n����t�4#�i�7J;'��;����oɁ�@X���k���Z<�˥��0i����(3q{�1`�?vg��ɲ9��"��F��ʎ�ڧ��vr0�mJՔ%��H�s]��[ze�Ε�����[GN>�������o���q#�����?pc�0���`3>����V��jK4w��"�����-�-��`}��"Sz)�������A�j�s��ۣ��?s}ie�<��*)Y~�6���r�\(���uXøb3�Xi'�)�r�pyTԷ���W{��WA%p���a�cw�yi��5��f�K$ҥ�]�IV+}�VC�枅'��N�Bio��yv�>�:Ӷ�ٹ���[��:d����瓼���l6�jR�V�xa% �QS�g#K�s}iy�,5�`�A}�������Q�Ĵ�񁓯N�ej���l6���b������=���x��f��C��&xɻ�a8�+���ӊ���2�TNP���2��̀:&5����L����󙙡��`�Q�����G���)A�<ǰ��:�C�aV��
R��i�&�%��ӵ?�Ҁ��=�V�Ȅ��e̻��&�V,�ߺE	`� V5L�:6,̢�9�X]�oV����*e����b���C�[�*	\�T^z���X��0pUL��p�H�v�J7�-�þ�*H�s"�z�`v���&��,Nd���X^��&�i%,�+�Ӧ{Ͼr��Uc]�d,#M�,��n>�� b8&�b�{+���e�BN��ؠ
kzk`�)��)���~�-Z�,5���0l�/�j!���AQ��X[zz��E��<���A�)�2�:�C��Ӫ+�}����fY� o�04fǟ	���>�
�f�j�*[G���	^�����ˮ�A�Ҡ��"�����l7B�;�	� ����Q���ش�U�Q��2NNK
M�Cr�P�t��{}�a���]��ЉS2izn�TRxye5�M?��W�fӦP�����	�S�" �p|�]EkB-5j��s�/=?+�/��Y��+uL��C�\?A(��-�q���v�~?�	�j��b��Ք<Y���V`U<霿D!�Bv�H�Hv���c�Aa�CRcx�ZZ���K�ߡ71�<$*�W�ms!�)S;'G�/Q��X�<J���B-Q�V�hAC*rF�C��EI���B`L�j�R\ƈp�=7���"Z� Q�z�XA�6۫p���'1���ѵ��L�Ч���O�6|�
+;�NXTe$�x��R��M#`
^�Vr��v��Q����*&�{ �NR@���8�Db*U���xʰ��R����F��ӄ�S/O�����C2�F͸t;�yʣԑ����5X��p� d���~�n؆S�}j���yW�8\w����^���lD 5xW���0 �V�&3S�E]6��8��R��`��87r��s]�Aj޵a�e2�yPg0���G'@U�Xld'���_�����N`ߪ,Q��YM�o�],~�1q�?����F<���$�5e�?E[Q���z6�^��2 �ўy_��0��ó��W���p1����7����3@p7�Mj��lo�7yMw�q�8�q)�!l�5?a�����IVߟ/^������$�d!��@ڽ	!>P<����w��4��H"�n@i���Ŷ{��Xz2P�L��O]&O����E.��T<V�(��X�bym��y��YN��3������(�&�s�!sĶ�$py�d�vE��Us��2�UC�»@��h����br��f	�
�m@y��c�V.�-�b� �u@0B{ѾHVM�nX`#T��?M�;+ ]��,����D��  �0`$�����	1w�{7(�9��;o���y��B�.��R���+���DeGq��x?���.bJą��:f�F��,
m��P�C%аl�V-�,�kU�z>�|8��ዔ,�~�P�`���V�R�v%+���\���
�?,I;b���
�Q3�C�i8</�
`��<7�_��1f>g�d8���B�	��99�#�r1-�����B���hʟg�!"T<ys*�dxaf ���ʡ���E���%Z���lJkC�����H�.��ÂbFȊ�����<*6͠W"���4�	���s±q�L,Va��0R2��5]G'2�  �X�m4C���b�!`������J�'T�6��۲���ZE��&�I�1��ʖ2�j�N �a�a��͒�Z�H�6U�T���i��ו��Q(�taԪP&.�u�oQϝ�7��A��v��Y(�jx5i�In|<�8q
�cE&��5\�qȢk�`�4*V�X��t�7.�%6������(�V���4Y*~��<��q�VY���!���P�1�w%����`BݗIv4�����P".��箂�Mp��sE�����e�$~�A@e��VDnዂsc?�A:
{�*l��q�����F�^����k���^�zG�tPǺ��Fh$����jp���l��K�jC�1�RRkR����Զ����RlOGeg,x�×(���1�Z�F�Y�m9��K��O%��*J�}R��,Q11�Q�R_�Ț�YA��,q�X�1�QL���	[�2�K�������/24���>ob����sO��s�A8'z�I�q\�3
C�Eۄ��ach%C[�t�&(>���ՠ��c�)���Mc�'5𸮱Ti
�1sX�by�q)����M�+�l���e�B�q��ڄm��[-6�y�D��<2�u5l$�XX�Ҵ�'y���7e�u*����f��v�-�*L�U�;��1s����XO��SQh��	q��J�{���~~�m�X�NG4������x�ZH� Y�um8�F����x� ��݉�N�M��	�W,��V�a���'�v�!��=�̩���S��HO���z�]���^��`gK�c�w���������i�L�����&����&���ٯ��6�,}]���ɑ:��6���k�s,����	̱`έ{�6�J�i��vڤ�hE��5:m2���i���}O����O��k��N�d،0��sT��L��˦6��L�?��]O�|�'LR�IZ6l�,��V��̝�̅�;Y��#�Ǵ	�I���!��?��
WN}���������Lo�bU�=�J}����4v'Ũ��9�|F;�^�u�סXg
Ϸ��#V'`aC��57*�TI�"�Ρ/��2�krhf$���AX�"�'`�c�f}�Ҭ'�9�J�Ei���;���n��G@�7�z�	_�c&�d�T>(rv����|������
�L+����>C��� h�:�zM9�S>���<0�bj�h�v'F���-�N��X_�m���Þ0~r�����ށb�G��ڛ�	��[*���Ҝ����b����;D���(���~,O����8O����]t��(�O��d�p��� �>���
���ڽ�wt~�+���q�>T��/\�C�
�� \���
����C��C]�q��������`UR[��Ϟ���>�Lt%;������:Tp��C�� ��?���=�������s���+���]�d�,��
��|O+'<e�����)�{��KN��b�*H>�';|e����W�x84�2�&��p���o}��2���A|E�{��>(}�3{�`��U��Ǻz�~D��A��ik	�Џ��!k��=����]�CO���3�)����T8��?z��O0��'{zGNz��=~� ���"��i�Ix��,�D/�:�����#�
�Ç
��> �:(�O��	�l|\��<��g#�X<ӶY�Gz��s��vʟ|u���;T0=T0�� ��|�'�����r�g��}2�Ɗ�6���A[�rW�~ى�����C��¡����y�8?�����I�g���o鷿F�oO���v��[ ��h�J��nn	�����WRwu��_O��~��k��
�����wv�S�^�~C��ѭ�?I��?VpA      �   0 BDHP!VRI.lvlib:ACQUIPARAMS Display.ctl          e   ux�c``(�`��P���Z�+�!���FЏ�7���a �( 	���h/��>��� �l���9�2-���W)b��z�\�8Se�<� ��G                  NI.LV.ALL.VILastSavedTarget �      0����      Dflt       NI.LV.ALL.goodSyntaxTargets �      0����  @ ����          Dflt       NI_IconEditor �     @0����data string     513008047    Load & Unload.lvclass       	  ddPTH0                 Layer.lvclass         �          � (  �                 ��� ��   ������  ������  ������  ����ff  ����33  ����    ������  ������  ���̙�  ����ff  ����33  ����    ������  ������  ������  ����ff  ����33  ����    ��ff��  ��ff��  ��ff��  ��ffff  ��ff33  ��ff    ��33��  ��33��  ��33��  ��33ff  ��3333  ��33    ��  ��  ��  ��  ��  ��  ��  ff  ��  33  ��      ������  ������  ������  ����ff  ����33  ����    ������  ������  ���̙�  ����ff  ����33  ����    �̙���  �̙���  �̙���  �̙�ff  �̙�33  �̙�    ��ff��  ��ff��  ��ff��  ��ffff  ��ff33  ��ff    ��33��  ��33��  ��33��  ��33ff  ��3333  ��33    ��  ��  ��  ��  ��  ��  ��  ff  ��  33  ��      ������  ������  ������  ����ff  ����33  ����    ������  ������  ���̙�  ����ff  ����33  ����    ������  ������  ������  ����ff  ����33  ����    ��ff��  ��ff��  ��ff��  ��ffff  ��ff33  ��ff    ��33��  ��33��  ��33��  ��33ff  ��3333  ��33    ��  ��  ��  ��  ��  ��  ��  ff  ��  33  ��      ff����  ff����  ff����  ff��ff  ff��33  ff��    ff����  ff����  ff�̙�  ff��ff  ff��33  ff��    ff����  ff����  ff����  ff��ff  ff��33  ff��    ffff��  ffff��  ffff��  ffffff  ffff33  ffff    ff33��  ff33��  ff33��  ff33ff  ff3333  ff33    ff  ��  ff  ��  ff  ��  ff  ff  ff  33  ff      33����  33����  33����  33��ff  33��33  33��    33����  33����  33�̙�  33��ff  33��33  33��    33����  33����  33����  33��ff  33��33  33��    33ff��  33ff��  33ff��  33ffff  33ff33  33ff    3333��  3333��  3333��  3333ff  333333  3333    33  ��  33  ��  33  ��  33  ff  33  33  33        ����    ����    ����    ��ff    ��33    ��      ����    ����    �̙�    ��ff    ��33    ��      ����    ����    ����    ��ff    ��33    ��      ff��    ff��    ff��    ffff    ff33    ff      33��    33��    33��    33ff    3333    33        ��      ��      ��      ff      33  ��      ��      ��      ��      ��      ww      UU      DD      ""              ��      ��      ��      ��      ��      ww      UU      DD      ""              ��      ��      ��      ��      ��      ww      UU      DD      ""        ������  ������  ������  ������  ������  wwwwww  UUUUUU  DDDDDD  """"""          �������������������������������������������������������������������������������������������������+++��+��+��++��+��+�+++�+���+���+��+�+��+��++��++�+��+��++�++���+++��++++�+��+�+�++��+��+�+�+���+����+��+�++++�+��+��+��+���+���+����+��+�+��+�+��+��+��+���+����������������������������������������������������������������������������������������������������������������������������������                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                ������������������������������������������������                                                                                   
NI_Libraryd     Layer.lvclass         �          � (  �                 ���                                                                                                              ���   ���   ���         ���   ������   ���         ���         ���   ���������            ���   ���   ���   ���   ���   ���      ���   ������   ������   ���   ���      ���                     ���         ���         ���            ������   ������   ���   ���                        ���������   ���   ���   ���   ���   ���      ������   ������   ���   ���   ���   ���            ���������   ���   ���   ���   ���   ������   ������   ������         ���   ���������         ������������������������������������������������������������������������������������������      ������������         ���         ���         ���   ���         ���         ���������������      ������������   ���������   ���������   ���   ���   ���   ���������   ���������������������      ������������         ���      ������      ������   ���      ������         ���������������      ������������������   ���   ���������   ���   ���   ���   ���������������   ���������������      ������������         ���         ���   ���   ���   ���         ���         ���������������      ��������������������������������������������������������������ݪ��������������������������      ��������������������������������������������ݪ��������������������������������������������      ��̪��������������������������������������������www�����̙��www���������������������������      ��������̪�����������������������������������wwwwwwffffffDDDwww���������������������������      ��������������ݪ�����������������������������wwwfffffffffffffff���fffDDDffffffDDDDDDDDD���      ��������������������̪�����������������������wwwffffffffffffwwwffffff333fffffffffDDDDDD���      ��������������������������̙�����������������wwwfffDDDffffffwwwfffffffffwwwwwwfffDDDDDD���      �����������������������������ݪ��������������wwwffffffffffff���fffffffff���fffDDDDDDDDD���      ���      ���������      ���������      ������   wwwwww   fff   wwwfffwwwwwwffffffDDDDDD���      ���      ������   ������   ���   ������   ���   ������   ���   wwwfffffffffDDDDDDDDDfff���         ������   ���   ������������   ������   ���   ������   ���   ������fffDDDDDDDDDDDD������                  ���   ������   ���   ���   ������   ������   ���   ���������DDDDDD������������         ������   ������      ���������   ���   ������      ������   ���������������������������      ������������������������������������������������������������������������������������������               ���������      ������         ���������      ������   ���������   ������                  ������   ������      ������   ������   ������      ������      ���      ���   ���������               ������   ������   ���         ������   ������   ���   ���   ���   ������      ���         ������������            ���   ������   ���            ���   ���������   ������������            ������������   ������   ���   ������   ���   ������   ���   ���������   ���         ���                                                                                                   ��������������������������������������������������������������������������������������������������������������������������������   VI Icond                  ���               Small Fonts 	              �   (         +        ���C              �                   ��	     LUU�@ �	�                                                   
�#>
�#>�@'>�@'>     L   ?          U  /x��O�N�@Xj[�?Q�M���Ɠ/ �ЃI���'
4)�Э����s�6��C1Q/f���|��f��P���{�/G(�h����ÑDB��iw�]�JZ��M�(�z�a-$�5(��������I�	#it���4��h�i��L�����&��|~��w d�;�6����5[׷��t�W7��G��=��@�7�,rP��U��s� y�������k8�G���b�5�D��T���L(�������@=������>8\��Z�H��4<�M�4�B��9��u������N�������<]c6��b�(����T��'+r���B�`1�9=Q4      w       X      � �   a      � �   j      � �   s� � �   � �   u� � �  � �Segoe UISegoe UISegoe UI00 RSRC
 LVCCLBVW  Y�  �      Y�               4  h   LIBN      xLVSR      �RTSG      �OBSG      �CCST      �LIvi      �CONP      �TM80      DFDS      LIds      ,VICD      @vers     TGCPR      �STRG      �ICON      �icl4      �icl8      CPC2      LIfp      0FPHb      DFPSE      XLIbd      lBDHb      �BDSE      �VITS      �DTHP      �MUID      �HIST      �PRT       �VCTP      FTAB           ����                                   ����       �        ����       �        ����       �        ����       �        ����      ,        ����      4        ����      `        ����      �        ����      �       ����      �       ����      �       ����      �       	����              
����              ����      $        ����      8        ����      #�        ����      $         ����      &$        ����      *(        ����      *0        ����      *d        ����      ;�        ����      ;�        ����      ;�        ����      <4        ����      <<        ����      W@        ����      WH        ����      WP        ����      W|        ����      X        �����      Y\    ACQUIPARAMS Display.ctl