RSRC
 LVCCLBVW  W�  w      Wl      	VRI.lvlib     � �  0           < � @�      ����            �����I���f�   
       H8�a� �D����8�91��ُ ��	���B~                                             /���P]'2�t����          N LVCCVRI.lvlib:PhInt RECT.ctl       VILB    PTH0       	VRI.lvlib               %   &x�c�d`j`�� Č?@4��D3p@e �b
�      I  $x�c`��� H120�D i4q0cS ���\�Bř �e��2�X��LP59 �@7��� ��&      ( VIDSVRI.lvlib:PhInt RECT.ctl          �  Lx�S`b`(�03� �����SR��|P�r`bPڣ������#
��L] B��g�&�E��q�:� ��f4��jx���`�G4{���X f��y����� ��������8s�$w�t6�`a`���� ��-���o� *���g��D�g�#�	Q���h���M9B9B9P96�<�<�<@�< ��N�`���� r([��GRxxt��(x|��c,8�M�</xt��w��u~�`<�P� ��`b��
O�0���.F� �������\�1�c�O�c�	F��;2�ҍ���l| Np� A4-iAu�bsF�K@ZH�f�����(i�m�L07�l�]�������DgW|�
H� �:��     �  13.0.1       �   13.0    �  13.0.1       �   13.0    �  13.0.1                        ^  ZPhCon.dll

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
     ���������������h���-��-M���m���m������������������  �  � D� �� ��� ��� ��� �������R������T�aɊd�  �dOɒf��\�M���C�R�]����   �����������������UUUUUUUUUUUUUU_�UUUUUUUUUUUUUU_��U�\U�U�\\�\U\_�U��\U�U�\U�\��_��U��\U���U�\\\_�UU�\\���\U�\U\_�UU�\\U��\U�\U\_�UUUUUUUUUUUUUU_�UUUUUUUUUUUUUU_�UUUUUUUUUUUUUU_��������������������  �  �   ��������� �   ������������   ��������������� �������������  �������������   �������������    ������������� � ������������ � ��������� ��  ��������� � ���� �� ���  � �              �� �� �  ��� �� ���� �� �� � ��  �� ���   ��  � �� �����������������   �������������������������������������������������������������������������������������������������+++��+��+��++��+��+�+++�+���+���+��+�+��+��++��++�+��+��++�++���+++��++++�+��+�+�++��+��+�+�+���+����+��+�++++�+��+��+��+���+���+����+��+�+��+�+��+��+��+���+���������������������������������������������������������������������������������������������������������������������������������������+�      ���     ��        ������VV�������+��    VV+       ��+�����VVVVVVVVVV�V+V�VV       ��  +����VVVVVVVV������V�VV�VV� ��    ���VVVVVVVV������V������� ��      +�VVVVVVV��������������+��       �+VVVVVV�����������������         ��VVVV�����V���V����+�� ��   ��   ��VV����������������� ��  �  � �  �+�V��+��������� ���  � �    �  � �+ � � ������+ ������ �  � � �  �  � �  +�� �  ���  �  ��   � �  ��  �    +    ��                              �����   ��  ���   ��  �   �  ������  �  ��  �  �  ��  �� �� �   �����  �  � ���  �  � � � �  �� ���    ���� �  � ���� �   �    ����    �  � �  � �  � �   � ��� ���������������������������������         ( FPHPVRI.lvlib:PhInt RECT.ctl          w  /�x��Z]l���8a���E$RR߸�N��u����n�8�v
��0�sww`vf3?�	*��D�T���*T�'T�i�H<���_��
�O<T��PDD�qϹ����;ި�X�f=s��=�;?��*��?�b7�g������m*1}CU��L\?G�*����զ�'~!�a�z���@�8�^T�%V��c�'?�����Y���P߸o໩�d�7�R/��(��/�7b��?���f�@e-����������i]K���L� c��T�(l��6�� �O�el]�D�
�L+׮]���,l��L��F������4njs��$ȹ�)��)�D����FH�n%0�'���`��]�jM���<?�X�`�]������������'�J�֯b���f���p��I5� ��J���҇�\P������O�B��PO3_�^L*�3wv�)�#p����"wHr�+�TZ��%)w6����$���>�R~&��V^�u0|F�q �/��}�9��C���P��vJ?�n�1e��R��XE+&/?6��P���[��jӶ��M3�ȗ/��kx�m�9���ԣ�K���/����s#���ڠ:��s��G<�*�O<� �s�8�H��GݫM�gl�Xת��F�Z.Hre��P�Z�ѳӨƼ�ѩ�{Fx��Yiخ�ЩY�S������4�viٶtwD"/̷p ��<I��Z:Չ�jiu�B�*�t����ՠX/PS[��Z��T�N�%��ci&��.��1,�`a�*#gê����픚[d�v�d�!p�cT���𽼍i۷��V�eâ�5�P
�%��C5�ؖ	3���H^���,\x�H�O/n��� ��{��i��&�M���3�LF:�}ϖ116��8�c�Y�DM��T@�	1 ����J�)$d�v&Ĝ�Ӳ'D�W �Iw�>u��YkmGg"CK,,���5�8b�,�1ܝكŵ%�0��г�.i��8,r�-��F��0Ѝ���i�q�b�h`�%�4��+�I�h���⹙�	"�<%�A��2�:�C��9��9CX���X����4��	�:���
�f�n�
�G���Y���<�����}ۄ�	X�Ӻ����eu�{q�#���b��hj���jTu�v��
u(X�%� Of
K��r�0E&���~z���ݬ���J2i8vԔJ��܂Gnki^��B�i�X`q�tg�K5r �r�ewa�I(U�Wg���'/M�E"�5p0�\â�#�����1�A:Β�i����c0�Z�`_66k�kZ.�#�^؁.vvŋ��$0��
�y�D���ʾÂ����z��p4�� `[�b�.c
�yJ�<��4�h��I���a�k�l�QX�<
���F��癧�_��)���-"6%�<�b��3���f�ƈt��ۯ�zbZ1 Q�~N^�6ڻpX/���7�1���ٵ��d��Ҋo�Ƨbj.H��݊MXVe,�x�^���`퉧�1������g;T�!bD�$�	���ժ ��iTPB5��zZ���k^j������<�\�eB㥗���w��A3�ZU�|;�9�Pj�����Y���A(���qR�L�*��\y�¢��9��p��x����UMT Uxu�5߃x;_��V�����k+Qa�����Qm�2O�4�մm�i�9$�8�g0F����&�5�T'�L�o���?~BJ�pn��[v���'r�b�AM\�G���e��'�K?�N���؜�+��	��9��D���,*�FE���/i�a���E]��ȡ6-��x`̒0ܤ���a�P�em{�^�=�q&a"�4��7Л'Ə��?�^�a��x���
~��#\
V��֊E ��2�x�C�4�f�6}4�(�3�P��uݯ�, +�=�Z�ʓV��g�,=p�<�˭L�r\1�*;�-rQ)hQ�K��Z'C�p�3,͗ן�]�U����ɐ��|��<1h	lކJ��ݐ"qUm�bP�*�U�S���E�]n��]��������~K����,��p��[j+��8�Ĥ�fh'<�DáK��$�O���
h����EX"�h ��0��( �����>
ya�·f�Db������uiN�b�J�$�GY<@st�J�W9%��Kf+A=܄�X�6�B:��m�@X8�U[ϒ�<:.�r8��抒��`���Ռj��7l�ؾ�<spKp-���aKڑ#��!-�6t���F* p��k#�V�-`�rQH���s,ԞpL�>4,W��<��e�Y�/ׂ��8{��G[�\�^X� ��GFE���ơoX@�e"�`@��a������!i8ab�V�ᔋC�bɀ�1#t��g��a�f�+� 	��%�-Cg �l�)S��٩E���� &RM��"�4)	�4V���#GXa�\0��8��J\&t�&�۲��XVCi�k��4�s2��U�g�U��@^�,�=������i`�`��TW� ����F/IC#��Q� �Ѫ�0X�,��\��=q�
+�M@�	:�TzVs��/P~�Y�\�o��Тz�q(T�\�$P�nc��@SW$��V6����S碹q��B�~��8ȍm�B�
�s�Td�Tĝ�g�<$�uZaM���2CA�I+i��+�>IC���N?-���l�,h۠��L+R�ۀs'lC'�_<���U^��<*ر0v[�>hG�, B��o@�(U��1@ِ�����[<������{[��2��%��)�B���A�G�D�{B�3a�RicCj�ۀC9�ڶF" C���h0ك�i�m�}h��rL��Q�('��V<���4�m�3�H����B��D��K���ڎ��ꭍ"n<:�롕բ0a�BXF�� @�{,{mq$��
+]x·Xr�c��ƙ�01��ȁ��q��(/�������BDh��01����m`���w�	�nP����沶�*D\�\*��H8l����Q+����M�s�m��e���uW�Ƅm��[n6J�i��Dfy$�u9m��o��p�i\"i����u���1���+�#�ZA�0��: ��N�J��D��� ߧdд��\m�zx�dlv�#�0�:��H��%���c���Ђ hd��-��$p2O7.Ǔ���Ntub�4,��`�%��b3%=1�+�� ]�)��_>n���mu�}f7G�`�FtD�7����-�G*���#����g��(/+�(��p�Ɖ��#�^Qj��;�@�|h^��n~䩎�#H�v���D��>��S���Hu��x$�����mv�_
�w���S($��1!h�;�;#v�;#w�&wugd}h_��<��懏�JC���?��LH�D�U�V�*�`����a���y�Q��S�R��?��gs�vS�\��Lm��S8	�)���;���s`v��+{�� ��~XBؒ#��^*Ǉ�}��W^y��g����H��=���umJ�צԢ͝M�-l<�ڼ�;������6����L��(�\�qq����=+}�D�?��$���xm�y =ǔ������}��;��'���J��uW�<���ut(  (�BY(k��m�|�.�����:�H������VH~�B�[_��p�H~���v@�zX߈I3����H&�B�>�ٍ����z�v��:$Ø���!�O)0V�������E��0,�tp�2�~ۑ7�{w�Hv��6�c[���֪I+�I[�bО��О���>�%�=w�h��7A��nhN
���������N�3 ���:Y����deǋ��p���Յ���Og
����������o��c�c���S�T�I�b0~�:o�       K   ( BDHPVRI.lvlib:PhInt RECT.ctl           e   ux�c``(�`��P���Z�+�!���FЏ�7���a �( 	���h/��>��� �l���9�2-���W)b��z�\�8Se�<� ��G                  NI.LV.ALL.VILastSavedTarget �      0����      Dflt       NI.LV.ALL.goodSyntaxTargets �      0����  @ ����          Dflt       NI_IconEditor �     @0����data string     513008047    Load & Unload.lvclass       	  ddPTH0                 Layer.lvclass         �          � (  �                 ��� ��   ������  ������  ������  ����ff  ����33  ����    ������  ������  ���̙�  ����ff  ����33  ����    ������  ������  ������  ����ff  ����33  ����    ��ff��  ��ff��  ��ff��  ��ffff  ��ff33  ��ff    ��33��  ��33��  ��33��  ��33ff  ��3333  ��33    ��  ��  ��  ��  ��  ��  ��  ff  ��  33  ��      ������  ������  ������  ����ff  ����33  ����    ������  ������  ���̙�  ����ff  ����33  ����    �̙���  �̙���  �̙���  �̙�ff  �̙�33  �̙�    ��ff��  ��ff��  ��ff��  ��ffff  ��ff33  ��ff    ��33��  ��33��  ��33��  ��33ff  ��3333  ��33    ��  ��  ��  ��  ��  ��  ��  ff  ��  33  ��      ������  ������  ������  ����ff  ����33  ����    ������  ������  ���̙�  ����ff  ����33  ����    ������  ������  ������  ����ff  ����33  ����    ��ff��  ��ff��  ��ff��  ��ffff  ��ff33  ��ff    ��33��  ��33��  ��33��  ��33ff  ��3333  ��33    ��  ��  ��  ��  ��  ��  ��  ff  ��  33  ��      ff����  ff����  ff����  ff��ff  ff��33  ff��    ff����  ff����  ff�̙�  ff��ff  ff��33  ff��    ff����  ff����  ff����  ff��ff  ff��33  ff��    ffff��  ffff��  ffff��  ffffff  ffff33  ffff    ff33��  ff33��  ff33��  ff33ff  ff3333  ff33    ff  ��  ff  ��  ff  ��  ff  ff  ff  33  ff      33����  33����  33����  33��ff  33��33  33��    33����  33����  33�̙�  33��ff  33��33  33��    33����  33����  33����  33��ff  33��33  33��    33ff��  33ff��  33ff��  33ffff  33ff33  33ff    3333��  3333��  3333��  3333ff  333333  3333    33  ��  33  ��  33  ��  33  ff  33  33  33        ����    ����    ����    ��ff    ��33    ��      ����    ����    �̙�    ��ff    ��33    ��      ����    ����    ����    ��ff    ��33    ��      ff��    ff��    ff��    ffff    ff33    ff      33��    33��    33��    33ff    3333    33        ��      ��      ��      ff      33  ��      ��      ��      ��      ��      ww      UU      DD      ""              ��      ��      ��      ��      ��      ww      UU      DD      ""              ��      ��      ��      ��      ��      ww      UU      DD      ""        ������  ������  ������  ������  ������  wwwwww  UUUUUU  DDDDDD  """"""          �������������������������������������������������������������������������������������������������+++��+��+��++��+��+�+++�+���+���+��+�+��+��++��++�+��+��++�++���+++��++++�+��+�+�++��+��+�+�+���+����+��+�++++�+��+��+��+���+���+����+��+�+��+�+��+��+��+���+����������������������������������������������������������������������������������������������������������������������������������                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                ������������������������������������������������                                                                                   
NI_Libraryd     Layer.lvclass         �          � (  �                 ���                                                                                                              ���   ���   ���         ���   ������   ���         ���         ���   ���������            ���   ���   ���   ���   ���   ���      ���   ������   ������   ���   ���      ���                     ���         ���         ���            ������   ������   ���   ���                        ���������   ���   ���   ���   ���   ���      ������   ������   ���   ���   ���   ���            ���������   ���   ���   ���   ���   ������   ������   ������         ���   ���������         ������������������������������������������������������������������������������������������      ������������         ���         ���         ���   ���         ���         ���������������      ������������   ���������   ���������   ���   ���   ���   ���������   ���������������������      ������������         ���      ������      ������   ���      ������         ���������������      ������������������   ���   ���������   ���   ���   ���   ���������������   ���������������      ������������         ���         ���   ���   ���   ���         ���         ���������������      ��������������������������������������������������������������ݪ��������������������������      ��������������������������������������������ݪ��������������������������������������������      ��̪��������������������������������������������www�����̙��www���������������������������      ��������̪�����������������������������������wwwwwwffffffDDDwww���������������������������      ��������������ݪ�����������������������������wwwfffffffffffffff���fffDDDffffffDDDDDDDDD���      ��������������������̪�����������������������wwwffffffffffffwwwffffff333fffffffffDDDDDD���      ��������������������������̙�����������������wwwfffDDDffffffwwwfffffffffwwwwwwfffDDDDDD���      �����������������������������ݪ��������������wwwffffffffffff���fffffffff���fffDDDDDDDDD���      ���      ���������      ���������      ������   wwwwww   fff   wwwfffwwwwwwffffffDDDDDD���      ���      ������   ������   ���   ������   ���   ������   ���   wwwfffffffffDDDDDDDDDfff���         ������   ���   ������������   ������   ���   ������   ���   ������fffDDDDDDDDDDDD������                  ���   ������   ���   ���   ������   ������   ���   ���������DDDDDD������������         ������   ������      ���������   ���   ������      ������   ���������������������������      ������������������������������������������������������������������������������������������               ���������      ������         ���������      ������   ���������   ������                  ������   ������      ������   ������   ������      ������      ���      ���   ���������               ������   ������   ���         ������   ������   ���   ���   ���   ������      ���         ������������            ���   ������   ���            ���   ���������   ������������            ������������   ������   ���   ������   ���   ������   ���   ���������   ���         ���                                                                                                   ��������������������������������������������������������������������������������������������������������������������������������   VI Icond                  ���               Small Fonts 	              k   (         .        ���C              �                   ��	     LUU�@ �	�                                                   
�#>
�#>�@'>�@'>     L   ?           �  xx�m��J�P�����Z[c�5�>A�	�Eiw!�kiӴ����K�Ϸ�'prS�B90�93g~��^��umAU�<;-|�m����hi�5�p��gv����\L��f��œ��7����6dyA ->*heQ���D�S�����y���I��Li;amjR�V��q�^���s��}��VȤ>Y�ˣ6x�� kn�aBʩ�%d�k�{�U�3�������Ľ�J��kN8g,ʘɴ���g� q�'
    w       X      � �   a      � �   j      � �   s� � �   � �   u� � �  � �Segoe UISegoe UISegoe UI00 RSRC
 LVCCLBVW  W�  w      Wl               4  h   LIBN      xLVSR      �RTSG      �OBSG      �CCST      �LIvi      �CONP      �TM80      DFDS      LIds      ,VICD      @vers     TGCPR      �STRG      �ICON      �icl4      �icl8      CPC2      LIfp      0FPHb      DFPSE      XLIbd      lBDHb      �BDSE      �VITS      �DTHP      �MUID      �HIST      �PRT       �VCTP      FTAB           ����                                   ����       �        ����       �        ����       �        ����       �        ����      $        ����      ,        ����      X        ����      �        ����      �       ����      x       ����      �       ����      �       	����      �       
����      �        ����      �        ����      �        ����      #L        ����      #�        ����      %�        ����      )�        ����      )�        ����      *        ����      9�        ����      9�        ����      9�        ����      :(        ����      :0        ����      U4        ����      U<        ����      UD        ����      Up        ����      U�       �����      V�    PhInt RECT.ctl