FasdUAS 1.101.10   ��   ��    k             l      ��  ��   �� 
	This script needs to be in ~/Library/Application Scripts/com.apple.mail/ that it is useable with newer OS X versions!	In Mail.app set a Rule 	"if any of the following conditions are met:	Any recipient contains exult-cvs-logs@lists.sourceforge.net	Any recipient contains pentagram-cvs@lists.sourceforge.net	Any recipient contains nuvie-svn@lists.sourceforge.net	Any recipient contains xu4-commits@lists.sourceforge.net	Any recipient contains dosbox-cvs-log@lists.sourceforge.net	Run AppleScript snapshots" 
	The script will further check the subject for stuff 
	to make sure that it is new code and not other things 
	(e.g. Exult may have commits for the webspace repository)
     � 	 	\   
 	 T h i s   s c r i p t   n e e d s   t o   b e   i n   ~ / L i b r a r y / A p p l i c a t i o n   S c r i p t s / c o m . a p p l e . m a i l /   t h a t   i t   i s   u s e a b l e   w i t h   n e w e r   O S   X   v e r s i o n s !  	 I n   M a i l . a p p   s e t   a   R u l e    	 " i f   a n y   o f   t h e   f o l l o w i n g   c o n d i t i o n s   a r e   m e t :  	 A n y   r e c i p i e n t   c o n t a i n s   e x u l t - c v s - l o g s @ l i s t s . s o u r c e f o r g e . n e t  	 A n y   r e c i p i e n t   c o n t a i n s   p e n t a g r a m - c v s @ l i s t s . s o u r c e f o r g e . n e t  	 A n y   r e c i p i e n t   c o n t a i n s   n u v i e - s v n @ l i s t s . s o u r c e f o r g e . n e t  	 A n y   r e c i p i e n t   c o n t a i n s   x u 4 - c o m m i t s @ l i s t s . s o u r c e f o r g e . n e t  	 A n y   r e c i p i e n t   c o n t a i n s   d o s b o x - c v s - l o g @ l i s t s . s o u r c e f o r g e . n e t  	 R u n   A p p l e S c r i p t   s n a p s h o t s "   
 	 T h e   s c r i p t   w i l l   f u r t h e r   c h e c k   t h e   s u b j e c t   f o r   s t u f f   
 	 t o   m a k e   s u r e   t h a t   i t   i s   n e w   c o d e   a n d   n o t   o t h e r   t h i n g s   
 	 ( e . g .   E x u l t   m a y   h a v e   c o m m i t s   f o r   t h e   w e b s p a c e   r e p o s i t o r y ) 
   
�� 
 w          i         I     ��  
