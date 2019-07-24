RSRC
 LVCCLBVW  V�  y      V�      	VRI.lvlib     � �  0           < � @�      ����            �!�w0dL�}�k2f   
       ,ҕJpJ�k��M�	���ُ ��	���B~                                             ^��7���l���          R LVCCVRI.lvlib:PhInt TIME64.ctl       VILB      PTH0       	VRI.lvlib               %   &x�c�d`j`�� Č?@4��D3p@e �b
�      J  $x�c`��� H120�x i4q0cS ���\�Bř �e��2�X4��LP59 v@7�]  ��%�     * VIDSVRI.lvlib:PhInt TIME64.ctl            �  �x�;���P^af����d340$秤r1 �p�	B��4��G���G3 �� �:��L�-� ^w� u�!,��hx�����	�*�h��3��� �<$�*��[�A5*@݇��8��0� �ۧ�q�Og� �����-`y���(��������u1!jY-X����vb#� ~׃`�u�D�a�������^�����X<v8���l���x��Ӆ��_�H���)�t�4������ ����v1��G�G�V>�?�"�;v x;2a�Fp��ȀK7~ @�x �-�c���ZP]3�؜�����ҳ!��@ZH��bg`���gc(g|�����I�I!A$p�wq�' �D ���i    �  13.0.1       �   13.0    �  13.0.1       �   13.0    �  13.0.1                        ^  ZPhCon.dll

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
     ���������������h���-��-M���m���m������������������  �  � D� �� ��� ��� ��� �������R������T�aɊd�  �dOɒf��\�M���C�R�]����   �����������������UUUUUUUUUUUUUU_�UUUUUUUUUUUUUU_��U�\U�U�\\�\U\_�U��\U�U�\U�\��_��U��\U���U�\\\_�UU�\\���\U�\U\_�UU�\\U��\U�\U\_�UUUUUUUUUUUUUU_�UUUUUUUUUUUUUU_�UUUUUUUUUUUUUU_��������������������  �  �   ��������� �   ������������   ��������������� �������������  �������������   �������������    ������������� � ������������ � ��������� ��  ��������� � ���� �� ���  � �              �� �� �  ��� �� ���� �� �� � ��  �� ���   ��  � �� �����������������   �������������������������������������������������������������������������������������������������+++��+��+��++��+��+�+++�+���+���+��+�+��+��++��++�+��+��++�++���+++��++++�+��+�+�++��+��+�+�+���+����+��+�++++�+��+��+��+���+���+����+��+�+��+�+��+��+��+���+���������������������������������������������������������������������������������������������������������������������������������������+�      ���     ��        ������VV�������+��    VV+       ��+�����VVVVVVVVVV�V+V�VV       ��  +����VVVVVVVV������V�VV�VV� ��    ���VVVVVVVV������V������� ��      +�VVVVVVV��������������+��       �+VVVVVV�����������������         ��VVVV�����V���V����+�� ��   ��   ��VV����������������� ��  �  � �  �+�V��+��������� ���  � �    �  � �+ � � ������+ ������ �  � � �  �  � �  +�� �  ���  �  ��   � �  ��  �    +    ��                              �����   ��  ���   ��  �   �  ������  �  ��  �  �  ��  �� �� �   �����  �  � ���  �  � � � �  �� ���    ���� �  � ���� �   �    ����    �  � �  � �  � �   � ��� ���������������������������������         * FPHPVRI.lvlib:PhInt TIME64.ctl            �  *Px��Z�o�ߕ��b�J�lh�R*���Nb5hiQv�ȲB�M��u��Cr��.��p��(� )�S�
