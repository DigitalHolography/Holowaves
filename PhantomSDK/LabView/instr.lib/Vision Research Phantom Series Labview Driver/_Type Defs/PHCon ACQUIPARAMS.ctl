RSRC
 LVCCLBVW  x\  ~      x<      	VRI.lvlib     � �  0           < � @�      ����            �{q�,IqL��&nI�0�   
       ��4�z'�B��q���U��ُ ��	���B~       �6�%��G�D�m ���   �.-4N�;��W�+��u   1Y�	Γ�Nl.�H���         � LVCCVRI.lvlib:PHCon ACQUIPARAMS.ctl      VILB      PTH0       	VRI.lvlib    VICC     PhCon SyncImaging.ctlPTH0      PhCon SyncImaging.ctl                               VICC      Rect.ctl PTH0      Rect.ctl                               VICC   PHCon Time64.ctl PTH0      PHCon Time64.ctl                               VICC   PhInt CFA.ctlPTH0      PhInt CFA.ctl                                           ,   .x�cb`k`�� ČL8� ��p`  �+�   J  $x�c`��� H120�� �,h�`Ʀ6@6��셊33@��
ro@ř�jv@�X���9�Pz� a�)     . VIDSVRI.lvlib:PHCon ACQUIPARAMS.ctl           -  �x��oheǟ˲6�l��d+�A�L�h�q˭a�մ}ƂfX�Ȑ�t��u�f��$��5�m�ι���o�Hg�t�+2���dH�Ɯ��M|��w�{�.�C��s�<����=~w�@�վQ�j��H�Bi���^\��9r~#�����V���C�%�-�&����Å�do���:zff>!Ŕ���L�����Reh����.ځ*3���x�ح�H�!9�IВ4Ɠ�����|�r����~��Yq2�{�'�+ǔ.VU�Y9�$X9��IiJ��9�+`w��d����]e5������&S�^$����N���a5/6t�'8����l�>�7�������=���{���s¢�I��4��,t���z��O%����(���҅���n ?�Kr���c�^.��VP ��S�9�1Wb�N
��m��.�kw�Os���gou�xk̙��[�5��E��t��~��Mb���g�J��)�=S�ɾv嚼�C!Ӵ�i%�J@�2�G[���q�.��1$�柳3rY��%K����6E���b���H�ri����#�j����٩F�#���&A~��Ũy��N�*��%9G/ �,��R�:[�,��c��U�-�;�p���=�����{9���^U�
�p��ܧ�>�p/���wp����#�8���T�A�_<��A�zP����8<��!U	�Z�W\QuE�����0��<��a�
�&or�&Uo�!�#�+BgR�99E�fV��#���@���VvxTգ� �1�9xL�c��2��9<��qU�xp������{5$*��hH�Mjj�)-2)��*��S8{U��@�w;���[���z�P��ЃV��*ZheǀcU��
�$��3VIUO
����)O9xJ�S�9��������)�o �Uų�������k�ΖSnX[9�Hp�\�[C7;�>��դ�����v�Gq����2t��g'�-c�tC4�$Y�Ѝc,�n��6��	ڴ�"��8	�0�*9%��V��[zڋ|E~�gR���H�_��w��߰�J7�������:l�n�'���Y�r��'W7��od�hwZ ����\Ѳ��o�B6!�>SG}��Z'�&w�\��}�&�o�1�=�v^⻇�]t|�k�.����.�˖�2�.��˜��|��-]���M��^�|�.�z�%�w/�vx�sB��/����/�?��6�5�^J/�2���?��B&�`+��X� �р(�8�j�m���QD�Y��]�������ӣ��a���B~[�:0�8AaW�ѺA+�|zo:4T�C��~^WhU�1hU�������&���=ڃ���Ѷ��`��=,���OY]����Pz��vV��[����Wz���<oy��噶-��.��x	��6�������7�%b�ڬ�pe��̋te�x�xW���q�/��������)�[fWV��+��_�w�@.��lOHb0E]l�b��ڳҢ��Dk����8k#�E,k����/r+k�8u'�"�E�����u�����u�I;r�ls�Ŋ��n�"�]>2.�wZ��'��9�8y ;[d�yr�8}����/\��~��G6lv���|g��Mތ�ϠxGԅ�l$VD�+R�YϮaiZx!s>>ҍf�;������S�oU6~�R�v�ޮ!�e�猾���jZ��3WYE�C\d��/�.9���>�D���HBG�����a)��z(O����O�3I����B=r��M�+���>��?���x*�v�v��4���3�      �  13.0.1       �   13.0    �  13.0.1       �   13.0    �  13.0.1                        ^  ZPhCon.dll

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
     ���������������h���-��-M���m���m������������������  �  � D� �� ��� ��� ��� �������R������T�aɊd�  �dOɒf��\�M���C�R�]����   �����������������UUUUUUUUUUUUUU_�UUUUUUUUUUUUUU_��U�\U�U�\\�\U\_�U��\U�U�\U�\��_��U��\U���U�\\\_�UU�\\���\U�\U\_�UU�\\U��\U�\U\_�UUUUUUUUUUUUUU_�UUUUUUUUUUUUUU_�UUUUUUUUUUUUUU_��������������������  �  �   ��������� �   ������������   ��������������� �������������  �������������   �������������    ������������� � ������������ � ��������� ��  ��������� � ���� �� ���  � �              �� �� �  ��� �� ���� �� �� � ��  �� ���   ��  � �� �����������������   �������������������������������������������������������������������������������������������������+++��+��+��++��+��+�+++�+���+���+��+�+��+��++��++�+��+��++�++���+++��++++�+��+�+�++��+��+�+�+���+����+��+�++++�+��+��+��+���+���+����+��+�+��+�+��+��+��+���+���������������������������������������������������������������������������������������������������������������������������������������+�      ���     ��        ������VV�������+��    VV+       ��+�����VVVVVVVVVV�V+V�VV       ��  +����VVVVVVVV������V�VV�VV� ��    ���VVVVVVVV������V������� ��      +�VVVVVVV��������������+��       �+VVVVVV�����������������         ��VVVV�����V���V����+�� ��   ��   ��VV����������������� ��  �  � �  �+�V��+��������� ���  � �    �  � �+ � � ������+ ������ �  � � �  �  � �  +�� �  ���  �  ��   � �  ��  �    +    ��                              �����   ��  ���   ��  �   �  ������  �  ��  �  �  ��  �� �� �   �����  �  � ���  �  � � � �  �� ���    ���� �  � ���� �   �    ����    �  � �  � �  � �   � ��� ���������������������������������        � FPHPVRI.lvlib:PHCon ACQUIPARAMS.ctl      TDCC     PHCon Time64.ctl PTH0      PHCon Time64.ctl                                     CPTH0         TDCC   Rect.ctl PTH0      Rect.ctl                                     jPTH0         TDCC   PhInt CFA.ctlPTH0      PhInt CFA.ctl                                    �PTH0         TDCC      PhCon SyncImaging.ctlPTH0      PhCon SyncImaging.ctl                                    �PTH0              $.  �)x��]t\�y�{wW^�m,�Ķ�d�H���`A@�� �e!�؆�s�{w��ݻb�]=�&�)m8�9y��Фm��@HJ҄�4$8�$ʃ@�<Hk҆��M� �z���}?��בw��s��v�������?3��E��M�)tG1����b��B'��H���8j8��/bV�e
(>��"{�YW`� >�)���RM�.o�1$�kX�E
�M��5�W��lh{|]�=!��F���^�{�����ǲP!:ց����)�D[��c�c�$k���w�ג"�̑���\���D��ˤ�@O`�V�DPdz�'�Lo�ί�L��C��8�g�<<��Nv�<��i�D�O�ˎ3ٳNF� +�պf\�+�\��5_����N���8����k�}1�9�\�W0G��?.�/p$��q�ɱ��}�0�'
(�
�
oBG�6I�"�����`������Ӏ��8��`p,��D�'Z�^{`xl`|`���v*�Cm��n+�$:_�����d
2?g��~Ϣ�z��F�0d]�vR�w.B��a���FbA�>D�Ї�Q��(���$�͆��/в�&,퉵����R�Y�'�NG"�[�,*bV����!'s��vF"�ܔ����1�S������#�;0<����J��3�����I���A��&ٜ�*AL������,�8��F	�;._�f��r>'�[�Ҿ��yH���!�RVbY).w��G�-%@��8�!�*��\|N�3b*���Wο�^�\	�3Q!��y���K�NI	+'�i<�I�qD�01'�pɢ��2ٸ�%��~��r��h{NL&�Ȅ77c0���~k�1Q8Y�U�@ 7	`��8����0QH�;M�n��_-B��HVM�]P�.�C�9H\A����9%��_�)�IC����5c����o8m@	G�i!���|� Σc �,��:1%�~��|Z8��Р�q\�)j��#�3-,�{��}#����J�'�,�0��2�Sp��D��;���y1�O�rN�'y�
J�O��F�Kk	]����J��#�de8���S�|Z��N�N&�VP�
g����C;�q&���m �#��R�u2TH��6��� ��A�����ӐԨ���v�SS�Q�����5b��C���S��i�H�VR�hV�.��	X��ln�so(�	:��n�ߨ��|f$�bI�X�~-��������Q��d�ևjOTR���AWt�}Q�_%��~u��J�1(���e �����&aJ�R�D~j*-���0�2N��!�^P�b�PxI椬KAz�T��3����w�دe6Cd&�;?�¤O5W�@`JzU���q7�N[�(WRb
0����ve��v�)�����@�lZEIg�(h�ygXj�����r��$(\#Ǜ] ��Y�_f�	�S�h��Ĕ-/��)�3�N~��C`��b04�Q��<�B<��I.�����"b��2�Ǧ�:B0�8���pcTs��r�|2UQ�	e�g��D�)���p+�l�푝ֵ��tsyYH����I�yj����bUI�	�9ᖼ c�VT&����[r�ձS�9!^�ƨ��YL�� �%��PgE����i��̕�(��\��^��)|,Ei���KiCu���U �>��
�:Ĺ2'�柏fsBZP)<���`J=��Ӽ*�(��(D�,ι*�nP�~Ƿv'��7�΂\~4���T^}ۗHX�)��}��g#B\Uq��;n�u�pq:Ԣ�iȹGLC=�@.~�
F�a�~��	���X$�S���F�*ݰe�ɜ0��Ք0*ȱ�8�����.!�AL�0n�/i?��N��\�v�,���p��'��#�c��
h�j�VІ�?���l^6YQ�]��Y
Zʎx�����fZ3���g��L�����鶐�uO��e�O��ܾy�,��uLo�$���-�f����Ik�2de, ���(X<^�n��M�q7u��%Q�΀k��g,	�m��z�3��tq�;wq�����룂�R,G�".*�R�{�Za"'Jy�}�yY!�<����us��=7��Ep	��51��#UÕ�*`5K�]J])(F�2�'�8�Y� ��dU�o���8V_��M�)6�"Xbn�l�s��H�&�r´c��ɤ?S]Y��e �
}�E�	]�@&ǀiZҲSB�����ي=w�h��b�Q�P�*���9�s	Fa��V\C�17�FI�6E��Rf
3AFo����:ڐ̡�xd%A�zX[؁^��n_�s�@롅�xY�dm�?�E�|Z���d
�478�UE��C-�I���vI6B�Z�q��>��x��2�% ,0d2�F�W*/�f2�
���tK�QLP��^�X*���澾�����>�:6���"�rڗ]V+���1�a��.�\IO�/JX���1:+��d�c}�EBm��h�t�@{Q�W�(�$b(�0fTY1��e:`9A�4C�p�,?)(3��<�*6n)��Ȭń	����b��qM�*o2��e3Sy��<Ē�1Y�k^8@��	^p�s����1��t����i�Q�Lte.�'�%�N��a+�na�Q^�k��mL���RR���>iZ4��@A��0�U�c0qIY��V!��2&�xRj���'�HL��Kjc���%Ӎ���|Dq��l�>$�x�,�q�ꪉ��)>&*z{v�5֍{�a���e�X��6C�N���{q! "�RU�L~�C�� N���QC5o�+�ʧeU0��wq����ã�G�Ei����9�j��)�wB3✱��A�a#/������5��f�`.��
�߀8���9���7x��}d��lGm3�L@%�V�B3��"9ޕ�3��e ����VS��0	�:���Dmd���60�M���H�*E�t����S�����ɱ���B�r4ooV���[\�5�.˲<��i��Su		Q11�u�2o@�d6'*���Q�M�Q�Ѓ+�jBZ�ai�k
�cL��
YehH)��t�l���@��ݛu�l��j��[�6�j>u3dw��$DUMU;�ش�.�m�t�EP��˚0�Չ<v3����?'sI�8W[jZ��C�����m�r2�u��M��c�m���˴�ĝ�-ژ���k�b�T3���q�Y7��ӗ4��񲾻���.�O0������i�Z�T�t��T��q��s⍪��5�NS�vȔ�R���d�Y��$�9�yL
�#����F�@�����*����M�p�2572�S���;իS�$�ǄN�bZ�UӐ���'V�DBG"@�)�7��o��jQ#-8j��$����H�!M�&y�J�?&��__'��@��"���(~��7�乓<�H�w��q��%C>��O�a�<���8�~�����(��~�<+H	D�P��z���71�pK�K�����ί����"��q���dD�0/ ���E�!ϝ���i,�r����ڢ^��s��d=��O�ਗ�)cob�����c�#>_�v�JF��i���������.Ka ���t�S#]"q����K��`|>X���d�ֲ�@��%Zc�������o����kAw�cm����cJ��#I��e��Pt�~G�I���G�n��סeP�SO=%���Z�∛ w��k$�H��lhUG*n��;�~����&�o6��i���4 �����,_�I�4KuK��kw��\A�i��W�4?��@���iB�
\�}�:�����������wLu���H����e%#���H�K1��w6g����_Ҙ�g[�wj[�H;��q�:X�`$�y�e��zͶ|�۝ �LQ\A��rL�)~J��V��c������\�d���7�ݳMb�$��T=`��� gՃ% Hj�Pz�:򘯙��1��s��S
y�@�2�G��BH�u*�Y+��>�q�J/i�Z	&v��1a2��C�t��$�sT�H1LE�>�vr4T�,:�]�P=����Q~�h3�l0p��1��V���t�����V�:��S^C��>�<���Z=�5�c��5��}�w��؉��\�>�'s��h��6�xMP�� �5�6w��Ř�a/bԢ�`>�=^W&�-�4�E�A�����c!���Fn�E^����.��*<���Jc�1lMί
�1/:y������#���c`�|4P����cu`36qhSKqS+
Ol��Y�ն�E��+��>��r��q�Z�>���A$#�����d�ß�x���}��l! �]e�'������
��Q3~){){=ڈ:�h��k�@�$���R��'i�O}l�:a@�Ƌ8)<K'=�RMP?	m<���jm�����N�m\}��s�)
M�Ĺg��/�����p�æA�m܂.5[n�6����$-��WuJ��_y)+/��¿�-<djṐݭ����fH�&L�RE�~ʬ��T���l��Mx t4�*vA/f�L�y�����Q�jٹw���_ctKi4��.(�eA�^Knh��ZrC�o�tC��uqC�f74XpuC{J���S���`чB���!Ưb}�����Zo��uM�e��к�b��}k�լ�KF�!'�Jz�P���!-��u\-9�u-��ֵ�y��n�O�����)��vJ����yKd�1;YD�P��>�Q]��櫭���rJ㭃{J�?U`O��������m>Lx�vn+��r��=�2O|�"�sY"��"�z3�s��B�C��N����ÁХ������=vP?���5�0o�g�I��"����g�������t�1���/ս}Հ7�-���cR�M�,ܡCG�8�M
��Lgd#�'ǁ�GF���B���J\�*�9�u�ö���Z��\�7�LN��_�Ôz��z2��A%�IK����ƍ�[���`g�=#�c��65To�|���5Ф�D�N������-#ݎ�>c	����m����L~�,X)9���O���7�x�}��s3����CC8IP���b&��f�ަ�#t�I��jxiv�K	�`c`z�8x�k7���Q\묬�݆x[,�MfcZ����Z��&�Ѷ�n��ռ�F�f`d䪡����C����M���T�;�6�Rm�%�{�!����<��������3/K��r��[Q�f��������=.�{Ha����{u�;�����v"e�<���k�z:�z��c����k�������a=��ޫ�u�.�û|;O�ѷN}����������O��c�D+��%���{����c/��rN����y����%9��6wO�O��Js���ؾk�� �����}����^m �#�k�Z ����� ~:��] ���#�]t�y��\y�-�O; ���gJ�/���/��	���zh`��ze�M4�vX�%��s=��2�C��ư4���tNr6����|�4�BM�ٻBh�-\���z�����}`l5�]U|�A[�f�MO��/[}G�W_��@}��]}g��F_}�uQ�s\����{�3Pߵv�}�S}/-W}��Ͼ쿝�����,W_��g����,��ֻ��
�}Ze��g��jW�/��o���2g�K��Ͼ�W������I}�����v�٤�_u�/n��G}��Tߕ�ݭ�>՗-��o�I}�GMs������ѯ�{�����8w���ק��J��u]��!���2/���Mɫ�MI��GԎn�mJ>����QrQ�}V-ty�}?��LKI��
(3YF�A��=[����uA�^_����[��8| ��E���yKU6E��̛�4��-���*l����V� \��fۊ�ݿ�W�x� ����W�����ug[	zs��g�{X�i/Ui���id�ȌYc���Z//�k���8���E7r�{��g}���G��s��s�^�X!��\�sf)����Bc��y��D��j\���|����Dx�k�R��`��T
|�̟T
|��U��R�`���]�iVY�i4 ��+0� �w3#V�s�@.�x��@v��}rQP�~��P��}-��}�̣���O�����ծ(F�0��`���z��}O��ԑ��t�m�7Z$3�%$3Eg��d��3�d�1�Hf>���\���H^	H��-H��D�Me"y���C�#7/
�#�Z�r$SKP�Hgʑ�O(G�\���ݵxX�2�2����Z<�	�rwb��u�N����[<^K0f?YK0f?U��o��O����ݷX�����'�묾��	�kʝ��4;]����j	��ݵd�*��׵x��׺ y��dԍq�`��/�[�P̸���/��_�/�y��l|~��2��1o��/��A���k��_��Z:����ϱ���.���7���ﱿ��?��������_��~��^�>�s�/��co1�>�����~Ǝ��n[�c��k��_�Z:���������_�]�k��c�Ԩ��6 9�Fr�bO�;X&�-Q�t���\�;�h�ۙj��k�嘴O�c$�[o�c��,Ǽ�4�X���K��r�}�ܠ_�����˽sA�>r�X.��Ec���k�傏��;�,��O�>��rͧ�r�q��X`�����{f��2�֮�uN�އ)��+C�i]!����%z�\K��Ko���qfzM����-��-��sw�������-y���v����ق�����7�#�Fõ�Do�C�Do��U�P�~/|ą�Z����t�[�,�L�V��c�c�2Y�C��֙������̙\���a�9]S�w梷,
�u�Dxh}-���2��Bx̈́�6�%<���P��C�*'<t�_�C>/+C�.��f^������̭Z�r{nh���.�%�ū�b)�]�L��]���z��#0Aw2/�����}�s���oa��)�W|{Qv�랫�����Rf��Ux��>w�������$���,��� �Gl0F=�0>D�^n ��*$�Q���@�v��Q������6T�h�����'�i�/��V�eKK�/�b�����Ot,��X&A����D/Y�|��I����r��Ȝ�ޅ�ç]�z"����2�ԉ�u���:�����e�V�v]�@�z�&ڭ]�9+J���9�mv1��~�-u�;O��ޖ��:��u�Wv/�To��pa�x��a����2���˽�h��^֫J8�$J��v�r.gE{�/ge����!�z��P��n��S���z�W*�����^W���^͊n@�%����y5+:��Ѩ�լ���h�ڧ���Ha�x`��zK#y��7.���~K#i�徇�~�\cy��r� z���M:n�;�R���5O�qc�A�'��]��:�yc�Ac����56���u�o�7�]T�`�Q0ƕ�c0(��V��,��XC��c���u�:n�;��Qڳ.smjt3��=�<�^�(�[��߫Gs�۫�}�+��R�<����v��a���xǤx) 8�Z�N��a��D�'/�v�q���e?�M�����}�����s���<U8��
�2A�.p��
�RWGt���Q�M�Q,߅�D_�zSioo�ܻt���m�=4o[o�_�p��D�Vǩٯ�
��<q��Ӈ�PI���y�]r8e�{��Ӝ�4�7^J���ߧ��k�7;�M��R+ܾɣ�?�\�=<�����?�gĸ�2�L	���Hg����n�-�}��O�{��Z�kw8`��,�����@�\��N�v?�zL�,������<�ճ�v���ߘ�y;`]8`)�v�>^�E�/����`��k�tE�-�f��	O��R�"�]Ep�����uZ'��i]WS�u�
�u��R�[�v��g�����v(_�	�2�:�-��Ë��k
�ט��U�#U@�^�H~��{Br������H��ɫ˚S��v������k
�W��� ��~A|���q��o��o�A��/�	�9�uq ��� ��� ��
 ������n .5ޢݢ�3c��A ;"��!�<���n�=�	��˽=E�OL	.���.J<z����>VS�v�¾ݣ~�����'�%�Z��t���=�S�d�t��:`����?P!�G�i!������)����F���*��s~���'����O�U�����U*���;�A�
|�S�9 lV"�S�^�RM���k����
��_�T��j*��ӐO��5��y]� `6�o@3���"��r��7 &��p�O�Rұ�2���6�76 0F/T�ҧK]6 h0��2��� �v4�\�Bs�<tOW������H�n�Н�&�e�j�нk�����#ã���GF�_C��_+�_#��ٿox|�Jc��ҩ��jTa�s����A��*�=�@V��mh��M�7����m��Mwɀz�Y�=��ƅ]�()BN��]���$���nƑQx�H����7��y�Nu��������-=����Z��d�R���z��|9	���CX?�)��aM�l/V��~䗰�ٓ�^Ҵ�����(	}1�Lc�8GL���ۏ5@/��@��
�o�
��ܻ"��������~�8�rMi�OkJ~V�w����M�_M�5R2A�F�~�;�_���E��?������%�3Q!��9���Ł���������*���~���'����~5�\О͐�`�-�a�>I� m�@O��x)�Ƅ����]K�Ե��@�gиUK��SKʹ���n����s��-��jJSNՔ��p�*�{�*�)LPӔK`\�	G���$>#Ƹ/%�N}����9r���n����uC��1����A��<�	/Υ����L���YZ�X�W1�{*F���C�`�Rw�7b쟃E��Π���?��n���ʜ.7uą���!�I����a��3��SN��fuM��y5�k��M��&�e���S�i�!RP�գ��a�^7�@��M~�'�(��g<�DnQN�2-5�֚���*����e��vO�wh0oPgbF�d|������`����+�������f��A�L��6�5���yop��׵���m%p~y�'}&ڢŅ4A�w����O7�Z��ᡆ�SS`��6eЉ"Y���'F�ſ-��o��{�Y��������F�8�          . BDHPVRI.lvlib:PHCon ACQUIPARAMS.ctl            e   ux�c``(�`��P���Z�+�!���FЏ�7���a �( 	���h/��>��� �l���9�2-���W)b��z�\�8Se�<� ��G                  NI.LV.ALL.VILastSavedTarget �      0����      Dflt       NI.LV.ALL.goodSyntaxTargets �      0����  @ ����          Dflt       NI_IconEditor �     @0����data string     513008047    Load & Unload.lvclass       	  ddPTH0                 Layer.lvclass         �          � (  �                 ��� ��   ������  ������  ������  ����ff  ����33  ����    ������  ������  ���̙�  ����ff  ����33  ����    ������  ������  ������  ����ff  ����33  ����    ��ff��  ��ff��  ��ff��  ��ffff  ��ff33  ��ff    ��33��  ��33��  ��33��  ��33ff  ��3333  ��33    ��  ��  ��  ��  ��  ��  ��  ff  ��  33  ��      ������  ������  ������  ����ff  ����33  ����    ������  ������  ���̙�  ����ff  ����33  ����    �̙���  �̙���  �̙���  �̙�ff  �̙�33  �̙�    ��ff��  ��ff��  ��ff��  ��ffff  ��ff33  ��ff    ��33��  ��33��  ��33��  ��33ff  ��3333  ��33    ��  ��  ��  ��  ��  ��  ��  ff  ��  33  ��      ������  ������  ������  ����ff  ����33  ����    ������  ������  ���̙�  ����ff  ����33  ����    ������  ������  ������  ����ff  ����33  ����    ��ff��  ��ff��  ��ff��  ��ffff  ��ff33  ��ff    ��33��  ��33��  ��33��  ��33ff  ��3333  ��33    ��  ��  ��  ��  ��  ��  ��  ff  ��  33  ��      ff����  ff����  ff����  ff��ff  ff��33  ff��    ff����  ff����  ff�̙�  ff��ff  ff��33  ff��    ff����  ff����  ff����  ff��ff  ff��33  ff��    ffff��  ffff��  ffff��  ffffff  ffff33  ffff    ff33��  ff33��  ff33��  ff33ff  ff3333  ff33    ff  ��  ff  ��  ff  ��  ff  ff  ff  33  ff      33����  33����  33����  33��ff  33��33  33��    33����  33����  33�̙�  33��ff  33��33  33��    33����  33����  33����  33��ff  33��33  33��    33ff��  33ff��  33ff��  33ffff  33ff33  33ff    3333��  3333��  3333��  3333ff  333333  3333    33  ��  33  ��  33  ��  33  ff  33  33  33        ����    ����    ����    ��ff    ��33    ��      ����    ����    �̙�    ��ff    ��33    ��      ����    ����    ����    ��ff    ��33    ��      ff��    ff��    ff��    ffff    ff33    ff      33��    33��    33��    33ff    3333    33        ��      ��      ��      ff      33  ��      ��      ��      ��      ��      ww      UU      DD      ""              ��      ��      ��      ��      ��      ww      UU      DD      ""              ��      ��      ��      ��      ��      ww      UU      DD      ""        ������  ������  ������  ������  ������  wwwwww  UUUUUU  DDDDDD  """"""          �������������������������������������������������������������������������������������������������+++��+��+��++��+��+�+++�+���+���+��+�+��+��++��++�+��+��++�++���+++��++++�+��+�+�++��+��+�+�+���+����+��+�++++�+��+��+��+���+���+����+��+�+��+�+��+��+��+���+����������������������������������������������������������������������������������������������������������������������������������                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                ������������������������������������������������                                                                                   
NI_Libraryd     Layer.lvclass         �          � (  �                 ���                                                                                                              ���   ���   ���         ���   ������   ���         ���         ���   ���������            ���   ���   ���   ���   ���   ���      ���   ������   ������   ���   ���      ���                     ���         ���         ���            ������   ������   ���   ���                        ���������   ���   ���   ���   ���   ���      ������   ������   ���   ���   ���   ���            ���������   ���   ���   ���   ���   ������   ������   ������         ���   ���������         ������������������������������������������������������������������������������������������      ������������         ���         ���         ���   ���         ���         ���������������      ������������   ���������   ���������   ���   ���   ���   ���������   ���������������������      ������������         ���      ������      ������   ���      ������         ���������������      ������������������   ���   ���������   ���   ���   ���   ���������������   ���������������      ������������         ���         ���   ���   ���   ���         ���         ���������������      ��������������������������������������������������������������ݪ��������������������������      ��������������������������������������������ݪ��������������������������������������������      ��̪��������������������������������������������www�����̙��www���������������������������      ��������̪�����������������������������������wwwwwwffffffDDDwww���������������������������      ��������������ݪ�����������������������������wwwfffffffffffffff���fffDDDffffffDDDDDDDDD���      ��������������������̪�����������������������wwwffffffffffffwwwffffff333fffffffffDDDDDD���      ��������������������������̙�����������������wwwfffDDDffffffwwwfffffffffwwwwwwfffDDDDDD���      �����������������������������ݪ��������������wwwffffffffffff���fffffffff���fffDDDDDDDDD���      ���      ���������      ���������      ������   wwwwww   fff   wwwfffwwwwwwffffffDDDDDD���      ���      ������   ������   ���   ������   ���   ������   ���   wwwfffffffffDDDDDDDDDfff���         ������   ���   ������������   ������   ���   ������   ���   ������fffDDDDDDDDDDDD������                  ���   ������   ���   ���   ������   ������   ���   ���������DDDDDD������������         ������   ������      ���������   ���   ������      ������   ���������������������������      ������������������������������������������������������������������������������������������               ���������      ������         ���������      ������   ���������   ������                  ������   ������      ������   ������   ������      ������      ���      ���   ���������               ������   ������   ���         ������   ������   ���   ���   ���   ������      ���         ������������            ���   ������   ���            ���   ���������   ������������            ������������   ������   ���   ������   ���   ������   ���   ���������   ���         ���                                                                                                   ��������������������������������������������������������������������������������������������������������������������������������   VI Icond                  ���               Small Fonts 	        ?      
p   (         /        ���C              �                   ��	     LUU�@ �	�                                                   
�#>
�#>�@'>�@'>     L   ?          '  	x��U�RG=BBW$�K�$߱�����l,��B�EI[֭V+������'��T>!/y��I��H,.L���ؙ�9sNw� �G�������������_��_�K�t�/��ִN�it��5����w�|\L�Ԋ��^T�,{dϦŬ��~V��t-��>�ב�#D���n���w�͖<�~��<!��j�త���p���f`Z�!�0�5��u�o�j�n}����9�fJ�\_��䶀] �	x���F @(�tNŔ��U
/�zl���q�aOI{L0"�)��t�a2�W���4�<�p��u�8�$��
"D��B�ֱ��e���(P+4]�[g}�ժ����j��4$<;(��~o04�i(���	�a��[{q�"�ҽ!!��dJZ�30���^��yS��X<��erٙɐ�*Q|YϬs�'W�`l��P�4�Mfr��a�zx��r�9���-<������+;�4jT
\��	�D�4����hɵ�>Z�y�F���3�ft��FevR��a}ʬ�OW;���չhNiț�ue�)��Jf�D��Z3�Ns�flLi-�6��Hi>�z����0�D3lP3�>'x���C^��G�U���M�8�6�#O\��J����w8���?>-"qj���VRuu�,�wD�K`Q�b�0�,��%|�>���XA�q�pwp����x�i��!6�r�b��C��{�4q�)�Ԟ~�c�h�.\X��s��r�ܯ�����%r��P�x��&��;wO�l�5�6J��	��S��ޠH�@ۯ�����˯�,x@��yH���.n<2*�)�j+��b��֯���0w8��@A�^���d����'�/�<5�4�@-�gn�M���1

=�x����3��D�rX�>��[i���l_`9�<�.Z��ͧ] �Pu�U����p�������c�1��w�C�IuE�䴶p@�
�*� �J�5 LI� �|@rUv��������"�iW����Dx�#��&.:5F�Z�11X���S�(�Q���    �       h      � �   q      � �   z      � �   �� � �   � �   �� � �  � �   � � �  � �Segoe UISegoe UISegoe UI000   RSRC
 LVCCLBVW  x\  ~      x<               4  h   LIBN      xLVSR      �RTSG      �OBSG      �CCST      �LIvi      �CONP      �TM80      DFDS      LIds      ,VICD      @vers     TGCPR      �STRG      �ICON      �icl4      �icl8      CPC2      LIfp      0FPHb      DFPSE      XLIbd      lBDHb      �BDSE      �VITS      �DTHP      �MUID      �HIST      �PRT       �VCTP      FTAB           ����                                   ����       �        ����       �        ����       �        ����       �        ����      �        ����      �        ����      �        ����              ����      P       ����      
�       ����      
�       ����      
�       	����      
�       
����      
�        ����      
�        ����      
�        ����      *X        ����      *�        ����      ,�        ����      0�        ����      0�        ����      2�        ����      W        ����      W        ����      WH        ����      W�        ����      W�        ����      r�        ����      r�        ����      r�        ����      r�        ����      s�       �����      w�    PHCon ACQUIPARAMS.ctl