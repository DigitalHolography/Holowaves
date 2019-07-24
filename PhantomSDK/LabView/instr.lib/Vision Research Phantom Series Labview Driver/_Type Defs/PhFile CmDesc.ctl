RSRC
 LVCCLBVW  Zh  z      ZH      	VRI.lvlib     � �  0           < � @�      ����            ½iKt�x@�w�q����   
       �-C�N��g<	{���ُ ��	���B~                                             p����cP������          R LVCCVRI.lvlib:PhFile CmDesc.ctl      VILB      PTH0       	VRI.lvlib               #   x�c�``j`�� Č@� He    J  $x�c`��� H120�D i4q0cS ���\�Bř �e�	�Pq&���{����w � �&�     * VIDSVRI.lvlib:PhFile CmDesc.ctl           *  �x��T�kA�M����(��K�SM��b�np�/0`A��V��%`��]6]��z���R+�1�is��b/�/�����7��Mڃ�7���7�����˄<��v�%r�̐�GN\��X��m���v8�YWI��2��H����3l�o�Ե,�s��F2�z�MY�T� yM���F���?��Iە��H�n2��m��b���,�V}ケ��������Yn_���n�����c�M�3 u]3�2JGe6�� ݔ��}�\j]c��-l]͡7e�J�qO�
�P�0ر2�F�
8�~G����K�J���Z���yr�P�4���N��ŊTG�St���S�z��P��X�a�C>rLDlI✱��S�L<_�4Ҵ��	�,01XN�ʛ-�z�m�qf����,~0]~�2X�h!�#���`�ȣ�j�o�G6]D��i5�pFZ��|�9Y�%��:�����#�D���:x+๖G�pi"ᒰ��S���	^�)0?*�z:8E��N
��/��p���F����̊2:���A1���Ԩ���: �}��t�޺��]�Kҋ�F_�ht�����7ƪ��ٕ�����r^K�%ު4Ya]�尪�Y�R|	��n�g��26�x`|(R�����L?/�.H�}�����,;���ڟ�I���h�����DJ���
[5,+���ɽ��w��[�l�%�-����:/N?��*>%��M���v�]��;hϢe�&� g\+�AzB��W�k�,7�2��q���~����Vh�     �  13.0.1       �   13.0    �  13.0.1       �   13.0    �  13.0.1                        ^  ZPhCon.dll

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
     ���������������h���-��-M���m���m������������������  �  � D� �� ��� ��� ��� �������R������T�aɊd�  �dOɒf��\�M���C�R�]����   �����������������UUUUUUUUUUUUUU_�UUUUUUUUUUUUUU_��U�\U�U�\\�\U\_�U��\U�U�\U�\��_��U��\U���U�\\\_�UU�\\���\U�\U\_�UU�\\U��\U�\U\_�UUUUUUUUUUUUUU_�UUUUUUUUUUUUUU_�UUUUUUUUUUUUUU_��������������������  �  �   ��������� �   ������������   ��������������� �������������  �������������   �������������    ������������� � ������������ � ��������� ��  ��������� � ���� �� ���  � �              �� �� �  ��� �� ���� �� �� � ��  �� ���   ��  � �� �����������������   �������������������������������������������������������������������������������������������������+++��+��+��++��+��+�+++�+���+���+��+�+��+��++��++�+��+��++�++���+++��++++�+��+�+�++��+��+�+�+���+����+��+�++++�+��+��+��+���+���+����+��+�+��+�+��+��+��+���+���������������������������������������������������������������������������������������������������������������������������������������+�      ���     ��        ������VV�������+��    VV+       ��+�����VVVVVVVVVV�V+V�VV       ��  +����VVVVVVVV������V�VV�VV� ��    ���VVVVVVVV������V������� ��      +�VVVVVVV��������������+��       �+VVVVVV�����������������         ��VVVV�����V���V����+�� ��   ��   ��VV����������������� ��  �  � �  �+�V��+��������� ���  � �    �  � �+ � � ������+ ������ �  � � �  �  � �  +�� �  ���  �  ��   � �  ��  �    +    ��                              �����   ��  ���   ��  �   �  ������  �  ��  �  �  ��  �� �� �   �����  �  � ���  �  � � � �  �� ���    ���� �  � ���� �   �    ����    �  � �  � �  � �   � ��� ���������������������������������         * FPHPVRI.lvlib:PhFile CmDesc.ctl           �  2Sx��[�o$Օ�m�=�� ����cg�v��0Vv������i{� ����E�����Ǭ��!"RVZEB�J���}D
yA��P$���Dʇ��X-�,!�qι�Vխv���"�%<��{>����sO_���?�s�|�ER��õ�1vS��Lf��}��o��DR5�j��̍�oz�j��f�fJ���ru���w������ 0˵R_7v�|���/��P����� y8��ԝ���>�|��d{L��T�|:�=���l��O���A�2�J�*����� A�q����
��,	�#o��vL�� �j<4��n�����W؛�49Nr�PNy��Pw$j']+���6C�TBY���w���Rza�Jf0�{�ש{����"��������W{��[XB_p�3���˩�
|^i����"I�@F���ϸ/���|���}�-��'�3J�;�����rzg��Qf�.|�z�RK��#��ȩ�n�q4
r����Ⱥjr����`��f��la/��H�r;2����G�`��������j���g��8����=�\�w�aY�ܜ�r`z�o:6]�\��|�ztln�+7��*sϬ��r�V��J=�t��ZMy������K�t��i��Y��LM-6����`��<���Y������UT���l6���Q��6���l6!+|J� ���l�v<�;��+��J���+t�m��6�A�-[k�:�kL��gj�W�E&Kۺ�����N��uFQ-��,�ƺPǴ9��-[GΦ]��`wSjy��ڛUy�����Y�1t���6���g�bu�f�3o3

