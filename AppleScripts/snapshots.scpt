FasdUAS 1.101.10   ��   ��    k             l      ��  ��   �� This script needs to be in ~/Library/Application Scripts/com.apple.mail/ that it is useable with newer OS X versions!	In Mail.app set a Rule 	"if any of the following conditions are met:	Any recipient contains exult-cvs-logs@lists.sourceforge.net	Any recipient contains pentagram-cvs@lists.sourceforge.net	Any recipient contains nuvie-svn@lists.sourceforge.net	Any recipient contains xu4-commits@lists.sourceforge.net	Any recipient contains dosbox-cvs-log@lists.sourceforge.net	Run AppleScript snapshots" 
	The script will further check the subject for stuff 
	to make sure that it is new code and not other things 
	(e.g. Exult may have commits for the webspace repository)
     � 	 	X   T h i s   s c r i p t   n e e d s   t o   b e   i n   ~ / L i b r a r y / A p p l i c a t i o n   S c r i p t s / c o m . a p p l e . m a i l /   t h a t   i t   i s   u s e a b l e   w i t h   n e w e r   O S   X   v e r s i o n s !  	 I n   M a i l . a p p   s e t   a   R u l e    	 " i f   a n y   o f   t h e   f o l l o w i n g   c o n d i t i o n s   a r e   m e t :  	 A n y   r e c i p i e n t   c o n t a i n s   e x u l t - c v s - l o g s @ l i s t s . s o u r c e f o r g e . n e t  	 A n y   r e c i p i e n t   c o n t a i n s   p e n t a g r a m - c v s @ l i s t s . s o u r c e f o r g e . n e t  	 A n y   r e c i p i e n t   c o n t a i n s   n u v i e - s v n @ l i s t s . s o u r c e f o r g e . n e t  	 A n y   r e c i p i e n t   c o n t a i n s   x u 4 - c o m m i t s @ l i s t s . s o u r c e f o r g e . n e t  	 A n y   r e c i p i e n t   c o n t a i n s   d o s b o x - c v s - l o g @ l i s t s . s o u r c e f o r g e . n e t  	 R u n   A p p l e S c r i p t   s n a p s h o t s "   
 	 T h e   s c r i p t   w i l l   f u r t h e r   c h e c k   t h e   s u b j e c t   f o r   s t u f f   
 	 t o   m a k e   s u r e   t h a t   i t   i s   n e w   c o d e   a n d   n o t   o t h e r   t h i n g s   
 	 ( e . g .   E x u l t   m a y   h a v e   c o m m i t s   f o r   t h e   w e b s p a c e   r e p o s i t o r y ) 
   
�� 
 w          i         I     ��  