�� .emalcpmanull���     ****  o      ���� 0 themessages theMessages  �� ��
�� 
pmar  o      ���� 0 	snapshots 	Snapshots��    k    �       O     �    X    � ��   k    �       r        l    ����  n         1    ��
�� 
subj   o    ���� 0 eachmessage eachMessage��  ��    o      ���� 0 
thesubject 
theSubject   ! " ! r     # $ # l    %���� % n     & ' & 1    ��
�� 
ctnt ' o    ���� 0 eachmessage eachMessage��  ��   $ o      ���� 0 thebody theBody "  ( ) ( r     # * + * m     ! , , � - -  x U 4 + o      ���� 0 xu4   )  . / . r   $ ' 0 1 0 m   $ % 2 2 � 3 3 
 E x u l t 1 o      ���� 	0 exult   /  4 5 4 r   ( + 6 7 6 m   ( ) 8 8 � 9 9  P e n t a g r a m 7 o      ���� 0 pent   5  : ; : r   , / < = < m   , - > > � ? ?  D O S B o x = o      ���� 0 dos   ;  @ A @ r   0 3 B C B m   0 1 D D � E E 
 N u v i e C o      ���� 	0 nuvie   A  F�� F Z   4 � G H I�� G F   4 J J K J F   4 A L M L C  4 9 N O N o   4 5���� 0 
thesubject 
theSubject O b   5 8 P Q P m   5 6 R R � S S  [ Q o   6 7���� 0 xu4   M E   < ? T U T o   < =���� 0 
thesubject 
theSubject U m   = > V V � W W  t r u n k / u 4 K H   D H X X E   D G Y Z Y o   D E���� 0 
thesubject 
theSubject Z m   E F [ [ � \ \   t r u n k / u 4 / s r c / i O S H r   M P ] ^ ] o   M N���� 0 xu4   ^ o      ���� 0 subj   I  _ ` _ F   S b a b a C  S X c d c o   S T���� 0 
thesubject 
theSubject d b   T W e f e m   T U g g � h h  [ f o   U V���� 	0 exult   b E   [ ` i j i o   [ \���� 0 
thesubject 
theSubject j m   \ _ k k � l l  [ e x u l t / e x u l t ] `  m n m r   e h o p o o   e f���� 	0 exult   p o      ���� 0 subj   n  q r q F   k ~ s t s C  k r u v u o   k l���� 0 
thesubject 
theSubject v b   l q w x w m   l o y y � z z  [ x o   o p���� 0 pent   t E   u | { | { o   u v���� 0 
thesubject 
theSubject | b   v { } ~ } o   v w���� 0 pent   ~ m   w z   � � �  / t r u n k r  � � � r   � � � � � o   � ����� 0 pent   � o      ���� 0 subj   �  � � � C  � � � � � o   � ����� 0 
thesubject 
theSubject � m   � � � � � � �  [ D o s b o x �  � � � r   � � � � � o   � ����� 0 dos   � o      ���� 0 subj   �  � � � F   � � � � � C  � � � � � o   � ����� 0 
thesubject 
theSubject � b   � � � � � m   � � � � � � �  [ � o   � ����� 	0 nuvie   � E   � � � � � o   � ����� 0 
thesubject 
theSubject � m   � � � � � � �  [ n u v i e / n u v i e ] �  ��� � r   � � � � � o   � ����� 	0 nuvie   � o      ���� 0 subj  ��  ��  ��  �� 0 eachmessage eachMessage  o    ���� 0 themessages theMessages  m      � ��                                                                                  emal  alis    F  Thunderbolt+               ��0	H+     mMail.app                                                          ���        ����  	                Applications    ��!�      ���       m  #Thunderbolt+:Applications: Mail.app     M a i l . a p p    T h u n d e r b o l t +  Applications/Mail.app   / ��     � � � l  � ��� � ���   � 2 , setting path to the folder of the lockfiles    � � � � X   s e t t i n g   p a t h   t o   t h e   f o l d e r   o f   t h e   l o c k f i l e s �  � � � r   � � � � � b   � � � � � l  � � ����� � c   � � � � � l  � � ����� � I  � ��� ���
�� .earsffdralis        afdr � m   � ���
�� afdrcusr��  ��  ��   � m   � ���
�� 
TEXT��  ��   � m   � � � � � � �  . l o c a l � o      ���� 0 fullpath   �  � � � r   � � � � � l  � � ����� � b   � � � � � b   � � � � � b   � � � � � o   � ����� 0 fullpath   � m   � � � � � � �  : � o   � ����� 0 subj   � m   � � � � � � �  b u i l d 1 . l o c k f i l e��  ��   � o      ���� 0 	lockfile1   �  � � � r   � � � � � l  � � ����� � b   � � � � � b   � � � � � b   � � � � � o   � ����� 0 fullpath   � m   � � � � � � �  : � o   � ����� 0 subj   � m   � � � � � � �  b u i l d 2 . l o c k f i l e��  ��   � o      ���� 0 	lockfile2   �  � � � l  � ��� � ���   � h b For showing the icon in the Dialog, the icon path is set to the Apps' app folder in /Applications    � � � � �   F o r   s h o w i n g   t h e   i c o n   i n   t h e   D i a l o g ,   t h e   i c o n   p a t h   i s   s e t   t o   t h e   A p p s '   a p p   f o l d e r   i n   / A p p l i c a t i o n s �  � � � r   � � � � � b   � � � � � b   � � � � � b   � � � � � b   � � � � � l  � � ����� � c   � � � � � l  � � ����� � I  � ��� ���
�� .earsffdralis        afdr � m   � ���
�� afdrapps��  ��  ��   � m   � ���
�� 
TEXT��  ��   � o   � ����� 0 subj   � m   � � � � � � � 0 . a p p : C o n t e n t s : R e s o u r c e s : � o   � ����� 0 subj   � m   � � � � � � � 
 . i c n s � o      ���� 0 	icon_path   �  � � � l  � ���������  ��  ��   �  � � � l   � ��� � ���   ���
			Now we check for the two lockfiles and if necessary create them.
			On first run of the script we create the first one (which eventually 
			will be deleted by the shell script we use to build the snapshot).
			When the shell script is not yet done running but a new commit is being 
			detected by Mail.app this AppleScript is run again but will create a 
			second lockfile and will wait for (loop until) the first buildjob to 
			finish and delete the first lockfile. 
			In that case it will delete the second lockfile and recreate the first 
			one again.
			IF there is another commit being detected while this script loops and 
			waits for the first lockfile to be deleted, the new AppleScript process will quit.
		    � � � �� 
 	 	 	 N o w   w e   c h e c k   f o r   t h e   t w o   l o c k f i l e s   a n d   i f   n e c e s s a r y   c r e a t e   t h e m . 
 	 	 	 O n   f i r s t   r u n   o f   t h e   s c r i p t   w e   c r e a t e   t h e   f i r s t   o n e   ( w h i c h   e v e n t u a l l y   
 	 	 	 w i l l   b e   d e l e t e d   b y   t h e   s h e l l   s c r i p t   w e   u s e   t o   b u i l d   t h e   s n a p s h o t ) . 
 	 	 	 W h e n   t h e   s h e l l   s c r i p t   i s   n o t   y e t   d o n e   r u n n i n g   b u t   a   n e w   c o m m i t   i s   b e i n g   
 	 	 	 d e t e c t e d   b y   M a i l . a p p   t h i s   A p p l e S c r i p t   i s   r u n   a g a i n   b u t   w i l l   c r e a t e   a   
 	 	 	 s e c o n d   l o c k f i l e   a n d   w i l l   w a i t   f o r   ( l o o p   u n t i l )   t h e   f i r s t   b u i l d j o b   t o   
 	 	 	 f i n i s h   a n d   d e l e t e   t h e   f i r s t   l o c k f i l e .   
 	 	 	 I n   t h a t   c a s e   i t   w i l l   d e l e t e   t h e   s e c o n d   l o c k f i l e   a n d   r e c r e a t e   t h e   f i r s t   
 	 	 	 o n e   a g a i n . 
 	 	 	 I F   t h e r e   i s   a n o t h e r   c o m m i t   b e i n g   d e t e c t e d   w h i l e   t h i s   s c r i p t   l o o p s   a n d   
 	 	 	 w a i t s   f o r   t h e   f i r s t   l o c k f i l e   t o   b e   d e l e t e d ,   t h e   n e w   A p p l e S c r i p t   p r o c e s s   w i l l   q u i t . 
 	 	 �  � � � O   �� � � � Z  � � ��� � � I �� ���
�� .coredoexbool        obj  � 4  �� �
�� 
file � o  	
���� 0 	lockfile1  ��   � Z  � � ��� � � I �� ���
�� .coredoexbool        obj  � 4  �� �
�� 
file � o  ���� 0 	lockfile2  ��   � k  !    l ����   K Edisplay dialog (POSIX path of lockfile2) & " exists" # just for debug    � � d i s p l a y   d i a l o g   ( P O S I X   p a t h   o f   l o c k f i l e 2 )   &   "   e x i s t s "   #   j u s t   f o r   d e b u g �� L  !����  ��  ��   � k  $� 	 I $@����

�� .corecrel****      � null��  
 ��
�� 
kocl m  &)��
�� 
file ��
�� 
insh o  ,-���� 0 fullpath   ����
�� 
prdt K  0: ����
�� 
pnam b  38 o  34���� 0 subj   m  47 �  b u i l d 2 . l o c k f i l e��  ��  	  V  AV����   =  EQ l EO���� I EO����
�� .coredoexbool        obj  4  EK��
�� 
file o  IJ���� 0 	lockfile1  ��  ��  ��   m  OP��
�� boovtrue  I Wi�� ��
�� .sysoexecTEXT���     TEXT  l We!����! b  We"#" m  WZ$$ �%%  r m  # n  Zd&'& 1  `d��
�� 
psxp' 4  Z`��(
�� 
file( o  ^_���� 0 	lockfile2  ��  ��  ��   )�) I j��~�}*
�~ .corecrel****      � null�}  * �|+,
�| 
kocl+ m  lo�{
�{ 
file, �z-.
�z 
insh- o  rs�y�y 0 fullpath  . �x/�w
�x 
prdt/ K  v�00 �v1�u
�v 
pnam1 b  y~232 o  yz�t�t 0 subj  3 m  z}44 �55  b u i l d 1 . l o c k f i l e�u  �w  �  ��   � k  ��66 787 I ���s�r9
�s .corecrel****      � null�r  9 �q:;
�q 
kocl: m  ���p
�p 
file; �o<=
�o 
insh< o  ���n�n 0 fullpath  = �m>�l
�m 
prdt> K  ��?? �k@�j
�k 
pnam@ b  ��ABA o  ���i�i 0 subj  B m  ��CC �DD  b u i l d 1 . l o c k f i l e�j  �l  8 E�hE Z  ��FG�g�fF I ���eH�d
�e .coredoexbool        obj H 4  ���cI
�c 
fileI o  ���b�b 0 	lockfile2  �d  G I ���aJ�`
�a .sysoexecTEXT���     TEXTJ l ��K�_�^K b  ��LML m  ��NN �OO  r m  M n  ��PQP 1  ���]
�] 
psxpQ 4  ���\R
�\ 
fileR o  ���[�[ 0 	lockfile2  �_  �^  �`  �g  �f  �h   � m   �SS�                                                                                  MACS  alis    t  Thunderbolt+               ��0	H+   ��
Finder.app                                                      {N��(        ����  	                CoreServices    ��!�      ���     �� ϶   p  6Thunderbolt+:System: Library: CoreServices: Finder.app   
 F i n d e r . a p p    T h u n d e r b o l t +  &System/Library/CoreServices/Finder.app  / ��   � TUT I ���Z�Y�X
�Z .miscactvnull��� ��� null�Y  �X  U VWV l  ���WXY�W  X � � 
			Now the script asks you whether you want to build a new 
			Snapshot of either of those Projects.
			Then it will open a new Terminal and execute the applicable 
			project snapshot script in ~/code/sh (where I store my scripts)
		   Y �ZZ�   
 	 	 	 N o w   t h e   s c r i p t   a s k s   y o u   w h e t h e r   y o u   w a n t   t o   b u i l d   a   n e w   
 	 	 	 S n a p s h o t   o f   e i t h e r   o f   t h o s e   P r o j e c t s . 
 	 	 	 T h e n   i t   w i l l   o p e n   a   n e w   T e r m i n a l   a n d   e x e c u t e   t h e   a p p l i c a b l e   
 	 	 	 p r o j e c t   s n a p s h o t   s c r i p t   i n   ~ / c o d e / s h   ( w h e r e   I   s t o r e   m y   s c r i p t s ) 
 	 	W [\[ r  � ]^] I ���V_`
�V .sysodlogaskr        TEXT_ b  ��aba b  ��cdc m  ��ee �ff 0 N e w   r e v i s i o n ! ! ! 
 
 
 B u i l d  d o  ���U�U 0 subj  b m  ��gg �hh    s n a p s h o t ? 
` �Tij
�T 
btnsi J  ��kk lml m  ��nn �oo  N om p�Sp m  ��qq �rr  O K�S  j �Rst
�R 
givus m  ���Q�Q nt �Puv
�P 
dispu 4  ���Ow
�O 
alisw o  ���N�N 0 	icon_path  v �Mx�L
�M 
apprx o  ���K�K 0 subj  �L  ^ o      �J�J 0 snapshotdialog  \ y�Iy Z  �z{|�Hz G  }~} =  
� n  ��� 1  �G
�G 
bhit� o  �F�F 0 snapshotdialog  � m  	�� ���  O K~ = ��� n  ��� 1  �E
�E 
gavu� o  �D�D 0 snapshotdialog  � m  �C
�C boovtrue{ k  q�� ��� O  o��� k  n�� ��� I $�B�A�@
�B .miscactvnull��� ��� null�A  �@  � ��� I %*�?�>�=
�? .miscactvnull��� ��� null�>  �=  � ��� O +M��� O 1L��� I <K�<��
�< .prcskprsnull���     ctxt� m  <?�� ���  t� �;��:
�; 
faal� J  BG�� ��9� m  BE�8
�8 eMdsKcmd�9  �:  � 4  19�7�
�7 
prcs� m  58�� ���  T e r m i n a l� m  +.���                                                                                  sevs  alis    �  Thunderbolt+               ��0	H+   ��System Events.app                                               {�����        ����  	                CoreServices    ��!�      ����     �� ϶   p  =Thunderbolt+:System: Library: CoreServices: System Events.app   $  S y s t e m   E v e n t s . a p p    T h u n d e r b o l t +  -System/Library/CoreServices/System Events.app   / ��  � ��� I NS�6��5
�6 .sysodelanull��� ��� nmbr� m  NO�4�4 �5  � ��3� I Tn�2��
�2 .coredoscnull��� ��� ctxt� b  T]��� b  TY��� m  TW�� ���   c d   ~ / c o d e / s h ;   .  � o  WX�1�1 0 subj  � m  Y\�� ���  s n a p s h o t . s h� �0��/
�0 
kfil� n  `j��� 1  fj�.
�. 
tcnt� l `f��-�,� 4 `f�+�
�+ 
cwin� m  de�*�* �-  �,  �/  �3  � m  ���                                                                                      @ alis    l  Thunderbolt+               ��0	H+    Terminal.app                                                    �{���B        ����  	                	Utilities     ��!�      ���"         m  2Thunderbolt+:Applications: Utilities: Terminal.app    T e r m i n a l . a p p    T h u n d e r b o l t +  #Applications/Utilities/Terminal.app   / ��  � ��)� l pp�(���(  � 9 3 if the build is canceled delete the first lockfile   � ��� f   i f   t h e   b u i l d   i s   c a n c e l e d   d e l e t e   t h e   f i r s t   l o c k f i l e�)  | ��� =  t}��� n  ty��� 1  uy�'
�' 
bhit� o  tu�&�& 0 snapshotdialog  � m  y|�� ���  N o� ��%� k  ���� ��� I ���$��#
�$ .sysoexecTEXT���     TEXT� l ����"�!� b  ����� m  ���� ���  r m  � n  ����� 1  ��� 
�  
psxp� 4  ����
� 
file� o  ���� 0 	lockfile1  �"  �!  �#  � ��� L  ����  �  �%  �H  �I   �                                                                                  emal  alis    F  Thunderbolt+               ��0	H+     mMail.app                                                          ���        ����  	                Applications    ��!�      ���       m  #Thunderbolt+:Applications: Mail.app     M a i l . a p p    T h u n d e r b o l t +  Applications/Mail.app   / ��  ��       ����  � �
� .emalcpmanull���     ****� � �����
� .emalcpmanull���     ****� 0 themessages theMessages� ���
� 
pmar� 0 	snapshots 	Snapshots�  � ���������
�	������� 0 themessages theMessages� 0 	snapshots 	Snapshots� 0 eachmessage eachMessage� 0 
thesubject 
theSubject� 0 thebody theBody� 0 xu4  � 	0 exult  � 0 pent  �
 0 dos  �	 	0 nuvie  � 0 subj  � 0 fullpath  � 0 	lockfile1  � 0 	lockfile2  � 0 	icon_path  � 0 snapshotdialog  � Q ���� ���� , 2 8 > D R V�� [ g k y  � � ������� � � � � ��� � �S��������������$����4CN��eg��nq���������������������������������������������
� 
kocl
� 
cobj
�  .corecnte****       ****
�� 
subj
�� 
ctnt
�� 
bool
�� afdrcusr
�� .earsffdralis        afdr
�� 
TEXT
�� afdrapps
�� 
file
�� .coredoexbool        obj 
�� 
insh
�� 
prdt
�� 
pnam�� 
�� .corecrel****      � null
�� 
psxp
�� .sysoexecTEXT���     TEXT
�� .miscactvnull��� ��� null
�� 
btns
�� 
givu�� n
�� 
disp
�� 
alis
�� 
appr�� 
�� .sysodlogaskr        TEXT
�� 
bhit
�� 
gavu
�� 
prcs
�� 
faal
�� eMdsKcmd
�� .prcskprsnull���     ctxt
�� .sysodelanull��� ��� nmbr
�� 
kfil
�� 
cwin
�� 
tcnt
�� .coredoscnull��� ��� ctxt��� � ��[��l kh ��,E�O��,E�O�E�O�E�O�E�O�E�O�E�O��%	 ���&	 ���& �E�Y _��%	 	�a �& �E�Y G�a �%	 ��a %�& �E�Y +�a  �E�Y �a �%	 	�a �& �E�Y h[OY�^UOa j a &a %E�O�a %�%a %E�O�a %�%a %E�Oa j a &�%a %�%a  %E�Oa ! �*a "�/j # y*a "�/j # hY d*�a "a $�a %a &�a '%la ( )O h*a "�/j #e hY��Oa **a "�/a +,%j ,O*�a "a $�a %a &�a -%la ( )Y B*�a "a $�a %a &�a .%la ( )O*a "�/j # a /*a "�/a +,%j ,Y hUO*j 0Oa 1�%a 2%a 3a 4a 5lva 6a 7a 8*a 9�/a :�a ; <E�O�a =,a > 
 �a ?,e �& ]a @ Q*j 0O*j 0Oa A *a Ba C/ a Da Ea Fkvl GUUOkj HOa I�%a J%a K*a Lk/a M,l NUOPY '�a =,a O  a P*a "�/a +,%j ,OhY h ascr  ��ޭ