��%+�iul6f2�W���7+Yx����:_^��Awa�ѿA}�.V��>�d��\�;jLLMi���=��[g���VA��b ����43f��:���0V��K����b�S_�~����kp��%V!,��64��r�l��>5��مŵuʹ�5�g�zMt�aU��*xk"�	��0�&�aw�t=�A5�Ժf�b�U�I��.8�p�?V�Y�4C�g�=��������Ѕ@�椚J��GX�@� �5����;i<� ��T07�vcV�>�0jj���i� �w������X �+�p�-�y��N/�vb��	ءv�XM��U�=���Ze.kqPqr2���D7,�SLF�8��®�����$Ӧ�TAM��W�W|����y%h6-M���c=\�šڙ�1�(A�h�Gm��hOR��Fm�}�¥��!��"up0_�c���Q�dJfw�E:gY�h���X��@��`_6k��Z�ǋݰ]v%�΅K��*T�#5���p��'���6��p5�� `[����6���Ǫ�6Z(~
�A��%:��(�te��k�QK�<f:4-�HE/��z�"bS�]�#�F����cq#�ί�NP�wŴjBD���b�e�l��a���� "�xѵ��L��c���O��<�
;;�M8�rT	x��0��+������4��|�eF#;%UM8�@|�IAfWL���t��Z�)ʹ+J�65�O<�kz]�	M�^Q6d���ͰFh5�6�=��S.cv؟/9n�-
����nB��i�f�K� Wѣ��J4�R�+����7SS5�h^�]�J=�!߮W���TsЖm3ު�����F!��\��C��w,��jZ �ι.�2�A�uc��X���K��%@��/*pʃέ�BX�f�텙ғ|1����t�|���"��h��)�~qY���f�2TJ2B�=�
�Q�0��u�5��SP��p�ꈠ��E��23��n����x��t6DO7�%�L�_�t��͋�7�?:�>3�����M��.�)XA��BH; ��i6�͞ch�	�kD�tZ�F�H, +�=�Z�˓ր�g��?~�>Q*m^*��b����-�P)hQ�K��ڠ��p�3� �7g�x>�Ε��0���s�"�s�2�%pD�T�vCJ�9>�bXŪ���)P�)���=a��]��Љ���~�����"��h��[j+��& 1]� ��F碰�h�l�����i21Y��1P("��HKD�4��2
�E?!i�;O�"��ع��Y1��Ǯ14�:�g�S<����5t��c�9>�ǥƯKL����Y�JЈ6ac,�Fhe���,;`U�1��zχ�Ǆ���y�$�G?x)Yp��fu�V-�;�(��@a�0\u���0�K"��h����lQ�5Z�`�y�6�_��6 �<!
I��b���S��V�i���T*�E�������1 ��'�(���a���l���7mL��2�A0���0��C����4��Y4��es0��1#u��gy�a.��f�+60P�ט����s2�q�\-X��S��2221	5W�$��0�;�f "GZ�.jyĘ�!��P2�����-�m�Ɩ�J�<'yLҨ�d�+[N��A9\Cs�fY�50m8H}��+X����	F_S�FZ�g"h�F�J�`�{�6s�����TX��4��#��k�[}��#�"p��w C�둈C�r��%�z1N���x욚n���W����E������ۀB�ʋ� P��R�wJ�!pH��ʛ/ �:OCI�)ߕ4˓�Is_�����sK�E\�,�]m��VWi%t{M8w�6�A�d��[��d���K�>h��, S��o@���㚠l������W���7�"��;r�`8������6�7�8��U�3@�5`Q4H���h�[�P�\؄R���Z�6�PMmۋ2"S���X8����Ŷ!�h��r�_S�(b�v{�����K��O$��<T�q��l	y��jbG�K�� V����d��[�����zhe�8M��0,��q� �=�~[���d���<C,��o@���0'_�@rbv��㒄��ڛ6~��)��Bh�-C����!(��0ݠ<�c���mˣ5ȸ�X���X8l�je�;q+�Q:&��<'�E�2��˺�	�n��	�*[�0�l�c�$���<:��
��-7�4͛t��R�;��u"�
��?�
+�x��f�*����l��J̙7e��اb�1O���
���ɿl����a�wk��z�nJ�V���h������Z��'���x"�,�@��dW'�!LÂ.�-q��k�)�艩]�F���3����#�{�#=xa$���������ȷ_
H\��寍�ʻ���q�G^=�
H]��F`=�$�!4&м�^h^=���K�� m۵���V�ѵ�t*]yr�?vne����!�K~ȯ��p�
��?MN�&[�����`�["Y���1n���;�نɼ�7ۼ��"m��N�����z���r?k�d������E6v�Y���S%Α�����|�	�~=�ϓo��v�d'���b�*�n�Gʻ���^/�JS��>��8���;�	~	[���ҝ!��`	�K�����t�Zf�\��o�R��\�����pmJх��N��~|m�6�y��P����{�0�G_�)��nLđ˽���Ĭ� ��-�=��N/���]��)Aƀ�K^#$��1b��A�{D�Q�gÔ$7cZ�m��|V���*�#��D)��)?����ݶ7ۻ���2N�S��6�Tm^6O�����A�����|�j.L�Sa�O� f���@��=aw�O-P�c\�L~2yp:��}�~� ���\���@6?z���Lyw�C��&���\r��K����ЦW����'צ��M�$���"�@�˅����ߍ�� h�_��	^�w�M�@.��8�yJ�\T>OƟ?�yA��ŽD��������͕{D4���G1,��{�3���������o��<�X$��<~|�����Y)����]�$?m�{�?���=PrV��{����,m�Y���/��,|��?i��|h�K�Y*~�?K�/����'�_�Z�ҭ��������	�_����NZ��zNX��z;�Sq��?wh���S+~�C'/~Gds?�,�����?����GOX���_d��������.r�%Q2�y/P�d��؂���J+u�<���"2�,f�?�#{�����Q�År���2�=v�e��?��q������¿e��tC�i      W   * BDHPVRI.lvlib:PhFile CmDesc.ctl            e   ux�c``(�`��P���Z�+�!���FЏ�7���a �( 	���h/��>��� �l���9�2-���W)b��z�\�8Se�<� ��G                  NI.LV.ALL.VILastSavedTarget �      0����      Dflt       NI.LV.ALL.goodSyntaxTargets �      0����  @ ����          Dflt       NI_IconEditor �     @0����data string     513008047    Load & Unload.lvclass       	  ddPTH0                 Layer.lvclass         �          � (  �                 ��� ��   ������  ������  ������  ����ff  ����33  ����    ������  ������  ���̙�  ����ff  ����33  ����    ������  ������  ������  ����ff  ����33  ����    ��ff��  ��ff��  ��ff��  ��ffff  ��ff33  ��ff    ��33��  ��33��  ��33��  ��33ff  ��3333  ��33    ��  ��  ��  ��  ��  ��  ��  ff  ��  33  ��      ������  ������  ������  ����ff  ����33  ����    ������  ������  ���̙�  ����ff  ����33  ����    �̙���  �̙���  �̙���  �̙�ff  �̙�33  �̙�    ��ff��  ��ff��  ��ff��  ��ffff  ��ff33  ��ff    ��33��  ��33��  ��33��  ��33ff  ��3333  ��33    ��  ��  ��  ��  ��  ��  ��  ff  ��  33  ��      ������  ������  ������  ����ff  ����33  ����    ������  ������  ���̙�  ����ff  ����33  ����    ������  ������  ������  ����ff  ����33  ����    ��ff��  ��ff��  ��ff��  ��ffff  ��ff33  ��ff    ��33��  ��33��  ��33��  ��33ff  ��3333  ��33    ��  ��  ��  ��  ��  ��  ��  ff  ��  33  ��      ff����  ff����  ff����  ff��ff  ff��33  ff��    ff����  ff����  ff�̙�  ff��ff  ff��33  ff��    ff����  ff����  ff����  ff��ff  ff��33  ff��    ffff��  ffff��  ffff��  ffffff  ffff33  ffff    ff33��  ff33��  ff33��  ff33ff  ff3333  ff33    ff  ��  ff  ��  ff  ��  ff  ff  ff  33  ff      33����  33����  33����  33��ff  33��33  33��    33����  33����  33�̙�  33��ff  33��33  33��    33����  33����  33����  33��ff  33��33  33��    33ff��  33ff��  33ff��  33ffff  33ff33  33ff    3333��  3333��  3333��  3333ff  333333  3333    33  ��  33  ��  33  ��  33  ff  33  33  33        ����    ����    ����    ��ff    ��33    ��      ����    ����    �̙�    ��ff    ��33    ��      ����    ����    ����    ��ff    ��33    ��      ff��    ff��    ff��    ffff    ff33    ff      33��    33��    33��    33ff    3333    33        ��      ��      ��      ff      33  ��      ��      ��      ��      ��      ww      UU      DD      ""              ��      ��      ��      ��      ��      ww      UU      DD      ""              ��      ��      ��      ��      ��      ww      UU      DD      ""        ������  ������  ������  ������  ������  wwwwww  UUUUUU  DDDDDD  """"""          �������������������������������������������������������������������������������������������������+++��+��+��++��+��+�+++�+���+���+��+�+��+��++��++�+��+��++�++���+++��++++�+��+�+�++��+��+�+�+���+����+��+�++++�+��+��+��+���+���+����+��+�+��+�+��+��+��+���+����������������������������������������������������������������������������������������������������������������������������������                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                ������������������������������������������������                                                                                   
NI_Libraryd     Layer.lvclass         �          � (  �                 ���                                                                                                              ���   ���   ���         ���   ������   ���         ���         ���   ���������            ���   ���   ���   ���   ���   ���      ���   ������   ������   ���   ���      ���                     ���         ���         ���            ������   ������   ���   ���                        ���������   ���   ���   ���   ���   ���      ������   ������   ���   ���   ���   ���            ���������   ���   ���   ���   ���   ������   ������   ������         ���   ���������         ������������������������������������������������������������������������������������������      ������������         ���         ���         ���   ���         ���         ���������������      ������������   ���������   ���������   ���   ���   ���   ���������   ���������������������      ������������         ���      ������      ������   ���      ������         ���������������      ������������������   ���   ���������   ���   ���   ���   ���������������   ���������������      ������������         ���         ���   ���   ���   ���         ���         ���������������      ��������������������������������������������������������������ݪ��������������������������      ��������������������������������������������ݪ��������������������������������������������      ��̪��������������������������������������������www�����̙��www���������������������������      ��������̪�����������������������������������wwwwwwffffffDDDwww���������������������������      ��������������ݪ�����������������������������wwwfffffffffffffff���fffDDDffffffDDDDDDDDD���      ��������������������̪�����������������������wwwffffffffffffwwwffffff333fffffffffDDDDDD���      ��������������������������̙�����������������wwwfffDDDffffffwwwfffffffffwwwwwwfffDDDDDD���      �����������������������������ݪ��������������wwwffffffffffff���fffffffff���fffDDDDDDDDD���      ���      ���������      ���������      ������   wwwwww   fff   wwwfffwwwwwwffffffDDDDDD���      ���      ������   ������   ���   ������   ���   ������   ���   wwwfffffffffDDDDDDDDDfff���         ������   ���   ������������   ������   ���   ������   ���   ������fffDDDDDDDDDDDD������                  ���   ������   ���   ���   ������   ������   ���   ���������DDDDDD������������         ������   ������      ���������   ���   ������      ������   ���������������������������      ������������������������������������������������������������������������������������������               ���������      ������         ���������      ������   ���������   ������                  ������   ������      ������   ������   ������      ������      ���      ���   ���������               ������   ������   ���         ������   ������   ���   ���   ���   ������      ���         ������������            ���   ������   ���            ���   ���������   ������������            ������������   ������   ���   ������   ���   ������   ���   ���������   ���         ���                                                                                                   ��������������������������������������������������������������������������������������������������������������������������������   VI Icond                  ���               Small Fonts 	         
     $   (         /        ���C              �                   ��	     LUU�@ �	�                                                   
�#>
�#>�@'>�@'>     L   ?            �x�e��JQ���u���VfE�x!$��B!u�E7"��n-�E�5��z�ަ'��]����a�of�.����*	�q@��1~䁧��P�{W�	"�v�֟�t�i�����	7|�/?Aا�CW��x��bvn���-����!&�\�`	𘃺��I�c��ӻ��������� �ED]�Jz���<���i6��qH-\����\�YV�!B3�T�>��I��:q�ϲ8o[X�3�J+Gq���L$�ecI�9�4ig�r&�˹D����I4?�   w       X      � �   a      � �   j      � �   s� � �   � �   u� � �  � �Segoe UISegoe UISegoe UI00 RSRC
 LVCCLBVW  Zh  z      ZH               4  h   LIBN      xLVSR      �RTSG      �OBSG      �CCST      �LIvi      �CONP      �TM80      DFDS      LIds      ,VICD      @vers     TGCPR      �STRG      �ICON      �icl4      �icl8      CPC2      LIfp      0FPHb      DFPSE      XLIbd      lBDHb      �BDSE      �VITS      �DTHP      �MUID      �HIST      �PRT       �VCTP      FTAB           ����                                   ����       �        ����       �        ����       �        ����       �        ����      (        ����      0        ����      X        ����      �        ����      �       ����             ����             ����      ,       	����      @       
����      P        ����      d        ����      x        ����      $�        ����      %`        ����      'd        ����      +h        ����      +p        ����      +�        ����      <D        ����      <L        ����      <|        ����      <�        ����      <�        ����      W�        ����      W�        ����      X        ����      X0        ����      X�       �����      Y�    PhFile CmDesc.ctl