�)=h��Ћia�]�C$)��?�%H��Vߛ�ݝ�h�4Z4LS��>�����Q�K��C��׺����,u�!cGU����"~��T2��+�#GԮ2����t�z����ؙJ�*o)������g>���g� �tW�����؏����G�o�rS�e�Vo=��"�����~��[�Z9>2�=���t;�OG�#��hW�Z�y���~8��?1�����,`�S�_��X�9DSL�'�f���-@�����3�4�9z(�2~�W�;���+; ���4�PVe����t���gwϦ��>3>Qzf��������q5����_�:\[F_0����g��*|_�*#�΋�
��rI���b��P�_��/F+oe�����A�W*�+#7'�_�^X<=�}���z�%�SA�I�M������(�#�1eD)+�&w���{� �1i
H��Ft�i�����Fl>T$2�2
�|^���T�\k�!3����ʡ�è��#{�WZ�]4,+�.��g��c����ԧ�Gr�g.UWʵ���t���P�6�绁�_kJ��?K��T]^#�������33SmkMJ�Mm$y2���l�����9T���t>�����7;��t>!+|J� ��r�f;���%�J-�H+5���>�jc��ڦB�&�tw�33C�V�j�B-m�6��W��:m�(A�\[��N���i3�[���M�IڎAo�����7/���]�٤.���m,8���'��M�g^�0qK +�jql6fR˘��.�7/Xx����:�^��� ������/�!�Z�<�����wdL��h���ݷp��SK��}'�i"�y�a�>����<�o�"��}!�8-z0�ً��u\���,��`n��<�D�b���6� ��5���B�ຮ��ơ��ʇ;a�ˇ�����z~�M4�Ժf�|��$at ���/DRy^��3Fedu�25r(�s�����Y��Y�4��	�6���
�f�n��G���
Y���|g�ˎ�cǂ�	XiӶ�n��eu�{q�#���b�:hꠦ�jTu�vl��u)X�%�0OB
K�� �0E!�ŝ~���߬���K2�NԔJxmeէ/Y�W�NǢ��8��X�ݥ% �f{�v�0��$���������̇�U"-p0_oa����QRɌ��0Iٲh���L�Vuؗ�����K�tqv���îxљ=L��Bu�#q��=pYpPظkS���W�[p �u	��tSp�S���\��C�O"�O�Dgs��ΣBup6j���F�@��)���-"6%�<�b��3���n�ƈt�\'h�b�0Q�~Κ~�vz�pX/���7�1�x���`�)������O��<�
;�����X	�.}%��u ���\�vz�w��Rc�����&�{ �vRA�9Ӹ�DjJ]���>��vMj�ff���|Mo�2����ˆh�������]���9�Rj�����Y���A(�ٖ	qR�,���V��Gaѕh΅g!���=�mff��*�&�����V�C�]l4����-��f�DX�j��sG\��s�>M�`��X@yδ@)�.���� ��	p{,F��%��2d�N���)�[���������\�I��ąF�
:^�Xq��y$��t�ϓ+үp^O�1*V�R�"۳��6����xR��"�:��:ⁱH�p�fI-���g��t'������H����<5{r�����4��gK'�6����R��,&+H;��}��ll�=�
�Ly�5f�tZ�v�N, +�<�Z�ʓֆ�'O�?C�(�6O�J\1��]�y���إb{m��8șv��+/�Ϫs-�=A
d�\+R&�	-���P���R$���CV�X#�u>j��~���v����
��K@*���.B��F9���B��ӄLL�,�`�v�sQ�Mt\�n���LR�t(���v�(M]�%�� I�c)̀Br�Oډ�Ӡ��v�|hVL��k*O��Y��� 6x��N�q��C4�����-�S")�d����M؈e�h-�C�x86ŀ���X�t�"�����Q.�3ki�(���^
�.�Y�l�@Ky�N(����3�dW]���-��%3�d����h6��i X�e���[+����EA i6��ϱP{�1�{N�Ȱ\MS��R�T,�RM�Y�2����,�1�a��HW6�8�M(�Ll(12��~��0�6$7J܊4�rqh�,p�!f��X�,�;̥��ve aU�N��D���;ej�2��Z$L����b"��]-�H���Hc���9�
�Q� c����.��eBl��s[���[�j`(���1I#<'�X�r�X�	�5���3l9جh��	�O�qAʘo�`��44�>�	C�*���v��5�:����TX�n�OБ��%�m��@��fQr��w C��ǡP9vQ�P���9�YLM<��:�n��sg/�s�"�������8̍=�B�*��Td�Tĝ�g�<$��`M��@����Ѥ��t��	s�!�����B��X[./���s�˴"u{8w�6�Ń��0���V�n�9�����L�����v�u�<`6�?�e#�K�^�������{[��6�E%�X�	�)�B���A�G�t�{B�3ay���!5�m��M=ۋ"��!��t4��A�������c|9�_��(|�v{�>G��K���cyi�>-ZBV�����t�"��M�5�V;�(�V��c�#�ZY-�+�e<;�G��#OThX��s>Ē3��0.�F�9������8/����ަ�BDh��0����g`z����	�nP����ֆ��&D\�\*��X8l�\m卸�����&��޶Lc��nb���[=c�֯�6'��e"���<R�Һ�6�[l,i�WH�|��F8x�'^����0ݫ��
3|8��}�ٷs�bl&��)4���Z�>�=����4;̱ΣNG4ֻtE$h��)�-�� Y�u�=8	��Ӎ��di q�]�X �0:�>Xj�+�X�L	GO�F#B"@gJ��S�'��F��:�>���FcgJ��^
H\i����4+;�^�6����Pnp�ŉ�k#�^Q���1��u��м47�|m�}�F����HVW}9�62��ѵ���oo^M)�}�<�|̮�1�p��3���B^bB�����{U�Ap��wyU�q�q�?�*1vFFOfw��͐G�o(S�S�N���N���+�)|r��Ǖ��(�Y|2Z��'���`{���쌞��1�%�q$U�7n '��VPo����ć`	aK��gfB�IOM ��K�y�X
�ɥ��6��q�iCT��(���]���kSOh�`W�Ve�ș��7�7?�-�(h��'� m�7ô�E �/K\�>#}/J���/�*�,g{.�|N(�;^�Q'�K<��K<j.�ē�Q���ԛCSD�:�752�OKXW�	��X��]b}�;��A{�����
�ů�g�h/�+�go���;�}$���e�&�>�s��L�f+{-�,��׻�����f�(5UM-fޅz��R����U�����ͥ����&��ze�#�u)������ ��~         7   * BDHPVRI.lvlib:PhInt TIME64.ctl             e   ux�c``(�`��P���Z�+�!���FЏ�7���a �( 	���h/��>��� �l���9�2-���W)b��z�\�8Se�<� ��G                  NI.LV.ALL.VILastSavedTarget �      0����      Dflt       NI.LV.ALL.goodSyntaxTargets �      0����  @ ����          Dflt       NI_IconEditor �     @0����data string     513008047    Load & Unload.lvclass       	  ddPTH0                 Layer.lvclass         �          � (  �                 ��� ��   ������  ������  ������  ����ff  ����33  ����    ������  ������  ���̙�  ����ff  ����33  ����    ������  ������  ������  ����ff  ����33  ����    ��ff��  ��ff��  ��ff��  ��ffff  ��ff33  ��ff    ��33��  ��33��  ��33��  ��33ff  ��3333  ��33    ��  ��  ��  ��  ��  ��  ��  ff  ��  33  ��      ������  ������  ������  ����ff  ����33  ����    ������  ������  ���̙�  ����ff  ����33  ����    �̙���  �̙���  �̙���  �̙�ff  �̙�33  �̙�    ��ff��  ��ff��  ��ff��  ��ffff  ��ff33  ��ff    ��33��  ��33��  ��33��  ��33ff  ��3333  ��33    ��  ��  ��  ��  ��  ��  ��  ff  ��  33  ��      ������  ������  ������  ����ff  ����33  ����    ������  ������  ���̙�  ����ff  ����33  ����    ������  ������  ������  ����ff  ����33  ����    ��ff��  ��ff��  ��ff��  ��ffff  ��ff33  ��ff    ��33��  ��33��  ��33��  ��33ff  ��3333  ��33    ��  ��  ��  ��  ��  ��  ��  ff  ��  33  ��      ff����  ff����  ff����  ff��ff  ff��33  ff��    ff����  ff����  ff�̙�  ff��ff  ff��33  ff��    ff����  ff����  ff����  ff��ff  ff��33  ff��    ffff��  ffff��  ffff��  ffffff  ffff33  ffff    ff33��  ff33��  ff33��  ff33ff  ff3333  ff33    ff  ��  ff  ��  ff  ��  ff  ff  ff  33  ff      33����  33����  33����  33��ff  33��33  33��    33����  33����  33�̙�  33��ff  33��33  33��    33����  33����  33����  33��ff  33��33  33��    33ff��  33ff��  33ff��  33ffff  33ff33  33ff    3333��  3333��  3333��  3333ff  333333  3333    33  ��  33  ��  33  ��  33  ff  33  33  33        ����    ����    ����    ��ff    ��33    ��      ����    ����    �̙�    ��ff    ��33    ��      ����    ����    ����    ��ff    ��33    ��      ff��    ff��    ff��    ffff    ff33    ff      33��    33��    33��    33ff    3333    33        ��      ��      ��      ff      33  ��      ��      ��      ��      ��      ww      UU      DD      ""              ��      ��      ��      ��      ��      ww      UU      DD      ""              ��      ��      ��      ��      ��      ww      UU      DD      ""        ������  ������  ������  ������  ������  wwwwww  UUUUUU  DDDDDD  """"""          �������������������������������������������������������������������������������������������������+++��+��+��++��+��+�+++�+���+���+��+�+��+��++��++�+��+��++�++���+++��++++�+��+�+�++��+��+�+�+���+����+��+�++++�+��+��+��+���+���+����+��+�+��+�+��+��+��+���+����������������������������������������������������������������������������������������������������������������������������������                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                ������������������������������������������������                                                                                   
NI_Libraryd     Layer.lvclass         �          � (  �                 ���                                                                                                              ���   ���   ���         ���   ������   ���         ���         ���   ���������            ���   ���   ���   ���   ���   ���      ���   ������   ������   ���   ���      ���                     ���         ���         ���            ������   ������   ���   ���                        ���������   ���   ���   ���   ���   ���      ������   ������   ���   ���   ���   ���            ���������   ���   ���   ���   ���   ������   ������   ������         ���   ���������         ������������������������������������������������������������������������������������������      ������������         ���         ���         ���   ���         ���         ���������������      ������������   ���������   ���������   ���   ���   ���   ���������   ���������������������      ������������         ���      ������      ������   ���      ������         ���������������      ������������������   ���   ���������   ���   ���   ���   ���������������   ���������������      ������������         ���         ���   ���   ���   ���         ���         ���������������      ��������������������������������������������������������������ݪ��������������������������      ��������������������������������������������ݪ��������������������������������������������      ��̪��������������������������������������������www�����̙��www���������������������������      ��������̪�����������������������������������wwwwwwffffffDDDwww���������������������������      ��������������ݪ�����������������������������wwwfffffffffffffff���fffDDDffffffDDDDDDDDD���      ��������������������̪�����������������������wwwffffffffffffwwwffffff333fffffffffDDDDDD���      ��������������������������̙�����������������wwwfffDDDffffffwwwfffffffffwwwwwwfffDDDDDD���      �����������������������������ݪ��������������wwwffffffffffff���fffffffff���fffDDDDDDDDD���      ���      ���������      ���������      ������   wwwwww   fff   wwwfffwwwwwwffffffDDDDDD���      ���      ������   ������   ���   ������   ���   ������   ���   wwwfffffffffDDDDDDDDDfff���         ������   ���   ������������   ������   ���   ������   ���   ������fffDDDDDDDDDDDD������                  ���   ������   ���   ���   ������   ������   ���   ���������DDDDDD������������         ������   ������      ���������   ���   ������      ������   ���������������������������      ������������������������������������������������������������������������������������������               ���������      ������         ���������      ������   ���������   ������                  ������   ������      ������   ������   ������      ������      ���      ���   ���������               ������   ������   ���         ������   ������   ���   ���   ���   ������      ���         ������������            ���   ������   ���            ���   ���������   ������������            ������������   ������   ���   ������   ���   ������   ���   ���������   ���         ���                                                                                                   ��������������������������������������������������������������������������������������������������������������������������������   VI Icond                  ���               Small Fonts 	              k   (         .        ���C              �                   ��	     LUU�@ �	�                                                   
�#>
�#>�@'>�@'>     L   ?           �  cx�e��J�@��dk����j����$o�(� �"�դ���������m|��&e`ٙ��g�`�D��%k�UY3�MV�y���W�u�(���k�zO�f��>�.�YS0KV�Z���Gr0���,E&��R�-��S��N�T�X������̭�8i�M��رcF�.��]=+�ǝ按��p���`�8T�'�]�3�2�{(o�QhO��~�L�L�����7%�    w       X      � �   a      � �   j      � �   s� � �   � �   u� � �  � �Segoe UISegoe UISegoe UI00 RSRC
 LVCCLBVW  V�  y      V�               4  h   LIBN      xLVSR      �RTSG      �OBSG      �CCST      �LIvi      �CONP      �TM80      DFDS      LIds      ,VICD      @vers     TGCPR      �STRG      �ICON      �icl4      �icl8      CPC2      LIfp      0FPHb      DFPSE      XLIbd      lBDHb      �BDSE      �VITS      �DTHP      �MUID      �HIST      �PRT       �VCTP      FTAB           ����                                   ����       �        ����       �        ����       �        ����       �        ����      (        ����      0        ����      \        ����      �        ����      �       ����      l       ����      �       ����      �       	����      �       
����      �        ����      �        ����      �        ����      #@        ����      #�        ����      %�        ����      )�        ����      )�        ����      *        ����      8�        ����      8�        ����      9(        ����      9�        ����      9�        ����      T�        ����      T�        ����      T�        ����      T�        ����      U`       �����      VT    PhInt TIME64.ctl