�� .emalcpmanull���     ****  o      ���� 0 themessages theMessages  �� ��
�� 
pmar  o      ���� 0 	snapshots 	Snapshots��    O    y    X   x ��   k   s       r        l    ����  n        1    ��
�� 
subj  o    ���� 0 eachmessage eachMessage��  ��    o      ���� 0 
thesubject 
theSubject      r       !   l    "���� " n     # $ # 1    ��
�� 
ctnt $ o    ���� 0 eachmessage eachMessage��  ��   ! o      ���� 0 thebody theBody   % & % r     # ' ( ' m     ! ) ) � * *  x U 4 ( o      ���� 0 xu4   &  + , + r   $ ' - . - m   $ % / / � 0 0 
 E x u l t . o      ���� 	0 exult   ,  1 2 1 r   ( + 3 4 3 m   ( ) 5 5 � 6 6  P e n t a g r a m 4 o      ���� 0 pent   2  7 8 7 r   , / 9 : 9 m   , - ; ; � < <  D O S B o x : o      ���� 0 dos   8  = > = r   0 3 ? @ ? m   0 1 A A � B B 
 N u v i e @ o      ���� 	0 nuvie   >  C D C Z   4 � E F G�� E F   4 J H I H F   4 A J K J C  4 9 L M L o   4 5���� 0 
thesubject 
theSubject M b   5 8 N O N m   5 6 P P � Q Q  [ O o   6 7���� 0 xu4   K E   < ? R S R o   < =���� 0 
thesubject 
theSubject S m   = > T T � U U  t r u n k / u 4 I H   D H V V E   D G W X W o   D E���� 0 
thesubject 
theSubject X m   E F Y Y � Z Z   t r u n k / u 4 / s r c / i O S F r   M P [ \ [ o   M N���� 0 xu4   \ o      ���� 0 subj   G  ] ^ ] F   S b _ ` _ C  S X a b a o   S T���� 0 
thesubject 
theSubject b b   T W c d c m   T U e e � f f  [ d o   U V���� 	0 exult   ` E   [ ` g h g o   [ \���� 0 
thesubject 
theSubject h m   \ _ i i � j j  [ e x u l t / e x u l t ] ^  k l k r   e h m n m o   e f���� 	0 exult   n o      ���� 0 subj   l  o p o F   k ~ q r q C  k r s t s o   k l���� 0 
thesubject 
theSubject t b   l q u v u m   l o w w � x x  [ v o   o p���� 0 pent   r E   u | y z y o   u v���� 0 
thesubject 
theSubject z b   v { { | { o   v w���� 0 pent   | m   w z } } � ~ ~  / t r u n k p   �  r   � � � � � o   � ����� 0 pent   � o      ���� 0 subj   �  � � � C  � � � � � o   � ����� 0 
thesubject 
theSubject � m   � � � � � � �  [ D o s b o x �  � � � r   � � � � � o   � ����� 0 dos   � o      ���� 0 subj   �  � � � F   � � � � � C  � � � � � o   � ����� 0 
thesubject 
theSubject � b   � � � � � m   � � � � � � �  [ � o   � ����� 	0 nuvie   � E   � � � � � o   � ����� 0 
thesubject 
theSubject � m   � � � � � � �  [ n u v i e / n u v i e ] �  ��� � r   � � � � � o   � ����� 	0 nuvie   � o      ���� 0 subj  ��  ��   D  � � � I  � �������
�� .miscactvnull��� ��� null��  ��   �  � � � l  � ��� � ���   � h b For showing the icon in the Dialog, the icon path is set to the Apps' app folder in /Applications    � � � � �   F o r   s h o w i n g   t h e   i c o n   i n   t h e   D i a l o g ,   t h e   i c o n   p a t h   i s   s e t   t o   t h e   A p p s '   a p p   f o l d e r   i n   / A p p l i c a t i o n s �  � � � r   � � � � � b   � � � � � b   � � � � � b   � � � � � b   � � � � � l  � � ����� � c   � � � � � l  � � ����� � I  � ��� ���
�� .earsffdralis        afdr � m   � ���
�� afdrapps��  ��  ��   � m   � ���
�� 
TEXT��  ��   � o   � ����� 0 subj   � m   � � � � � � � 0 . a p p : C o n t e n t s : R e s o u r c e s : � o   � ����� 0 subj   � m   � � � � � � � 
 . i c n s � o      ���� 0 	icon_path   �  � � � l   � ��� � ���   � � � Now the script asks you whether you want to build a new 
				Snapshot of either of those Projects.
				Then it will open a new Terminal and execute the applicable 
				project snapshot script in ~/code/sh (where I store my scripts)
				    � � � ��   N o w   t h e   s c r i p t   a s k s   y o u   w h e t h e r   y o u   w a n t   t o   b u i l d   a   n e w   
 	 	 	 	 S n a p s h o t   o f   e i t h e r   o f   t h o s e   P r o j e c t s . 
 	 	 	 	 T h e n   i t   w i l l   o p e n   a   n e w   T e r m i n a l   a n d   e x e c u t e   t h e   a p p l i c a b l e   
 	 	 	 	 p r o j e c t   s n a p s h o t   s c r i p t   i n   ~ / c o d e / s h   ( w h e r e   I   s t o r e   m y   s c r i p t s ) 
 	 	 	 	 �  � � � r   �  � � � I  � ��� � �
�� .sysodlogaskr        TEXT � b   � � � � � b   � � � � � m   � � � � � � � 0 N e w   r e v i s i o n ! ! ! 
 
 
 B u i l d   � o   � ����� 0 subj   � m   � � � � � � �    s n a p s h o t ? 
 � �� � �
�� 
btns � J   � � � �  � � � m   � � � � � � �  C a n c e l �  ��� � m   � � � � � � �  O K��   � �� � �
�� 
givu � m   � ����� n � �� � �
�� 
disp � 4   � ��� �
�� 
alis � o   � ����� 0 	icon_path   � �� ���
�� 
appr � o   � ����� 0 subj  ��   � o      ���� 0 snapshotdialog   �  ��� � Z  s � ����� � G   � � � =  
 � � � n   � � � 1  ��
�� 
bhit � o  ���� 0 snapshotdialog   � m  	 � � � � �  O K � =  � � � n   � � � 1  ��
�� 
gavu � o  ���� 0 snapshotdialog   � m  ��
�� boovtrue � O  o � � � k  n � �  � � � I $������
�� .miscactvnull��� ��� null��  ��   �  � � � I %*������
�� .miscactvnull��� ��� null��  ��   �  � � � O +M � � � O 1L � � � I <K�� � �
�� .prcskprsnull���     ctxt � m  <? � � � � �  t � �� ���
�� 
faal � J  BG � �  ��� � m  BE��
�� eMdsKcmd��  ��   � 4  19�� 
�� 
prcs  m  58 �  T e r m i n a l � m  +.�                                                                                  sevs  alis    �  Thunderbolt+               ��0	H+   ��System Events.app                                               {�����        ����  	                CoreServices    ��!�      ����     �� ϶   p  =Thunderbolt+:System: Library: CoreServices: System Events.app   $  S y s t e m   E v e n t s . a p p    T h u n d e r b o l t +  -System/Library/CoreServices/System Events.app   / ��   �  I NS����
�� .sysodelanull��� ��� nmbr m  NO���� ��   �� I Tn��	
�� .coredoscnull��� ��� ctxt b  T]

 b  TY m  TW �   c d   ~ / c o d e / s h ;   .   o  WX���� 0 subj   m  Y\ �  s n a p s h o t . s h	 ����
�� 
kfil n  `j 1  fj��
�� 
tcnt l `f���� 4 `f��
�� 
cwin m  de���� ��  ��  ��  ��   � m  �                                                                                      @ alis    l  Thunderbolt+               ��0	H+    Terminal.app                                                    �{���B        ����  	                	Utilities     ��!�      ���"         m  2Thunderbolt+:Applications: Utilities: Terminal.app    T e r m i n a l . a p p    T h u n d e r b o l t +  #Applications/Utilities/Terminal.app   / ��  ��  ��  ��  �� 0 eachmessage eachMessage  o    ���� 0 themessages theMessages  m     �                                                                                  emal  alis    F  Thunderbolt+               ��0	H+     mMail.app                                                          ���        ����  	                Applications    ��!�      ���       m  #Thunderbolt+:Applications: Mail.app     M a i l . a p p    T h u n d e r b o l t +  Applications/Mail.app   / ��   �                                                                                  emal  alis    F  Thunderbolt+               ��0	H+     mMail.app                                                          ���        ����  	                Applications    ��!�      ���       m  #Thunderbolt+:Applications: Mail.app     M a i l . a p p    T h u n d e r b o l t +  Applications/Mail.app   / ��  ��       ����   ��
�� .emalcpmanull���     **** �� ������
�� .emalcpmanull���     ****�� 0 themessages theMessages�� ������
�� 
pmar�� 0 	snapshots 	Snapshots��   ������������~�}�|�{�z�y�x�� 0 themessages theMessages�� 0 	snapshots 	Snapshots�� 0 eachmessage eachMessage�� 0 
thesubject 
theSubject�� 0 thebody theBody� 0 xu4  �~ 	0 exult  �} 0 pent  �| 0 dos  �{ 	0 nuvie  �z 0 subj  �y 0 	icon_path  �x 0 snapshotdialog   :�w�v�u�t�s ) / 5 ; A P T�r Y e i w } � � ��q�p�o�n � � � ��m � ��l�k�j�i�h�g�f�e ��d�c ��b�a�`�_�^�]�\�[
�w 
kocl
�v 
cobj
�u .corecnte****       ****
�t 
subj
�s 
ctnt
�r 
bool
�q .miscactvnull��� ��� null
�p afdrapps
�o .earsffdralis        afdr
�n 
TEXT
�m 
btns
�l 
givu�k n
�j 
disp
�i 
alis
�h 
appr�g 
�f .sysodlogaskr        TEXT
�e 
bhit
�d 
gavu
�c 
prcs
�b 
faal
�a eMdsKcmd
�` .prcskprsnull���     ctxt
�_ .sysodelanull��� ��� nmbr
�^ 
kfil
�] 
cwin
�\ 
tcnt
�[ .coredoscnull��� ��� ctxt��z�vs�[��l kh ��,E�O��,E�O�E�O�E�O�E�O�E�O�E�O��%	 ���&	 ���& �E�Y _��%	 	�a �& �E�Y G�a �%	 ��a %�& �E�Y +�a  �E�Y �a �%	 	�a �& �E�Y hO*j Oa j a &�%a %�%a %E�Oa �%a %a a a  lva !a "a #*a $�/a %�a & 'E�O�a (,a ) 
 �a *,e �& [a + Q*j O*j Oa , *a -a ./ a /a 0a 1kvl 2UUOkj 3Oa 4�%a 5%a 6*a 7k/a 8,l 9UY h[OY��Uascr  ��ޭ