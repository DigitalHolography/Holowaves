RSRC
 LVCCLBVW  W$  �      W      	VRI.lvlib     � �  0           < � @�      ����            �p1qT�O�jt�bΞs   
       llOt�cO���
g�d���ُ ��	���B~                                             /�e�4 +��t$F�          V LVCC!VRI.lvlib:PhFile SAVECINEINFO.ctl      VILB    PTH0       	VRI.lvlib               %   &x�c�d`j`�� Č?@4��D3p@e �b
�      J  $x�c`��� H120�x i4q0cS ���\�Bř �e��2�X4��LP59 v@7�]  ��%�     0 VIDS!VRI.lvlib:PhFile SAVECINEINFO.ctl         �  �x�;���P^af����d340$秤r1 �p�	B��4��G���G3 �� �:��L�-� ^w� u�!,��hx�����	�*�h��3��� �<$�*��[�A5*@݇��8��0� �ۧ�q�Og� �����-`y���(��������u1!jY-X����vb#� ~׃`�u�D�at��N�|�{=:KT<>b��� sn�	���N>��.|b ��O��P<���C��	 5���0���.F� �������\�1�c�O�cG#���p��`���wT@�Z�k&�302\Қ@z6#�H+i�Y�L07�l�O?322	1)#$���.��� � (�   �  13.0.1       �   13.0    �  13.0.1       �   13.0    �  13.0.1                        ^  ZPhCon.dll

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
     ���������������h���-��-M���m���m������������������  �  � D� �� ��� ��� ��� �������R������T�aɊd�  �dOɒf��\�M���C�R�]����   �����������������UUUUUUUUUUUUUU_�UUUUUUUUUUUUUU_��U�\U�U�\\�\U\_�U��\U�U�\U�\��_��U��\U���U�\\\_�UU�\\���\U�\U\_�UU�\\U��\U�\U\_�UUUUUUUUUUUUUU_�UUUUUUUUUUUUUU_�UUUUUUUUUUUUUU_��������������������  �  �   ��������� �   ������������   ��������������� �������������  �������������   �������������    ������������� � ������������ � ��������� ��  ��������� � ���� �� ���  � �              �� �� �  ��� �� ���� �� �� � ��  �� ���   ��  � �� �����������������   �������������������������������������������������������������������������������������������������+++��+��+��++��+��+�+++�+���+���+��+�+��+��++��++�+��+��++�++���+++��++++�+��+�+�++��+��+�+�+���+����+��+�++++�+��+��+��+���+���+����+��+�+��+�+��+��+��+���+���������������������������������������������������������������������������������������������������������������������������������������+�      ���     ��        ������VV�������+��    VV+       ��+�����VVVVVVVVVV�V+V�VV       ��  +����VVVVVVVV������V�VV�VV� ��    ���VVVVVVVV������V������� ��      +�VVVVVVV��������������+��       �+VVVVVV�����������������         ��VVVV�����V���V����+�� ��   ��   ��VV����������������� ��  �  � �  �+�V��+��������� ���  � �    �  � �+ � � ������+ ������ �  � � �  �  � �  +�� �  ���  �  ��   � �  ��  �    +    ��                              �����   ��  ���   ��  �   �  ������  �  ��  �  �  ��  �� �� �   �����  �  � ���  �  � � � �  �� ���    ���� �  � ���� �   �    ����    �  � �  � �  � �   � ��� ���������������������������������         0 FPHP!VRI.lvlib:PhFile SAVECINEINFO.ctl         �  *Zx��Z�o����� ִ��J�w��S{�N�@�B�f�[Ǭ� �i����;0;�̇?RUe���S%*!���/�T�Ti�`��**��� ��s;덓�*K٬g�������=��r�R����]E�|_w�c[U���)E�L��d.��Q�oQw�����'7ԣ�ꏍ�T���X=�� �),�;s��w՟���(�����h���B�#ʱ��ꍁ���_�^�r@����ϑi���V�m�-k6��������rxW�Zپ���|8��?1�����,`�S�~������1 �`j<4�5�n� h����I3���r*�7~��#Q7i���R��MSeUFwؓ����ٝ��#�O���?*��n}����jj�w{�|q0?���`�;�Ϩ�������*C(���E�귘/��/������p嵌;���� J�xe��ء�ҥ�rui���p�{&3ε��J6���㒳�{*���!P$��CʐRRޗ�(o���>c��>�݉���?G�7b#�"��a0�����e���j͙�o��U�Fm�����*;vް�t�����雎M�5WkS��ɕ�O\�.�j��+�鴿١m�w�'�֔ާ�&�s���J��'M�o��33SmkMJ�Mm$y2�c�l��b:~��j�4�c�q�a�n~��x�K�	Y�Sb����5���؆7)�Wj	@Z����mP����6uj7)�����z�T�ji�7��"�i�E	��ښ�>p�uL�1Xٴu�l�M�vz3��W�����6nw�f������Qv�/&��M�g^�0qK +�jql6fR˘��.�W,<x�HC�� /n��� ���������!�Z������wdL��h���ݷp��QK��}'�i"�y�a�>ҕ�F	ٷ�	k�到Fu_�į N�L}�Ek�`"#K�,���5��b�l��>1��هŵ5ʹ��г��k��>8�r譂��0�M���݂�z~�M4�Ԛf�|��$a�����j����9"�\��� ��QY����L�i9��9CX�@E� �k,���w�x�����������������B���� ���c_r,H���6m;�&�QV'����w<�;h�AS5T���;رa6ԥ`-���<9�PX��X��)�#[���ܮ�����$���4@M��זW|��y%�t,
M���c=\�šћ�m�Q �h�Gl��hOB�j���>3{�J1$��Yo����z�>�Pd׏B�JfDt��8OJ��@���`��þl��ל\�'���]vŋ��i`
e���35��?8�˂���]��Dg���Z���K�ߦ똂�%��.Z(~�~��%:��(,u��k�QK�<5j:4-�HI/��M<h�)�/�1�F������6F�;��:A��ӆ	���s��+��݅�:xm%��\���۟]���4	<�,��4,����;�	˪�� ���!X������hǠ�!|�;.5���)�j¹�m'�}1�J���U���9ʹkR�63�O<�kz��	��^^6D���ͰFhM��ݧ�9�R;�ϗ�͊�
0@�O�L���fi�N��
p�=
��Ds.48�^����	��iZ�@��2�WZ��v��HV����lkqa�����qm�2J=����X@�`Z ��\��xc~����=#���2��Y陓��t�� �Via�z�kv0�=3W�>[j�B#~/�?�8��<�~Q:�O��үp^O�1*��R�"۳��6����xR��"�:��:�1O�p�fA-���g��t'����ӑA�yj���#���I���N�m�<:5ɥ`�OV,�v�!��>����6{���� טI��mh��A;� ���j+OZڟ)����H��q�P�����C��E�.�k���� g���d<x>�ε���&�R-OH�X&�oC�J�mH����Y1�b�����u��1��)fo+t"?,����7�:56����
)&N21���ڍ�Ea7�q�	>B3I�ӡ|��Ec�PD4u��" $5��4
�y?!h�zO�"�cع�Y>�.c�T���)�Al�B�$:�8��h���q��["�DRx�la%hG��ˢ�ZH���pl������yr���Cף\g��<Q�ã�,]h���l���P�w�gn����[�}9�Kf	�h����l^�5� ���<^�V` 3���@�l��c���c����a���(���B!�����r��1d�N%�\�^X� ��'�D���ơo�@�eb�`@��a������!i�Qb�V�є�C�fɀ�1#t��gy�a.�f�+� 	��u�Cg �l�)S����"a_FFf���jD��Dӝv'��V��Z^ �<dv� %.�`��۲���VCi��$�I�9��ʦ0ŚPN �a�aK�FE�50m8H}*�+hR�|��ץ����)M�hUa,\�cO_��3q�
+C��A�	:�T�����(?�,J.�7�dhq=�8*�.�\��v0�q ���'�]G�M?�p�|<7Γ*[��Ȍ��ؕ(�Q�R=�L@EVJE�I}�C�`ܠִ0�@
�Y
M�[I'�<��0��^yz�|Z���Ri��P�[]�������a��/L�I��7#v�O	v,��d��(�D���������&(1\�P~|��?�~G�lPۼ��v`�&����z�6,��B��U�	y�΄MI���yo�h��^��T)v���d,D�ͷ(���1���Gᣜ����9r�O\�*1�gP��퓢%d����(�J��'X�t\�o���"n<:�롕��0a�BXƳ�0@�{���8��D���<�C,9�1߀`���(1'_@rbv���%�>�4�ݴ�C�M��2tL���3a���<���<�Z�6=҄��K����m/Ԗ_�[9���n��\�m�$�/k&���5&�l�:�h�q�̱\&�x8�#�(��i#Q��Ƣ��y���G���ש�+�c���WX&��6�Pa�Gu@�o;�V�`μ"B���>%��<^�[+�ǳ'�c���d�9�y�)���z��-;�_�� a#�n�'��y��8�,@ Nw����aA��K-q�k�)�艡�hDH��Li�p�������� ^Q'����alO���K��#����fe��K]�G�w��\iq����W����4&м,_�w��[_yn�����<�}a���>]R���Hs�7ׯ����>RW>c�G�2���P���L������=/���o�����6� o�Ba�]���J����ٝ�tC�A�~eBy4�����W_};��X��q�gC�V�Oo���BC�>���l���0��}�U�w�y����(��zc�\��>K[r?3c�ezj��_��o�R�L.��m`��L��6G�>w���o_�zB�{w�oW�������=�^l�A�~�/�&x��L��Pr���ű�3����}:����%���lׅ���	�t�=�t��v�t�Gͅz2ݷkx�xu`�(��&�B���I���8�JI�������f����ۏ��;E��(��Z�<��B����;E��MQ>w�%Q>�$ե�'	�����le��y���z�R~�L�����̛P��|_L���|��*��������������/l}��V�[�W�����c��        7   0 BDHP!VRI.lvlib:PhFile SAVECINEINFO.ctl          e   ux�c``(�`��P���Z�+�!���FЏ�7���a �( 	���h/��>��� �l���9�2-���W)b��z�\�8Se�<� ��G                  NI.LV.ALL.VILastSavedTarget �      0����      Dflt       NI.LV.ALL.goodSyntaxTargets �      0����  @ ����          Dflt       NI_IconEditor �     @0����data string     513008047    Load & Unload.lvclass       	  ddPTH0                 Layer.lvclass         �          � (  �                 ��� ��   ������  ������  ������  ����ff  ����33  ����    ������  ������  ���̙�  ����ff  ����33  ����    ������  ������  ������  ����ff  ����33  ����    ��ff��  ��ff��  ��ff��  ��ffff  ��ff33  ��ff    ��33��  ��33��  ��33��  ��33ff  ��3333  ��33    ��  ��  ��  ��  ��  ��  ��  ff  ��  33  ��      ������  ������  ������  ����ff  ����33  ����    ������  ������  ���̙�  ����ff  ����33  ����    �̙���  �̙���  �̙���  �̙�ff  �̙�33  �̙�    ��ff��  ��ff��  ��ff��  ��ffff  ��ff33  ��ff    ��33��  ��33��  ��33��  ��33ff  ��3333  ��33    ��  ��  ��  ��  ��  ��  ��  ff  ��  33  ��      ������  ������  ������  ����ff  ����33  ����    ������  ������  ���̙�  ����ff  ����33  ����    ������  ������  ������  ����ff  ����33  ����    ��ff��  ��ff��  ��ff��  ��ffff  ��ff33  ��ff    ��33��  ��33��  ��33��  ��33ff  ��3333  ��33    ��  ��  ��  ��  ��  ��  ��  ff  ��  33  ��      ff����  ff����  ff����  ff��ff  ff��33  ff��    ff����  ff����  ff�̙�  ff��ff  ff��33  ff��    ff����  ff����  ff����  ff��ff  ff��33  ff��    ffff��  ffff��  ffff��  ffffff  ffff33  ffff    ff33��  ff33��  ff33��  ff33ff  ff3333  ff33    ff  ��  ff  ��  ff  ��  ff  ff  ff  33  ff      33����  33����  33����  33��ff  33��33  33��    33����  33����  33�̙�  33��ff  33��33  33��    33����  33����  33����  33��ff  33��33  33��    33ff��  33ff��  33ff��  33ffff  33ff33  33ff    3333��  3333��  3333��  3333ff  333333  3333    33  ��  33  ��  33  ��  33  ff  33  33  33        ����    ����    ����    ��ff    ��33    ��      ����    ����    �̙�    ��ff    ��33    ��      ����    ����    ����    ��ff    ��33    ��      ff��    ff��    ff��    ffff    ff33    ff      33��    33��    33��    33ff    3333    33        ��      ��      ��      ff      33  ��      ��      ��      ��      ��      ww      UU      DD      ""              ��      ��      ��      ��      ��      ww      UU      DD      ""              ��      ��      ��      ��      ��      ww      UU      DD      ""        ������  ������  ������  ������  ������  wwwwww  UUUUUU  DDDDDD  """"""          �������������������������������������������������������������������������������������������������+++��+��+��++��+��+�+++�+���+���+��+�+��+��++��++�+��+��++�++���+++��++++�+��+�+�++��+��+�+�+���+����+��+�++++�+��+��+��+���+���+����+��+�+��+�+��+��+��+���+����������������������������������������������������������������������������������������������������������������������������������                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                ������������������������������������������������                                                                                   
NI_Libraryd     Layer.lvclass         �          � (  �                 ���                                                                                                              ���   ���   ���         ���   ������   ���         ���         ���   ���������            ���   ���   ���   ���   ���   ���      ���   ������   ������   ���   ���      ���                     ���         ���         ���            ������   ������   ���   ���                        ���������   ���   ���   ���   ���   ���      ������   ������   ���   ���   ���   ���            ���������   ���   ���   ���   ���   ������   ������   ������         ���   ���������         ������������������������������������������������������������������������������������������      ������������         ���         ���         ���   ���         ���         ���������������      ������������   ���������   ���������   ���   ���   ���   ���������   ���������������������      ������������         ���      ������      ������   ���      ������         ���������������      ������������������   ���   ���������   ���   ���   ���   ���������������   ���������������      ������������         ���         ���   ���   ���   ���         ���         ���������������      ��������������������������������������������������������������ݪ��������������������������      ��������������������������������������������ݪ��������������������������������������������      ��̪��������������������������������������������www�����̙��www���������������������������      ��������̪�����������������������������������wwwwwwffffffDDDwww���������������������������      ��������������ݪ�����������������������������wwwfffffffffffffff���fffDDDffffffDDDDDDDDD���      ��������������������̪�����������������������wwwffffffffffffwwwffffff333fffffffffDDDDDD���      ��������������������������̙�����������������wwwfffDDDffffffwwwfffffffffwwwwwwfffDDDDDD���      �����������������������������ݪ��������������wwwffffffffffff���fffffffff���fffDDDDDDDDD���      ���      ���������      ���������      ������   wwwwww   fff   wwwfffwwwwwwffffffDDDDDD���      ���      ������   ������   ���   ������   ���   ������   ���   wwwfffffffffDDDDDDDDDfff���         ������   ���   ������������   ������   ���   ������   ���   ������fffDDDDDDDDDDDD������                  ���   ������   ���   ���   ������   ������   ���   ���������DDDDDD������������         ������   ������      ���������   ���   ������      ������   ���������������������������      ������������������������������������������������������������������������������������������               ���������      ������         ���������      ������   ���������   ������                  ������   ������      ������   ������   ������      ������      ���      ���   ���������               ������   ������   ���         ������   ������   ���   ���   ���   ������      ���         ������������            ���   ������   ���            ���   ���������   ������������            ������������   ������   ���   ������   ���   ������   ���   ���������   ���         ���                                                                                                   ��������������������������������������������������������������������������������������������������������������������������������   VI Icond                  ���               Small Fonts 	              k   (         /        ���C              �                   ��	     LUU�@ �	�                                                   
�#>
�#>�@'>�@'>     L   ?           �  xx�u��J�@��d�Ij��'��}�^z)�Mz-&�ZX�Q���|ߠ�IAA��2gfϙ3�� �pg��du���n��:ׯ	�_�'�֫tj���y��$[�'����,]��e�0��m���_'�=�#}
P�u��	����Ti6��VM��U�P
���z+J��ଵ		U�Q��e'��е	��� *{MO.˘0`(N�m�ꀿ���E��
�K�r��/�F��d�'��t"��y6���+�      w       X      � �   a      � �   j      � �   s� � �   � �   u� � �  � �Segoe UISegoe UISegoe UI00 RSRC
 LVCCLBVW  W$  �      W               4  h   LIBN      xLVSR      �RTSG      �OBSG      �CCST      �LIvi      �CONP      �TM80      DFDS      LIds      ,VICD      @vers     TGCPR      �STRG      �ICON      �icl4      �icl8      CPC2      LIfp      0FPHb      DFPSE      XLIbd      lBDHb      �BDSE      �VITS      �DTHP      �MUID      �HIST      �PRT       �VCTP      FTAB           ����                                   ����       �        ����       �        ����       �        ����       �        ����      ,        ����      4        ����      `        ����      �        ����      �       ����      t       ����      �       ����      �       	����      �       
����      �        ����      �        ����      �        ����      #H        ����      #�        ����      %�        ����      )�        ����      )�        ����      *        ����      9        ����      9        ����      9P        ����      9�        ����      9�        ����      T�        ����      T�        ����      T�        ����      U        ����      U�       �����      V�    PhFile SAVECINEINFO.ctl