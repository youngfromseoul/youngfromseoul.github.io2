#!/bin/sh
 
LANG=C
export LANG
BUILD_VER=3.5
LAST_UPDATE=2019.03.05

alias ls=ls

HOST_NAME=`hostname`

CREATE_FILE=`hostname`"_before_ini_".txt

echo > $CREATE_FILE 2>&1

echo "INFO_CHKSTART"  >> $CREATE_FILE 2>&1
echo >> $CREATE_FILE 2>&1

echo "##############################################################################"
echo " 		Copyright (c) 2019 AhnLab Co. Ltd. All rights Reserved. "
echo "##############################################################################"
echo " "
echo " "																				>> $CREATE_FILE 2>&1
echo " "
echo " "																				>> $CREATE_FILE 2>&1
echo "######### Starting Linux Vulnerability Scanner $BUILD_VER #########"
echo " "
echo " "																				>> $CREATE_FILE 2>&1
echo " "
echo " "																				>> $CREATE_FILE 2>&1

echo "#########################################################"
echo "o ȣ��Ʈ �� : $HOST_NAME"
echo "o �����Ͻ� : `date`"
echo "#########################################################"						

echo " "																				
echo " "																				>> $CREATE_FILE 2>&1
echo " "																				
echo " "																				>> $CREATE_FILE 2>&1
echo " "																				
echo " "																				>> $CREATE_FILE 2>&1


echo "#################################  Ŀ�� ����   #################################" >> $CREATE_FILE 2>&1
uname -a >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1

echo "#################################  IP ����    ##################################" >> $CREATE_FILE 2>&1
ifconfig -a >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1

echo "#################################  ��Ʈ��ũ ��Ȳ ###############################" >> $CREATE_FILE 2>&1
netstat -an | egrep -i "LISTEN|ESTABLISHED" >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1

echo "################################## ����� ���� #################################" >> $CREATE_FILE 2>&1
netstat -rn >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1

echo "################################## ���μ��� ��Ȳ ###############################" >> $CREATE_FILE 2>&1
ps -ef >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1

echo "################################## ����� ȯ�� #################################" >> $CREATE_FILE 2>&1
env >> $CREATE_FILE 2>&1
echo " " >> $CREATE_FILE 2>&1
#����ġ ���� ���� ����
web='default'
if [ \( `ps -ef | grep apache2 | grep -v grep | wc -l` -ge 1 \) ]; then
	
	web='apache2'
	apache2 -V | egrep "(HTTPD\_ROOT|SERVER\_CONFIG\_FILE)" | awk -F '"' '{print $2}' > webdir.txt
	apache=`cat -n webdir.txt | grep 1 | awk -F ' ' '{print $2}'`/
	conf=$apache`cat -n webdir.txt | grep 2 | awk -F ' ' '{print $2}'`	 
	if [ `cat $conf | wc -l` -eq 0 ]; then
		conf=`cat -n webdir.txt | grep 2 | awk -F ' ' '{print $2}'`
	fi
	docroot=`cat $conf |grep DocumentRoot |grep -v '\#'|awk -F'"' '{print $2}'`
	echo "################################## WEB���� ���� #################################" >> $CREATE_FILE 2>&1
	cat $conf >> $CREATE_FILE 2>&1
	echo " " >> $CREATE_FILE 2>&1
	rm -rf webdir.txt

fi

if [ \( `ps -ef | grep httpd | grep -v grep | wc -l` -ge 1 \) ]; then 

	web='httpd'
	httpd -V | egrep "(HTTPD\_ROOT|SERVER\_CONFIG\_FILE)" | awk -F '"' '{print $2}' > webdir.txt
	apache=`cat -n webdir.txt | grep 1 | awk -F ' ' '{print $2}'`/
	conf=$apache`cat -n webdir.txt | grep 2 | awk -F ' ' '{print $2}'`
	if [ `cat $conf | wc -l` -eq 0 ]; then
		conf=`cat -n webdir.txt | grep 2 | awk -F ' ' '{print $2}'`
	fi
	docroot=`cat "$conf" |grep DocumentRoot |grep -v '\#'|awk -F'"' '{print $2}'`
	echo "################################## WEB���� ���� #################################" >> $CREATE_FILE 2>&1
	cat $conf >> $CREATE_FILE 2>&1 
	echo " " >> $CREATE_FILE 2>&1
rm -rf webdir.txt

fi





U_01() {
  echo -n "U_01. root ���� ���� ���� ���� >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_01. root ���� ���� ���� ����" >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���� ���� : ���� ���񽺸� ������� �ʰų�, ��� �� root ���� ������ ������ ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  echo "�� Telnet ���μ��� ���� ���� Ȯ�� " >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1

  if [ `ps -ef | grep -v grep | grep -i "telnet" | wc -l` -gt 0 ]
	  then
          ps -ef | grep -v grep | grep -i "telnet" >> $CREATE_FILE 2>&1
		  echo " " >> $CREATE_FILE 2>&1
    	  echo "�� Telnet Service enable" >> $CREATE_FILE 2>&1
		  
		  echo " " >> $CREATE_FILE 2>&1
		  echo " " >> $CREATE_FILE 2>&1
  
		  echo "�� /etc/securetty ��Ȳ" >> $CREATE_FILE 2>&1
	      echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1
		  if [ -f /etc/securetty ]
			then
			  cat /etc/securetty | grep -i "pts" >> $CREATE_FILE 2>&1
			  if [ `cat /etc/securetty | grep -i "pts" | grep -v '#' | wc -l` -eq 0 ]
			    then
				  result_telnet='true'
				else
				  result_telnet='false'
			  fi
			else
			   echo "/etc/securetty������ �������� �ʽ��ϴ�." >> $CREATE_FILE 2>&1
			   result_telnet='false'
		   fi
		   
		   echo " " >> $CREATE_FILE 2>&1
		   
		   echo "�� /etc/pam.d/login ��Ȳ" >> $CREATE_FILE 2>&1
	       echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1
		   if [ -f /etc/pam.d/login ]
			then
			  cat /etc/pam.d/login | grep -i "pam_securetty.so" >> $CREATE_FILE 2>&1
			  if [ `cat /etc/pam.d/login | grep "pam_securetty.so" | grep -v "#" | wc -l` -eq 0 ]
			    then
				  result_telnet='false'
				else
				  result_telnet='true'
			  fi
			else
			   echo "/etc/pam.d/login������ �������� �ʽ��ϴ�." >> $CREATE_FILE 2>&1
			   result_telnet='false'
		   fi
   else
      	echo "�� Telnet Service disable" >> $CREATE_FILE 2>&1
		result_telnet='true'		
  fi
  
  
  echo " " >> $CREATE_FILE 2>&1  
  echo " " >> $CREATE_FILE 2>&1 
  
  
  
  echo "�� SSH ���μ��� ���� ���� Ȯ�� " >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1

  if [ `ps -ef | grep sshd | grep -v "grep" | wc -l` -eq 0 ]
	  then
		  echo "�� SSH Service Disable" >> $CREATE_FILE 2>&1
		  result_sshd='true'
	  else
		  ps -ef | grep sshd | grep -v "grep" >> $CREATE_FILE 2>&1
		  echo " " >> $CREATE_FILE 2>&1 
		  echo "�� SSH Service Enable" >> $CREATE_FILE 2>&1
		  
		  echo " " >> $CREATE_FILE 2>&1 
		  echo " " >> $CREATE_FILE 2>&1 
		  
		  echo "�� sshd_config���� Ȯ��" >> $CREATE_FILE 2>&1
		  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1

		  echo " " > ssh-result.ahnlab

		  ServiceDIR="/etc/sshd_config /etc/ssh/sshd_config /usr/local/etc/sshd_config /usr/local/sshd/etc/sshd_config /usr/local/ssh/etc/sshd_config /etc/opt/ssh/sshd_config"

		  for file in $ServiceDIR
			do
				if [ -f $file ]
					then
						if [ `cat $file | grep "PermitRootLogin" | grep -v "setting" | wc -l` -gt 0 ]
							then
							cat $file | grep "PermitRootLogin" | grep -v "setting" | awk '{print "SSH ��������('${file}'): "}' >> ssh-result.ahnlab
							echo " " >> $CREATE_FILE 2>&1
							cat $file | grep "PermitRootLogin" | grep -v "setting" | awk '{print $0 }' >> ssh-result.ahnlab 
							if [ `cat $file | grep -i "PermitRootLogin no" | grep -v '#' | wc -l` -gt 0 ]
								then
									result_sshd='true'
								else
									result_sshd='false'
							fi
						else	
							echo "SSH ��������($file): PermitRootLogin ������ �������� �ʽ��ϴ�." >> ssh-result.ahnlab
						fi
						if [ `cat $file | grep -i "banner" | grep -v "default banner" | wc -l` -gt 0 ]
							then
								cat $file | grep -i "banner" | grep -v "default banner" | awk '{print "SSH ��������('${file}'): " $0 }' >> ssh-banner.ahnlab
						else
							echo "ssh �α��� �� ��µǴ� ��������� �Ǿ� ���� �ʽ��ϴ�. " >> ssh-banner.ahnlab
						fi	
						# U_67 �׸� ssh ��ʼ��� ���� �߰�, ssh-banner.ahnlab ���� �ش� �׸񿡼� ����
				fi
			done 
			
			  if [ `cat ssh-result.ahnlab | grep -v "^ *$" | wc -l` -gt 0 ]
				then
					cat ssh-result.ahnlab | grep -v "^ *$" >> $CREATE_FILE 2>&1
			  else
				echo "SSH ���������� ã�� �� �����ϴ�. (���ͺ�/��������)" >> $CREATE_FILE 2>&1
			  fi
			
	fi

  echo " " >> $CREATE_FILE 2>&1 
  echo " " >> $CREATE_FILE 2>&1 
  
  if [ $result_telnet = 'true' -a $result_sshd = 'true' ]
    then
      echo "�� U_01. ��� : ��ȣ" >> $CREATE_FILE 2>&1
    else
      echo "�� U_01. ��� : ���" >> $CREATE_FILE 2>&1
  fi
  

  rm -rf ssh-result.ahnlab

  
  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_02() {
  echo -n "U_02. �н����� ���⼺ ���� >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_02. �н����� ���⼺ ����" >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : ���������ڡ�Ư�����ڰ� ȥ�յ� 9�ڸ� �̻��� �н����尡 ������ ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  
  if [ -f /etc/shadow ]
    then
      echo "[/etc/shadow ���� ���� ��Ȳ]" >> $CREATE_FILE 2>&1
      cat /etc/shadow  | grep -v '*' | grep -v '!' | grep -v '!!' >> $CREATE_FILE 2>&1
    else
      echo "/etc/shadow ������ �����ϴ�. " >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1
  echo "�� U_02. ��� : ��������" >> $CREATE_FILE 2>&1

  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_03() {
  echo -n "U_03. ���� ��� �Ӱ谪 ���� >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_03. ���� ��� �Ӱ谪 ����" >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : ���� ��� �Ӱ谪�� 5������ ������ �����Ǿ� �ִ� ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  
  if [ -f /etc/pam.d/system-auth ]; then
	if [ `cat /etc/pam.d/system-auth | grep -i "pam_tally.so" | grep -v "#" | wc -l` -gt 0 ]  #20160105-01 start
		then
			cat /etc/pam.d/system-auth | grep -i "pam_tally.so" | grep -v "#" >> $CREATE_FILE 2>&1
	else if [ `cat /etc/pam.d/system-auth | grep -i "pam_tally2.so" | grep -v "#" | wc -l` -gt 0 ]
		then
			cat /etc/pam.d/system-auth | grep -i "pam_tally2.so" | grep -v "#" >> $CREATE_FILE 2>&1
	else
		echo "/etc/pam.d/system-auth ���Ͽ� �������� �����ϴ�." >> $CREATE_FILE 2>&1
	fi
	fi
    else
	    echo "/etc/pam.d/system-auth ������ �������� �ʽ��ϴ�." >> $CREATE_FILE 2>&1
  fi	
  echo " " >> $CREATE_FILE 2>&1


  if [ -f /etc/pam.d/system-auth ]
	then
		if [ `grep "pam_tally.so" /etc/pam.d/system-auth | grep -v '#' | wc -l` -gt 0 ]
			then
				if [ `cat /etc/pam.d/system-auth | grep -v '#' |grep -i "deny=" | awk -F'deny=' '{print $2}'|awk '{print $1}'` -le 5 ]
					then
						echo "�� U_03. ��� : ��ȣ" >> $CREATE_FILE 2>&1
				else
						echo "�� U_03. ��� : ���" >> $CREATE_FILE 2>&1
				fi
		else if [ `grep "pam_tally2.so" /etc/pam.d/system-auth | grep -v '#' | wc -l` -gt 0  ] 
			then
				if [ `cat /etc/pam.d/system-auth | grep -v '#' |grep -i "deny=" | awk -F'deny=' '{print $2}'|awk '{print $1}'` -le 5 ]
					then
						echo "�� U_03. ��� : ��ȣ" >> $CREATE_FILE 2>&1
				else
						echo "�� U_03. ��� : ���" >> $CREATE_FILE 2>&1
				fi
		else
			echo "�� U_03. ��� : ���" >> $CREATE_FILE 2>&1
		fi
		fi
	else
		echo "�� U_03. ��� : ���" >> $CREATE_FILE 2>&1
	fi
 #20160105-01 end

  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_04() {
  echo -n "U_04. �н����� ���� ��ȣ >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_04 �н����� ���� ��ȣ" >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : ������ �н����带 ����ϰų�, �н����带 ��ȣȭ�Ͽ� �����ϴ� ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  if [ -f /etc/shadow ]
    then
	  echo "[/etc/shadow ���� ���� ��Ȳ]" >> $CREATE_FILE 2>&1
      cat /etc/shadow | grep -v '!'  | grep -v '!!' | grep -v '*'  >> $CREATE_FILE 2>&1
    else
      echo "/etc/shadow ������ �������� �ʽ��ϴ�." >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1


  if [ -f /etc/shadow ]
    then
      echo "�� U_04. ��� : ��ȣ" >> $CREATE_FILE 2>&1
    else
      echo "�� U_04. ��� : ���" >> $CREATE_FILE 2>&1
  fi


  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_05() {
  echo -n "U_05. root �̿��� UID '0' ���� >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_05. root �̿��� UID '0' ����" >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : root ������ ������ UID�� ���� ������ �������� �ʴ� ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  if [ -f /etc/passwd ]
    then
      awk -F: '$3==0 { print $1 " -> UID=" $3 }' /etc/passwd >> $CREATE_FILE 2>&1
    else
      echo "/etc/passwd ������ �����ϴ�." >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

  echo "[/etc/passwd ���� ����]" >> $CREATE_FILE 2>&1
  cat /etc/passwd >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  if [ `awk -F: '$3==0  { print $1 }' /etc/passwd | grep -v "root" | wc -l` -eq 0 ]
    then
      echo "�� U_05. ��� : ��ȣ" >> $CREATE_FILE 2>&1
    else
      echo "�� U_05. ��� : ���" >> $CREATE_FILE 2>&1
  fi


  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_06() {
  echo -n "U_06. root���� su ���� >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_06. root���� su ����" >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : su ��ɾ Ư�� �׷쿡 ���� ����ڸ� ����ϵ��� ���ѵǾ� �ִ� ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "              pam ���� ������ su���� �۹̼�(4750)�� ���� ���׷��� ���� �Ǿ��ִ°�� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  echo "�� /etc/pam.d/su ���� �� pam_wheel.so ����" >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1
  if [ -f /etc/pam.d/su ]
    then
      if [ `cat /etc/pam.d/su | grep -i "pam_wheel.so" | grep -v '#' | grep -v 'trust' | wc -l` -eq 1 ]
      then
        cat /etc/pam.d/su | grep -i "pam_wheel.so" | grep -v '#' | grep -v 'trust' >> $CREATE_FILE 2>&1
        echo " " >> $CREATE_FILE 2>&1
        echo "�� pam ���� �Ǿ�����" >> $CREATE_FILE 2>&1
      else
        echo "�� pam ���� �Ǿ����� ����" >> $CREATE_FILE 2>&1
      fi
  else
     echo "/etc/pam.d/su ������ �����ϴ�. " >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  echo "�� su ���� �۹̼�(��ݽü� ���� /usr/bin/su) " >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1
  if [ -f /usr/bin/su ]
   then
     ls -al /usr/bin/su >> $CREATE_FILE 2>&1
   else
     echo "/usr/bin/su ������ �����ϴ�. " >> $CREATE_FILE 2>&1 
  fi
  echo " " >> $CREATE_FILE 2>&1
  if [ -f /bin/su ]
   then
  	 ls -al /bin/su >> $CREATE_FILE 2>&1
   else
     echo "/bin/su ������ �������� �ʽ��ϴ�." >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  echo "�� /etc/group ���� ����(wheel �Ǵ� su ���� �׷� ���԰��� ����Ʈ Ȯ��)" >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1
  cat /etc/group >> $CREATE_FILE 2>&1

  echo " " >> $CREATE_FILE 2>&1

  if [ `cat /etc/pam.d/su | grep 'pam_wheel.so' | grep -v '#' | grep -v 'trust' | wc -l` -eq 0 ]
    then
      if [ -f /bin/su ]
        then
          if [ `ls -alL /bin/su | grep ".....-.---" | wc -l` -eq 1 ]
            then
              echo "�� U_06. ��� : ��ȣ" >> $CREATE_FILE 2>&1
            else
              echo "�� U_06. ��� : ���" >> $CREATE_FILE 2>&1
          fi
      elif [ -f /usr/bin/su ]
       then
         if [ `ls -alL usr/bin/su | grep ".....-.---" | wc -l` -eq 1 ]
            then
              echo "�� U_06. ��� : ��ȣ" >> $CREATE_FILE 2>&1
            else
              echo "�� U_06. ��� : ���" >> $CREATE_FILE 2>&1
         fi
          echo "�� U_06. ��� : ���" >> $CREATE_FILE 2>&1
      fi
    else
      echo "�� U_06. ��� : ��ȣ" >> $CREATE_FILE 2>&1
  fi


  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_07() {
  echo -n "U_07. �н����� �ּ� ���� ���� >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_07. �н����� �ּ� ���� ����" >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : �н����� �ּ� ���̰� 9�� �̻����� �����Ǿ� �ִ� ��� ��ȣ(������ ���� 9�ڸ�)" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  if [ -f /etc/login.defs ]
    then
      echo "[�н����� ���� ��Ȳ]" >> $CREATE_FILE 2>&1
      cat /etc/login.defs | grep -i "PASS_MIN_LEN" | grep -v "#" >> $CREATE_FILE 2>&1
    else
      echo " /etc/login.defs ������ �������� ���� " >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1
  echo " " > password.ahnlab
  
  if [ -f /etc/login.defs ]
  then
  if [ `cat /etc/login.defs | grep -i "PASS_MIN_LEN" | grep -v "#" | awk '{print $2}'` -gt 8 ]
    then
      echo "��ȣ" >> password.ahnlab 2>&1
    else
      echo "���" >> password.ahnlab 2>&1
  fi
  fi


  if [ `cat password.ahnlab | grep "���" | wc -l` -eq 0 ]
    then
	  echo "�� U_07. ��� : ��ȣ" >> $CREATE_FILE 2>&1
    else
      echo "�� U_07. ��� : ���" >> $CREATE_FILE 2>&1
  fi

  rm -rf password.ahnlab


  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_08() {
  echo -n "U_08. �н����� �ִ� ���Ⱓ ���� >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_08. �н����� �ִ� ���Ⱓ ����" >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : �н����� �ִ� ���Ⱓ�� 90��(12��) ���Ϸ� �����Ǿ� ���� ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  if [ -f /etc/login.defs ]
    then
      echo "[�н����� ���� ��Ȳ]" >> $CREATE_FILE 2>&1
      cat /etc/login.defs | grep -i "PASS_MAX_DAYS" | grep -v "#" >> $CREATE_FILE 2>&1
    else
      echo " /etc/login.defs ������ �������� ���� " >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1
  echo " " > password.ahnlab
  
  if [ `cat /etc/login.defs | grep -i "PASS_MAX_DAYS" | grep -v "#" | awk '{print $2}'` -le 90 ]
    then
      echo "��ȣ" >> password.ahnlab 2>&1
    else
      echo "���" >> password.ahnlab 2>&1
  fi


  if [ `cat password.ahnlab | grep "���" | wc -l` -eq 0 ]
    then
      echo "�� U_08. ��� : ��ȣ" >> $CREATE_FILE 2>&1
    else
      echo "�� U_08. ��� : ���" >> $CREATE_FILE 2>&1
  fi

  rm -rf password.ahnlab


  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_09() {
  echo -n "U_09. �н����� �ּ� ���Ⱓ ���� >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_09. �н����� �ּ� ���Ⱓ ����" >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : �н����� �ּ� ���Ⱓ�� 1��(1��)�� �����Ǿ� �ִ� ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  if [ -f /etc/login.defs ]
    then
      echo "[�н����� ���� ��Ȳ]" >> $CREATE_FILE 2>&1
      cat /etc/login.defs | grep -i "PASS_MIN_DAYS" | grep -v "#" >> $CREATE_FILE 2>&1
    else
      echo " /etc/login.defs ������ �������� ���� " >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1
  echo " " > password.ahnlab
  
  if [ `cat /etc/login.defs | grep -i "PASS_MIN_DAYS" | grep -v "#" | awk '{print $2}'` -ge 1 ]
    then
      echo "��ȣ" >> password.ahnlab 2>&1
    else
      echo "���" >> password.ahnlab 2>&1
  fi


  if [ `cat password.ahnlab | grep "���" | wc -l` -eq 0 ]
    then
      echo "�� U_09. ��� : ��ȣ" >> $CREATE_FILE 2>&1
    else
      echo "�� U_09. ��� : ���" >> $CREATE_FILE 2>&1
  fi

  rm -rf password.ahnlab


  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_10() {
  echo -n "U_10. ���ʿ��� ���� ���� >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_10. ���ʿ��� ���� ����" >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : ���ʿ��� ������ �������� �ʴ� ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "              �⺻ ��ġ�Ǵ� �ý��� ���� �� ���ʿ��� ���� Ȯ��" >> $CREATE_FILE 2>&1
  echo "              �������� �α��� ����� ���� ����� ���� Ȯ��" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  
  echo "�� �⺻ �ý��� ����(adm, lp, sync, shutdown, halt, news, uucp, nuucp, operator, games, gopher, nfsnobody, squid) " >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1
  if [ `cat /etc/passwd | egrep "^adm:|^lp:| ^sync: | ^shutdown:| ^halt:|^news:|^uucp:|^nuucp:|^operator:|^games:|^gopher:|^nfsnobody:|^squid:" | wc -l` -eq 0 ]
    then
      echo "���ʿ��� �⺻ �ý��� ������ �������� �ʽ��ϴ�." >> $CREATE_FILE 2>&1
    else
      cat /etc/passwd | egrep "^adm:|^lp:| ^sync: | ^shutdown:| ^halt:|^news:|^uucp:|^nuucp:|^operator:|^games:|^gopher:|^nfsnobody:|^squid:" >> $CREATE_FILE 2>&1
  fi
  echo " " >> $CREATE_FILE 2>&1
  
  echo "�� ���� ���� �α�(lastlog) " >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1
  lastlog >> $CREATE_FILE 2>&1

  echo " " >> $CREATE_FILE 2>&1
  echo "�� U_10. ��� : ��������" >> $CREATE_FILE 2>&1
  


  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_11() {
  echo -n "U_11. ������ �׷쿡 �ּ����� ���� ���� >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_11. ������ �׷쿡 �ּ����� ���� ����" >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : ������ �׷쿡 ���ʿ��� ������ ��ϵǾ� ���� ���� ��� ��ȣ(������ ������ ������� ����� Ȯ�� �ʿ�)" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  if [ -f /etc/group ]
    then
      echo "[������ �׷� ���� ��Ȳ]" >> $CREATE_FILE 2>&1
      cat /etc/group | grep "root:" >> $CREATE_FILE 2>&1
    else
      echo " /etc/group ������ �����ϴ�." >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

  if [ `cat /etc/group | grep "root:" | grep ":root," | wc -l` -eq 0 ]
    then
      echo "�� U_11. ��� : ��ȣ" >> $CREATE_FILE 2>&1
    else
      echo "�� U_11. ��� : ���" >> $CREATE_FILE 2>&1
  fi


  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_12() {
  echo -n "U_12. ������ �������� �ʴ� GID ���� >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_12. ������ �������� �ʴ� GID ����" >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : �������� �ʴ� ������ GID ������ ������ ��� ��ȣ(�⺻ �ý��� ���� �� �ű� ������ ������ Ȯ��)" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  
  echo "�� �������� �������� �ʴ� �׷�" >> $CREATE_FILE 2>&1 #20160106-03
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1
  awk -F: '{print $3}' /etc/group > gid_group.txt 
  
  for D in `cat gid_group.txt` 
  do 
	awk -F: '{print $4}' /etc/passwd | grep -w $D > gid_1.txt 
	
	if [ `cat gid_1.txt | wc -l` -gt 0 ]
	then 
		echo "gid=$D"  > /dev/null 
	else 
		echo $D >> gid_none.txt 
	fi 
 done

	if [ `cat gid_none.txt | wc -l` -gt 0 ]
	then
		for A in `cat gid_none.txt` 
		do
			awk -F: '{print $1, $3}' /etc/group | grep -w $A >> $CREATE_FILE 2>&1  
			done 
		echo " " >> $CREATE_FILE 2>&1
		echo "�� U_12. ��� : ���" >> $CREATE_FILE 2>&1 
	else
	    echo " " >> $CREATE_FILE 2>&1
		echo "�� U_12. ��� : ��ȣ" >> $CREATE_FILE 2>&1
	fi
  
rm -rf gid_group.txt 
rm -rf gid_none.txt 
rm -rf gid_1.txt   

  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_13() {
  echo -n "U_13. ������ UID ���� >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_13. ������ UID ����" >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : ������ UID�� ������ ����� ������ �������� �ʴ� ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  for uid in `cat /etc/passwd | awk -F: '{print $3}'`
    do
	    cat /etc/passwd | awk -F: '$3=="'${uid}'" { print "UID=" $3 " -> " $1 }' > account.ahnlab
    	if [ `cat account.ahnlab | wc -l` -gt 1 ]
	      then
		      cat account.ahnlab >> total-account.ahnlab
	    fi
    done
if [ -f total-account.ahnlab ]
	then
  if [ `sort -k 1 total-account.ahnlab | wc -l` -gt 1 ]
    then
	    sort -k 1 total-account.ahnlab | uniq -d >> $CREATE_FILE 2>&1
	fi
else
	    echo "������ UID�� ����ϴ� ������ �߰ߵ��� �ʾҽ��ϴ�." >> $CREATE_FILE 2>&1
  
fi
  echo " " >> $CREATE_FILE 2>&1

if [ -f total-account.ahnlab ]
	then
  if [ `sort -k 1 total-account.ahnlab | wc -l` -gt 1 ]
    then
      echo "�� U_13. ��� : ���" >> $CREATE_FILE 2>&1
	fi
else
      echo "�� U_13. ��� : ��ȣ" >> $CREATE_FILE 2>&1 
fi
  rm -rf account.ahnlab
  rm -rf total-account.ahnlab

  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_14() {
  echo -n "U_14. ����� shell ���� >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_14. ����� shell ����" >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : �α����� �ʿ����� ���� ������ /bin/false(nologin) ���� �ο��Ǿ� �ִ� ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  if [ -f /etc/passwd ]
    then
      cat /etc/passwd | egrep "^daemon|^bin|^sys|^adm|^listen|^nobody|^nobody4|^noaccess|^diag|^listen|^operator|^games|^gopher" | grep -v "admin" >> $CREATE_FILE 2>&1
    else
      echo "/etc/passwd ������ �����ϴ�." >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

  if [ `cat /etc/passwd | egrep "^daemon|^bin|^sys|^adm|^listen|^nobody|^nobody4|^noaccess|^diag|^listen|^operator|^games|^gopher" | grep -v "admin" |  awk -F: '{print $7}'| egrep -v 'false|nologin|null|halt|sync|shutdown' | wc -l` -eq 0 ]
    then
      echo "�� U_14. ��� : ��ȣ" >> $CREATE_FILE 2>&1
    else
      echo "�� U_14. ��� : ���" >> $CREATE_FILE 2>&1
  fi


  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_15() {
  echo -n "U_15. Session Timeout ���� >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_15. Session Timeout ����" >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : Session Timeout�� 600��(10��) ���Ϸ� �����Ǿ� �ִ� ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1


  echo "" > account_sson.ahnlab
  
  echo "�� /etc/profile ���ϼ���" >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1	

  if [ -f /etc/profile ]
    then
	  if [ `cat /etc/profile | egrep -i "TMOUT|TIMEOUT" | grep -v "#" | wc -l` -eq 0 ]
	   then
	     echo "/etc/profile ���� �� TMOUT/TIMEOUT ������ �����ϴ�." >> $CREATE_FILE 2>&1
		 echo "���" >> account_sson.ahnlab
       else
	     cat /etc/profile | egrep -i "TMOUT|TIMEOUT" >> $CREATE_FILE 2>&1
		 if [ `cat /etc/profile | grep -v "#" | egrep -i "TMOUT|TIMEOUT" | grep -v '[0-9]600' | grep '600$' | wc -l ` -eq 0 ]
		   then
		     echo "���" >> account_sson.ahnlab
	       else
		     echo "��ȣ" >> account_sson.ahnlab
	     fi
	  fi
    else
      echo "/etc/profile ������ �����ϴ�." >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

  
  if [ -f /etc/csh.login ]
    then
	 echo "�� /etc/csh.login ���ϼ���" >> $CREATE_FILE 2>&1
     echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1	
	  if [ `cat /etc/csh.login | egrep -i "autologout" | grep -v "#" | wc -l` -eq 0 ]
	   then
	    echo "/etc/csh.login ���� �� autologout ������ �����ϴ�." >> $CREATE_FILE 2>&1
		echo "���" >> account_sson.ahnlab
	  else
       cat /etc/csh.login | grep -i "autologout" >> $CREATE_FILE 2>&1
	   	if [ `cat /etc/csh.login | grep -v "#" | grep -i 'autologout' | grep -v '[0-9]10' | grep '10$' | wc -l ` -eq 0 ]
		   then
		     echo "���" >> account_sson.ahnlab
	       else
		     echo "��ȣ" >> account_sson.ahnlab
	    fi
	  fi
  else if [ -f /etc/csh.cshrc ]
   then
    echo "�� /etc/csh.cshrc ���ϼ���" >> $CREATE_FILE 2>&1
    echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1	
      if [ `cat /etc/csh.cshrc | egrep -i "autologout" | grep -v "#" | wc -l` -eq 0 ]
	   then
	    echo "/etc/csh.cshrc ���� �� autologout ������ �����ϴ�." >> $CREATE_FILE 2>&1
		echo "���" >> account_sson.ahnlab
	  else
       cat /etc/csh.cshrc | grep -i "autologout" >> $CREATE_FILE 2>&1
	   	if [ `cat /etc/csh.cshrc | grep -v "#" | grep -i 'autologout' | grep -v '[0-9]10' | grep '10$' | wc -l ` -eq 0 ]
		   then
		     echo "���" >> account_sson.ahnlab
	       else
		     echo "��ȣ" >> account_sson.ahnlab
	    fi
	  fi
  else
     echo "/etc/csh.login, /etc/csh.cshrc ������ �����ϴ�." >> $CREATE_FILE 2>&1
  fi
  fi

  echo " " >> $CREATE_FILE 2>&1

  if [ `cat account_sson.ahnlab | grep "���" | wc -l` -eq 0 ]
    then
       echo "�� U_15. ��� : ��ȣ" >> $CREATE_FILE 2>&1
    else
       echo "�� U_15. ��� : ���" >> $CREATE_FILE 2>&1
  fi
  
  rm -rf account_sson.ahnlab


  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_16() {
  echo -n "U_16. root Ȩ, �н� ���͸� ���� �� �н� ���� >>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_16. root Ȩ, �н� ���͸� ���� �� �н� ����" >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : PATH ȯ�溯���� '.' �� �� ���̳� �߰��� ���Ե��� ���� ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  echo " " >> $CREATE_FILE 2>&1
  echo "�� PATH ȯ�溯�� ��Ȳ" >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1	  
  echo $PATH >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  echo " " >> $CREATE_FILE 2>&1

  if [ `echo $PATH | grep "\.:" | wc -l` -eq 0 ]
    then
      echo "�� U_16. ��� : ��ȣ" >> $CREATE_FILE 2>&1
    else
      echo "�� U_16. ��� : ���" >> $CREATE_FILE 2>&1
  fi


  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_17() {
  echo -n "U_17. ���� �� ���͸� ������ ���� >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_17. ���� �� ���͸� ������ ����" >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : �����ڰ� �������� ���� ���� �� ���͸��� �������� ���� ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  echo "�� �����ڰ� �������� �ʴ� ����" >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1
  for i in /home /usr /tmp
  do
    find $i -nouser >> file-own.ahnlab
  done
  
  if [ -s file-own.ahnlab ]
    then
	    cat file-own.ahnlab >> $CREATE_FILE 2>&1
    else
	    echo "�����ڰ� �������� �ʴ� ������ �߰ߵ��� �ʾҽ��ϴ�." >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1
  
  if [ -s file-own.ahnlab ]
    then
      echo "�� U_17. ��� : ���" >> $CREATE_FILE 2>&1
    else
      echo "�� U_17. ��� : ��ȣ" >> $CREATE_FILE 2>&1
  fi

  rm -rf file-own.ahnlab

  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_18() {
  echo -n "U_18. /etc/passwd ���� ������ �� ���� ���� >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_18. /etc/passwd ���� ������ �� ���� ����" >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : /etc/passwd ������ �����ڰ� root�̰�, ������ 644 ������ ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  if [ -f /etc/passwd ]
    then
	  echo "�� /etc/passwd ���� �۹̼� Ȯ��" >> $CREATE_FILE 2>&1
      echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1
      ls -alL /etc/passwd >> $CREATE_FILE 2>&1
    else
      echo " /etc/passwd ������ �����ϴ�." >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1


  if [ `ls -alL /etc/passwd | grep "...-.--.--" | wc -l` -eq 1 ]
    then
      echo "�� U_18. ��� : ��ȣ" >> $CREATE_FILE 2>&1
    else
      echo "�� U_18. ��� : ���" >> $CREATE_FILE 2>&1
  fi


  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_19() {
  echo -n "U_19. /etc/shadow ���� ������ �� ���� ���� >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_19. /etc/shadow ���� ������ �� ���� ���� " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : /etc/shadow ������ �����ڰ� root�̰�, ������ 400 ������ ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1


  if [ -f /etc/shadow ]
    then
      echo "�� /etc/shadow ���� �۹̼� Ȯ��" >> $CREATE_FILE 2>&1
      echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1
	  ls -alL /etc/shadow >> $CREATE_FILE 2>&1
    else
      echo " /etc/shadow ������ �����ϴ�." >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1


  if [ `ls -alL /etc/shadow | grep "..--------" | wc -l` -eq 1 ]
    then
      echo "�� U_19. ��� : ��ȣ" >> $CREATE_FILE 2>&1
    else
      echo "�� U_19. ��� : ���" >> $CREATE_FILE 2>&1
  fi


  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_20() {
  echo -n "U_20. /etc/hosts ���� ������ �� ���� ���� >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_20. /etc/hosts ���� ������ �� ���� ���� " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : /etc/hosts ������ �����ڰ� root�̰�, ������ 600 ������ ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  if [ -f /etc/hosts ]
    then
		echo "�� /etc/hosts ���� �۹̼� Ȯ��" >> $CREATE_FILE 2>&1
    	echo "----------------------------------------------------------------" >> $CREATE_FILE 2>&1	
      ls -alL /etc/hosts >> $CREATE_FILE 2>&1
		echo "�� /etc/hosts ���� ����" >> $CREATE_FILE 2>&1
		  cat /etc/hosts >> $CREATE_FILE 2>&1
    else
      echo " /etc/hosts ������ �����ϴ�." >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

  if [ -f /etc/hosts ]
   then
  if [ `ls -alL /etc/hosts | grep "...-------" | wc -l` -eq 1 ]
    then
      echo "�� U_20. ��� : ��ȣ" >> $CREATE_FILE 2>&1
    else
      echo "�� U_20. ��� : ���" >> $CREATE_FILE 2>&1
  fi
  fi


  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_21() {
  echo -n "U_21. /etc/(x)inetd.conf ���� ������ �� ���� ���� >>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_21. /etc/(x)inetd.conf ���� ������ �� ���� ���� " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : /etc/(X)inetd.conf������ �����ڰ� root�̰�, ������ 600 ������ ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1


  if [ -d /etc/xinetd.d ] 
    then
	  echo "�� /etc/xinetd.d ���丮 ���� ��Ȳ." >> $CREATE_FILE 2>&1
      ls -al /etc/xinetd.d/* >> $CREATE_FILE 2>&1
    else
      echo "/etc/xinetd.d ���丮�� �����ϴ�." >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

  if [ -f /etc/xinetd.conf ]
	then
	   echo "�� /etc/xinetd.conf ���� �۹̼� ��Ȳ." >> $CREATE_FILE 2>&1
	   ls -al /etc/xinetd.conf
	else
		echo "/etc/xinetd.conf ������ �����ϴ�." >> $CREATE_FILE 2>&1
	fi
	echo " " >> $CREATE_FILE 2>&1

  if [ -f /etc/inetd.conf ]
    then
	  echo "�� /etc/inetd.conf ���� �۹̼� ��Ȳ." >> $CREATE_FILE 2>&1
      ls -al /etc/inetd.conf >> $CREATE_FILE 2>&1
    else
      echo "/etc/inetd.conf ������ �����ϴ�." >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

  echo " " > inetd.ahnlab

  if [ -f /etc/inetd.conf ]
    then
      if [ `ls -alL /etc/inetd.conf | awk '{print $1}' | grep '....------'| wc -l` -eq 1 ]
        then
          echo "��ȣ" >> inetd.ahnlab
        else
          echo "���" >> inetd.ahnlab
      fi
    else
      echo "" >> inetd.ahnlab
  fi

 if [ -f /etc/xinetd.conf ]
    then
      if [ `ls -alL /etc/xinetd.conf | awk '{print $1}' | grep '....------'| wc -l` -eq 0 ]
        then
          echo "���" >> inetd.ahnlab
        else
          echo "��ȣ" >> inetd.ahnlab
      fi
    else
      echo "" >> inetd.ahnlab
  fi
  echo " " >> $CREATE_FILE 2>&1

  if [ -d /etc/xinetd.d ]
    then
      if [ `ls -alL /etc/xinetd.d/* | awk '{print $1}' | grep '....------'| wc -l` -eq 0 ]
        then
          echo "���" >> inetd.ahnlab
        else
          echo "��ȣ" >> inetd.ahnlab
      fi
    else
      echo "" >> inetd.ahnlab
  fi

  if [ `cat inetd.ahnlab | grep "���" | wc -l` -eq 0 ]
    then
      echo "�� U_21. ��� : ��ȣ" >> $CREATE_FILE 2>&1
    else
      echo "�� U_21. ��� : ���" >> $CREATE_FILE 2>&1
  fi

  rm -rf inetd.ahnlab

  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_22() {
  echo -n "U_22. /etc/syslog.conf ���� ������ �� ���� ���� >>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_22. /etc/syslog.conf ���� ������ �� ���� ���� " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : /etc/syslog.conf ������ �����ڰ� root�̰�, ������ 644 ������ ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1


	if [ -f  /etc/syslog.conf ] #20160105-02 start 
	then
		echo '�� syslog.conf ���� ���� ' >>  $CREATE_FILE 2>&1
		ls -alL /etc/syslog.conf  >> $CREATE_FILE 2>&1
	else
		echo "/etc/syslog.conf ������ �����ϴ�"  >> $CREATE_FILE 2>&1
	fi
	echo " " >> $CREATE_FILE 2>&1
	if [ -f /etc/rsyslog.conf ]
	then
		echo '�� rsyslog.conf ���� ���� '  >> $CREATE_FILE 2>&1
		ls -alL /etc/rsyslog.conf >> $CREATE_FILE 2>&1
	else
		echo "/etc/rsyslog.conf ������ �����ϴ�"  >> $CREATE_FILE 2>&1
	fi
	echo " " >> $CREATE_FILE 2>&1
	if [ -f /etc/syslog-ng.conf ]
	then
		echo '�� syslog-ng.conf ���� ���� '  >> $CREATE_FILE 2>&1
		ls -alL /etc/syslog-ng.conf  >> $CREATE_FILE 2>&1
   else
		echo "/etc/syslog-ng.conf ������ �����ϴ�"  >> $CREATE_FILE 2>&1
	fi

	echo " " >> $CREATE_FILE 2>&1

	if [ -f /etc/syslog.conf ]
	then
		if [ `ls -alL /etc/syslog.conf | awk '{print $1}' | grep '...-.--.--' | wc -l` -eq 1 ]
			then
				echo "�� U_22. ��� : ��ȣ" >> $CREATE_FILE 2>&1
		else
			echo "�� U_22. ��� : ���" >> $CREATE_FILE 2>&1
		fi
	else if [ -f /etc/rsyslog.conf ]
	then 
		if [ `ls -alL /etc/rsyslog.conf | awk '{print $1}' | grep '...-.--.--' | wc -l` -eq 1 ]
			then
				echo "�� U_22. ��� : ��ȣ" >> $CREATE_FILE 2>&1
		else
			echo "�� U_22. ��� : ���" >> $CREATE_FILE 2>&1
		fi

	else if [ -f /etc/syslog-ng.conf ]
	then 
		if [ `ls -alL /etc/syslog-ng.conf | awk '{print $1}' | grep '...-.--.--' | wc -l` -eq 1 ]
			then
				echo "�� U_22. ��� : ��ȣ" >> $CREATE_FILE 2>&1
		else
			echo "�� U_22. ��� : ���" >> $CREATE_FILE 2>&1
		fi

	else
	echo "�� U_22. ��� : ��������" >> $CREATE_FILE 2>&1
	fi
	fi
	fi
#20160105-02 end 

  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_23() {
  echo -n "U_23. /etc/service ���� ������ �� ���� ����  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_23. /etc/service ���� ������ �� ���� ���� " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : /etc/service ������ �����ڰ� root�̰�, ������ 644 ������ ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  if [ -f  /etc/services ]
    then
	 echo "�� /etc/services ���� �۹̼� Ȯ��" >> $CREATE_FILE 2>&1
     echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1	
      ls -alL /etc/services  >> $CREATE_FILE 2>&1
    else
      echo " /etc/services ������ �����ϴ�"  >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

  if [ -f /etc/services ]
    then
      if [ `ls -alL /etc/services | awk '{print $1}' | grep '.....--.--' | wc -l` -eq 1 ]
        then
          echo "�� U_23. ��� : ��ȣ" >> $CREATE_FILE 2>&1
       else
          echo "�� U_23. ��� : ���" >> $CREATE_FILE 2>&1
      fi
    else
      echo "�� U_23. ��� : ��������" >> $CREATE_FILE 2>&1
  fi

  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_24() {
  echo -n "U_24. SUID, SGID, Sticky bit �������� ���� >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_24. SUID, SGID, Sticky bit �������� ���� " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : SUID, SGID, Sticky bit ������ �ο��� ������ �����Ͽ� ���ʿ��ϰ� �ο��� ������ ������� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  FILES="/sbin/dump /usr/bin/lpq-lpd /usr/bin/newgrp /sbin/restore /usr/bin/lpr /usr/sbin/lpc /sbin/unix_chkpwd /usr/bin/lpr-lpd /usr/sbin/lpc-lpd /usr/bin/at /usr/bin/lprm /usr/sbin/traceroute /usr/bin/lpq /usr/bin/lprm-lpd"

  for check_file in $FILES
    do
      if [ -f $check_file ]
        then
          if [ -g $check_file -o -u $check_file ]
            then
              echo `ls -alL $check_file` >> $CREATE_FILE 2>&1
            else
              echo $check_file "���Ͽ� SUID, SGID�� �ο��Ǿ� ���� �ʽ��ϴ�" >> $CREATE_FILE 2>&1
          fi
        else
          echo $check_file "�� �����ϴ�" >> $CREATE_FILE 2>&1
      fi
    done

  echo " " >> $CREATE_FILE 2>&1


  echo "setuid " > set.ahnlab

  FILES="/sbin/dump /usr/bin/lpq-lpd /usr/bin/newgrp /sbin/restore /usr/bin/lpr /usr/sbin/lpc /sbin/unix_chkpwd /usr/bin/lpr-lpd /usr/sbin/lpc-lpd /usr/bin/at /usr/bin/lprm /usr/sbin/traceroute /usr/bin/lpq /usr/bin/lprm-lpd"

  for check_file in $FILES
    do
      if [ -f $check_file ]
        then
          if [ `ls -alL $check_file | awk '{print $1}' | grep -i 's'| wc -l` -gt 0 ]
            then
              ls -alL $check_file |awk '{print $1}' | grep -i 's' >> set.ahnlab
            else
              echo " " >> set.ahnlab
          fi
      fi
    done

  if [ `cat set.ahnlab | awk '{print $1}' | grep -i 's' | wc -l` -gt 1 ]
    then
      echo "�� U_24. ��� : ���" >> $CREATE_FILE 2>&1
    else
      echo "�� U_24. ��� : ��ȣ" >> $CREATE_FILE 2>&1
  fi

  rm -rf set.ahnlab

  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_25() {
  echo -n "U_25. �����, �ý��� �������� �� ȯ������ ������ �� ���� ���� >>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_25. �����, �ý��� �������� �� ȯ������ ������ �� ���� ���� " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : Ȩ ���͸� ȯ�溯�� ���� �����ڰ� �ش� �������� �����Ǿ� �ְ�," >> $CREATE_FILE 2>&1
  echo "              Ȩ ���͸� ȯ�溯�� ���Ͽ� �����ڸ� ���� ������ �ο��Ǿ� �ִ� ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1


  echo " " >> $CREATE_FILE 2>&1
  HOMEDIRS=`cat /etc/passwd | awk -F":" 'length($6) > 0 {print $6}' | sort -u | grep -v '/bin/false' | grep -v 'nologin' | grep -v "#"`
  FILES=".profile .cshrc .kshrc .login .bash_profile .bashrc .bash_login .exrc .netrc .history .sh_history .bash_history .dtprofile"

  for file in $FILES
  do
    FILE=/$file
    if [ -f $FILE ]
      then
        ls -al $FILE >> $CREATE_FILE 2>&1
    fi
  done

  for dir in $HOMEDIRS
  do
    for file in $FILES
    do
      FILE=$dir/$file
        if [ -f $FILE ]
          then
          ls -al $FILE >> $CREATE_FILE 2>&1
        fi
    done
  done
  echo " " >> $CREATE_FILE 2>&1

  echo " " > home.ahnlab

  HOMEDIRS=`cat /etc/passwd | awk -F":" 'length($6) > 0 {print $6}' | sort -u | grep -v '/bin/false' | grep -v 'nologin' | grep -v "#"`
  FILES=".profile .cshrc .kshrc .login .bash_profile .bashrc .bash_login .exrc .netrc .history .sh_history .bash_history .dtprofile"

  for file in $FILES
    do
      if [ -f /$file ]
        then
          if [ `ls -alL /$file |  awk '{print $1}' | grep "........-." | wc -l` -eq 0 ]
            then
              echo "���" >> home.ahnlab
            else
              echo "��ȣ" >> home.ahnlab
          fi
        else
          echo "��ȣ" >> home.ahnlab
      fi
    done

  for dir in $HOMEDIRS
    do
      for file in $FILES
        do
          if [ -f $dir/$file ]
            then
              if [ `ls -al $dir/$file | awk '{print $1}' | grep "........-." | wc -l` -eq 0 ]
                then
                  echo "���" >> home.ahnlab
                else
                  echo "��ȣ" >> home.ahnlab
              fi
            else
              echo "��ȣ" >> home.ahnlab
          fi
        done
    done

  if [ `cat home.ahnlab | grep "���" | wc -l` -eq 0 ]
    then
      echo "�� U_25. ��� : ��ȣ" >> $CREATE_FILE 2>&1
    else
      echo "�� U_25. ��� : ���" >> $CREATE_FILE 2>&1
  fi

  rm -rf home.ahnlab


  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_26() {
  echo -n "U_26. world writable ���� ���� >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_26. world writable ���� ���� " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : world writable ���� ���� ���θ� Ȯ���ϰ�, ���� �� ���������� Ȯ���ϰ� �ִ� ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

for i in /home /tmp /etc /var #20160106-01 
	do
		find $i -name '*' -type d >> dir.txt   2>&1
done 

for D in `cat dir.txt`
	do
		find $D -perm -2 -ls | awk '{ print $3":"$5":"$6":"$11}' | grep -v ^l >>world.ahnlab  2>&1
			world=`ls -al world.ahnlab | awk '{print $5}'`
				if [ $world -gt 1000 ]
				then
					break 1 
				fi
done 

  if [ -s world.ahnlab ]
    then
	    cat world.ahnlab >> $CREATE_FILE 2>&1
    else
	  echo "�� World Writable ������ �ο��� ������ �߰ߵ��� �ʾҽ��ϴ�." >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

  if [ -s world.ahnlab ]
    then
      echo "�� U_26. ��� : ���" >> $CREATE_FILE 2>&1
    else
      echo "�� U_26. ��� : ��ȣ" >> $CREATE_FILE 2>&1
  fi

 rm -rf dir.txt  
  rm -rf world.ahnlab

  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_27() {
  echo -n "U_27. /dev�� �������� �ʴ� device ���� ���� >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_27. /dev�� �������� �ʴ� device ���� ���� " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : dev�� ���� ���� ���� �� �������� ���� device ������ ������ ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  echo "�� ��ݽü� ���˱��� ��� : find /dev -type f -exec ls -l {} \;" >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1 
  find /dev -type f -exec ls -l {} \; > dev-file.ahnlab

  if [ -s dev-file.ahnlab ]
    then
	  cat dev-file.ahnlab >> $CREATE_FILE 2>&1
    else
  	  echo "�� /dev �� �������� ���� Device ������ �߰ߵ��� �ʾҽ��ϴ�." >> $CREATE_FILE 2>&1
  fi
  
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "����̽� ����(charactor, block file) ���� : find /dev -type [C B] -exec ls -l {} \;  " >> $CREATE_FILE 2>&1
  echo "major, minor �ʵ忡 ���� �ùٸ��� ���� ��� ���  " >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1 
  find /dev -type c -exec ls -l {} \; > dev-file2.ahnlab
  find /dev -type b -exec ls -l {} \; > dev-file2.ahnlab
  
  if [ -s dev-file2.ahnlab ]
    then
	  cat dev-file2.ahnlab >> $CREATE_FILE 2>&1
    else
  	  echo "�� /dev �� charactor, block Device ������ �߰ߵ��� �ʾҽ��ϴ�." >> $CREATE_FILE 2>&1
  fi
  


  echo " " >> $CREATE_FILE 2>&1

  if [ -s dev-file.ahnlab ]
    then
      echo "�� U_27. ��� : ��������" >> $CREATE_FILE 2>&1
    else
      echo "�� U_27. ��� : ��ȣ" >> $CREATE_FILE 2>&1
  fi

  rm -rf dev-file.ahnlab
  rm -rf dev-file2.ahnlab

  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_28() {
  echo -n "U_28. $HOME/.rhosts, hosts.equiv ��� ���� >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_28. $HOME/.rhosts, hosts.equiv ������ " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : exec(512/tcp), login(513/tcp), shell(514/tcp)���񽺸� ������� �ʰų�, ��� �� �Ʒ��� ���� ������ ����� ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "              1. /etc/hosts.equiv �� $HOME/.rhosts ���� �����ڰ� root �Ǵ�, �ش� ������ ���" >> $CREATE_FILE 2>&1
  echo "              2. /etc/hosts.equiv �� $HOME/.rhosts ���� ������ 600 ������ ���" >> $CREATE_FILE 2>&1
  echo "              3. /etc/hosts.equiv �� $HOME/.rhosts ���� ������ '+' ������ ���� ���" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  SERVICE_INETD="shell|login|exec"

  echo "�� ���� ��Ʈ Ȱ��ȭ ���� Ȯ��" >> $CREATE_FILE 2>&1
  echo "------------------------- " >> $CREATE_FILE 2>&1
if [ `netstat -na | egrep ":512|:513|:514" | grep -i "listen" | grep -i "tcp" | wc -l` -ge 1 ]
  then
    netstat -na | egrep ":512|:513|:514" | grep -i "litsen" | grep -i "tcp" >> $CREATE_FILE 2>&1
    echo " " >> $CREATE_FILE 2>&1
    echo "r command Sevice Enable" >> $CREATE_FILE 2>&1
    echo "���" >> trust.ahnlab
    echo " " >> $CREATE_FILE 2>&1
  
  
  echo "�� /etc/xinetd.d ���� " >> $CREATE_FILE 2>&1
  echo "------------------------- " >> $CREATE_FILE 2>&1
if [ -d /etc/xinetd.d/ ]; then
  if [ `ls -alL /etc/xinetd.d/* | egrep $SERVICE_INETD |egrep -v "grep|klogin|kshell|kexec" | wc -l` -gt 0 ]
    then
      ls -alL /etc/xinetd.d/* | egrep $SERVICE_INETD  >> $CREATE_FILE 2>&1
    else
      echo "r ���񽺰� �������� ����" >> $CREATE_FILE 2>&1
  fi
fi
  echo " " >> $CREATE_FILE 2>&1
  echo "�� /etc/xinetd.d ���� " >> $CREATE_FILE 2>&1
  echo "---------------------- " >> $CREATE_FILE 2>&1
if [ -d /etc/xinetd.d/ ]; then 
  if [ `ls -alL /etc/xinetd.d | egrep $SERVICE_INETD | egrep -v "grep|klogin|kshell|kexec" | wc -l` -gt 0 ]
    then
      for VVV in `ls -alL /etc/xinetd.d | egrep $SERVICE_INETD | egrep -v "grep|klogin|kshell|kexec" | awk '{print $9}'`
      do
        echo " $VVV ����" >> $CREATE_FILE 2>&1
        cat /etc/xinetd.d/$VVV | grep -i "disable" >> $CREATE_FILE 2>&1
        echo "   " >> $CREATE_FILE 2>&1
      done
    else
      echo "xinetd.d���͸��� r �迭 ������ �����ϴ�" >> $CREATE_FILE 2>&1
  fi
fi
  echo " " >> $CREATE_FILE 2>&1

  SERVICE_INETD="rsh|rlogin|rexec|shell|login|exec"

  echo "�� inetd.conf ���Ͽ��� 'r' commnad ���� ���� ����" >> $CREATE_FILE 2>&1
  echo "----------------------------------------------------- " >> $CREATE_FILE 2>&1
  if [ -f /etc/inetd.conf ]
    then
      cat /etc/inetd.conf | grep -v '^ *#' | egrep $SERVICE_INETD | egrep -v "grep|klogin|kshell|kexec" >> $CREATE_FILE 2>&1
    else
      echo "/etc/inetd.conf ������ �������� �ʽ��ϴ�." >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

  if [ -d /etc/xinetd.d ]
    then
      if [ `ls -alL /etc/xinetd.d | egrep $SERVICE_INETD | egrep -v "grep|klogin|kshell|kexec" | wc -l` -gt 0 ]
        then
          for VVV in `ls -alL /etc/xinetd.d | egrep $SERVICE_INETD | egrep -v "grep|klogin|kshell|kexec" | awk '{print $9}'`
          do
            if [ `cat /etc/xinetd.d/$VVV | grep -i "disable" | grep -i "no" | wc -l` -gt 0 ]
              then
                echo "r command" > r_temp
              else
                echo "��ȣ" >> trust.ahnlab
            fi
          done
        else
          echo "��ȣ" >> trust.ahnlab
      fi
    elif [ -f /etc/inetd.conf ]
      then
        if [ `cat /etc/inetd.conf | grep -v '^ *#' | egrep $SERVICE_INETD | egrep -v "grep|klogin|kshell|kexec" |wc -l` -eq 0 ]
          then
            echo "��ȣ" >> trust.ahnlab
          else
            echo "r command" > r_temp
        fi
      else
        echo "��ȣ" >> trust.ahnlab
  fi


  HOMEDIRS=`cat /etc/passwd | awk -F":" 'length($6) > 0 {print $6}' | sort -u`
  FILES="/.rhosts"



  if [ -s r_temp ]
    then
	  echo "�� /etc/hosts.equiv ���� ��Ȳ " >> $CREATE_FILE 2>&1
	  echo "-------------------------------- " >> $CREATE_FILE 2>&1
      if [ -f /etc/hosts.equiv ]
        then
          ls -alL /etc/hosts.equiv >> $CREATE_FILE 2>&1
          echo " " >> $CREATE_FILE 2>&1
          echo "/etc/hosts.equiv ���� ���� ����" >> $CREATE_FILE 2>&1
          cat /etc/hosts.equiv >> $CREATE_FILE 2>&1
        else
          echo "/etc/hosts.equiv ������ �������� �ʽ��ϴ�." >> $CREATE_FILE 2>&1
      fi
    else
      echo " " >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

  if [ -s r_temp ]
    then
	  echo "�� $HOME/.rhosts ���� ��Ȳ " >> $CREATE_FILE 2>&1
	  echo "-------------------------------- " >> $CREATE_FILE 2>&1
      for dir in $HOMEDIRS
        do
          for file in $FILES
            do
              if [ -f $dir$file ]
                then
                  ls -alL $dir$file  >> $CREATE_FILE 2>&1
                  echo " " >> $CREATE_FILE 2>&1
                  echo "- $dir$file ���� ����" >> $CREATE_FILE 2>&1
                  cat $dir$file | grep -v "#" >> $CREATE_FILE 2>&1
                else
                  echo "����" >> nothing.ahnlab
              fi
            done
        done
    else
      echo " " >> $CREATE_FILE 2>&1
  fi

  if [ -f nothing.ahnlab ]
    then
      echo "/.rhosts ������ �������� �ʽ��ϴ�. " >> $CREATE_FILE 2>&1
  fi

  if [ -s r_temp ]
    then
      if [ -f /etc/hosts.equiv ]
        then
          if [ `ls -alL /etc/hosts.equiv |  awk '{print $1}' | grep "....------" | wc -l` -eq 1 ]
            then
              echo "��ȣ" >> trust.ahnlab
            else
              echo "���" >> trust.ahnlab
          fi
          if [ `cat /etc/hosts.equiv | grep "+" | grep -v "grep" | grep -v "#" | wc -l` -eq 0 ]
            then
              echo "��ȣ" >> trust.ahnlab
            else
              echo "���" >> trust.ahnlab
          fi
        else
          echo "��ȣ" >> trust.ahnlab
      fi
    else
      echo "��ȣ" >> trust.ahnlab
  fi


  if [ -s r_temp ]
    then
      for dir in $HOMEDIRS
	      do
	        for file in $FILES
	          do
	            if [ -f $dir$file ]
	              then
                  if [ `ls -alL $dir$file |  awk '{print $1}' | grep "....------" | wc -l` -eq 1 ]
                    then
                      echo "��ȣ" >> trust.ahnlab
                    else
                      echo "���" >> trust.ahnlab
                  fi
                  if [ `cat $dir$file | grep "+" | grep -v "grep" | grep -v "#" |wc -l ` -eq 0 ]
                    then
                      echo "��ȣ" >> trust.ahnlab
                    else
                      echo "���" >> trust.ahnlab
                  fi
                fi
            done
        done
    else
      echo "��ȣ" >> trust.ahnlab
  fi

  echo " " >> $CREATE_FILE 2>&1

  if [ `cat trust.ahnlab | grep "���" | wc -l` -eq 0 ]
    then
      echo "�� U_28. ��� : ��ȣ" >> $CREATE_FILE 2>&1
    else
      echo "�� U_28. ��� : ���" >> $CREATE_FILE 2>&1
  fi
else
    echo " " >> $CREATE_FILE 2>&1
    echo "r command Sevice Disable" >> $CREATE_FILE 2>&1
    echo " " >> $CREATE_FILE 2>&1
    echo "�� U_28. ��� : ��ȣ" >> $CREATE_FILE 2>&1
    echo " " >> $CREATE_FILE 2>&1
  fi

  rm -rf trust.ahnlab r_temp nothing.ahnlab

  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_29() {
  echo -n "U_29. ���� IP �� ��Ʈ ���� >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_29. ���� IP �� ��Ʈ ���� " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : /etc/hosts.deny ���Ͽ� ALL Deny ���� ��" >> $CREATE_FILE 2>&1
  echo "              /etc/hosts.allow ���Ͽ� ������ ����� Ư�� ȣ��Ʈ�� ����� ���" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  if [ -f /etc/hosts.deny ]
    then
      echo "�� /etc/hosts.deny ���� ����" >> $CREATE_FILE 2>&1
      cat /etc/hosts.deny >> $CREATE_FILE 2>&1
    else
      echo "/etc/hosts.deny ���� ����" >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

  if [ -f /etc/hosts.allow ]
    then
      echo "�� /etc/hosts.allow ���� ����" >> $CREATE_FILE 2>&1
      cat /etc/hosts.allow >> $CREATE_FILE 2>&1
    else
      echo "/etc/hosts.allow ���� ����" >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

  if [ -f /etc/hosts.deny ]
    then
      if [ `cat /etc/hosts.deny  | grep -v "#" | sed 's/ *//g' |  grep "ALL:ALL" |wc -l ` -gt 0 ]
        then
          echo "��ȣ" >> IP_ACL.ahnlab
        else
          echo "���" >> IP_ACL.ahnlab
      fi
    else
      echo "���" >> IP_ACL.ahnlab
  fi

  if [ -f /etc/hosts.allow ]
    then
      if [ `cat /etc/hosts.allow | grep -v "#" | sed 's/ *//g' | grep -v "^$" | grep -v "ALL:ALL" | wc -l ` -gt 0 ]
        then
          echo "��ȣ" >> IP_ACL.ahnlab
        else
          echo "���" >> IP_ACL.ahnlab
      fi
    else
      echo "���" >> IP_ACL.ahnlab
  fi


  if [ `cat IP_ACL.ahnlab | grep "���" | wc -l` -eq 0 ]
    then
      echo "�� U_29. ��� : ��ȣ" >> $CREATE_FILE 2>&1
    else
      echo "�� U_29. ��� : ���" >> $CREATE_FILE 2>&1
  fi


rm -rf IP_ACL.ahnlab


  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_30() {
  echo -n "U_30. hosts.lpd ���� ������ �� ���� ���� >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_30. hosts.lpd ���� ������ �� ���� ���� " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : ������ �����ڰ� root�̰� Other�� ���� ������ �ο��Ǿ� ���� �ʴ� ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  if [ -f /etc/hosts.lpd ]
    then
      ls -alL /etc/hosts.lpd  >> $CREATE_FILE 2>&1
		if [ `ls -alL /etc/hosts.lpd | awk '{print $1}' | grep '........-.' | wc -l` -eq 1 ]
        then
			 echo " " >> $CREATE_FILE 2>&1	
          echo "�� U_30. ��� : ��ȣ" >> $CREATE_FILE 2>&1
       else
			 
		    echo " " >> $CREATE_FILE 2>&1
          echo "�� U_30. ��� : ���" >> $CREATE_FILE 2>&1
      fi
	else
		echo "/etc/hosts.lpd ������ �����ϴ�"  >> $CREATE_FILE 2>&1
		echo " " >> $CREATE_FILE 2>&1	
      echo "�� U_30. ��� : ��ȣ" >> $CREATE_FILE 2>&1
  fi


  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_31() {
  echo -n "U_31. NIS ���� ��Ȱ��ȭ >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_31. NIS ���� ��Ȱ��ȭ " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : ���ʿ��� NIS ���񽺰� ��Ȱ��ȭ �Ǿ� �ִ� ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "              ������ ����ϴ� ��� ��ȣ(���� �� ���ͺ� ��)" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  SERVICE="ypserv|ypbind|ypxfrd|rpc.yppasswdd|rpc.ypupdated"

  if [ `ps -ef | egrep $SERVICE | grep -v "grep" | wc -l` -eq 0 ]
    then
      echo "�� NIS, NIS+ ���񽺰� ��������Դϴ�." >> $CREATE_FILE 2>&1
      echo " " >> $CREATE_FILE 2>&1
      echo "�� U_31. ��� : ��ȣ" >> $CREATE_FILE 2>&1
    else
      ps -ef | egrep $SERVICE | grep -v "grep" >> $CREATE_FILE 2>&1
      echo " " >> $CREATE_FILE 2>&1
      echo "�� NIS, NIS+ ���񽺰� ��������Դϴ�." >> $CREATE_FILE 2>&1
      echo " " >> $CREATE_FILE 2>&1
      echo "�� U_31. ��� : ���" >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_32() {
  echo -n "U_32. UMASK ���� ���� >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_32. UMASK ���� ���� " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : UMASK ���� 022 �̻����� ������ ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
 
 echo "�� UMASK ��ɾ�(root���� umask)  " >> $CREATE_FILE 2>&1
 echo "  " >> $CREATE_FILE 2>&1
 umask >> $CREATE_FILE 2>&1
 
 if [ `umask | awk -F"0" '$2 >= "22"' | wc -l` -eq 1 ]
		then
		  echo "��ȣ" >> umask.ahnlab
		else
		  echo "���" >> umask.ahnlab
 fi
 echo "  " >> $CREATE_FILE 2>&1
 
  echo "�� /etc/profile ����  " >> $CREATE_FILE 2>&1
  if [ -f /etc/profile ]
    then
      cat /etc/profile | grep -i umask >> $CREATE_FILE 2>&1
      if [ `cat /etc/profile | grep -i "umask" |grep -v "#" | awk -F"0" '$2 >= "22"' | wc -l` -eq 2 ]
      then
        echo "��ȣ" >> umask.ahnlab
      else
        echo "���" >> umask.ahnlab
      fi
    else
      echo "/etc/profile ������ �����ϴ�.(��������)" >> $CREATE_FILE 2>&1
  fi
  
  echo "�� /etc/bashrc ����  " >> $CREATE_FILE 2>&1
  if [ -f /etc/bashrc ]
    then
      cat /etc/bashrc | grep -i umask >> $CREATE_FILE 2>&1
      if [ `cat /etc/bashrc | grep -i "umask" |grep -v "#" | awk -F"0" '$2 >= "22"' | wc -l` -eq 2 ]
      then
        echo "��ȣ" >> umask.ahnlab
      else
        echo "���" >> umask.ahnlab
      fi
    else
      echo "/etc/bashrc ������ �����ϴ�.(��������)" >> $CREATE_FILE 2>&1
  fi

  echo "  " >> $CREATE_FILE 2>&1
  
  if [ `cat umask.ahnlab | grep "���" | wc -l` -eq 0 ]
    then
      echo "�� U_32. ��� : ��ȣ" >> $CREATE_FILE 2>&1
    else
      echo "�� U_32. ��� : ���" >> $CREATE_FILE 2>&1
  fi

 rm -rf umask.ahnlab

  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_33() {
  echo -n "U_33. Ȩ ���͸� ������ �� ���� ���� >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_33. Ȩ ���͸� ������ �� ���� ���� " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : Ȩ ���͸� �����ڰ� �ش� �����̰�, �Ϲ� ����� ���� ������ ���ŵ� ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  HOMEDIRS=`cat /etc/passwd | awk -F":" 'length($6) > 0 {print $6}' | sort -u | grep -v "#" | grep -v "/tmp" | grep -v "uucppublic" | grep -v "var" | grep -v "news" | uniq`
  
  for dir in $HOMEDIRS
    do
		if [ -d $dir ]; then
  	    ls -dal $dir | grep '\d.........' >> $CREATE_FILE 2>&1
		fi
    done
  echo " " >> $CREATE_FILE 2>&1

  echo " " > home.ahnlab
  HOMEDIRS=`cat /etc/passwd | awk -F":" 'length($6) > 0 {print $6}' | sort -u | grep -v "#" | grep -v "/tmp" | grep -v "uucppublic" | grep -v "var" | grep -v "news" | uniq`
  for dir in $HOMEDIRS
    do
      if [ -d $dir ]
        then
          if [ `ls -dal $dir |  awk '{print $1}' | grep "........-." | wc -l` -eq 1 ]
            then
              echo "��ȣ" >> home.ahnlab 
            else
              echo "���" >> home.ahnlab  
          fi
        else
          echo "��ȣ" >> home.ahnlab
      fi
    done

  echo " " >> $CREATE_FILE 2>&1

  if [ `cat home.ahnlab | grep "���" | wc -l` -eq 0 ]
    then
      echo "�� U_33. ��� : ��ȣ" >> $CREATE_FILE 2>&1
    else
      echo "�� U_33. ��� : ���" >> $CREATE_FILE 2>&1
  fi

  rm -rf home.ahnlab

  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_34() {
  echo -n "U_34. Ȩ ���͸��� ������ ���͸��� ���� ���� >>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_34. Ȩ ���͸��� ������ ���͸��� ���� ���� " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : Ȩ ���͸��� �������� �ʴ� ������ �߰ߵ��� ���� ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "��            root ������ ������ �Ϲ� ������ Ȩ ���͸��� '/'�� �ƴ� ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  echo "�� Ȩ ���͸��� �������� �ʴ� ��������Ʈ" >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1

  echo " " > DHOME_pan.ahnlab
  
  HOMEDIRS=`cat /etc/passwd | egrep -v -i "nologin|false" | awk -F":" 'length($6) > 0 {print $6}' | sort -u | grep -v "#" | grep -v "/tmp" | grep -v "uucppublic" | uniq`

  for dir in $HOMEDIRS
    do
	    if [ ! -d $dir ]
	      then
		      awk -F: '$6=="'${dir}'" { print "�� ������(Ȩ���͸�):"$1 "(" $6 ")" }' /etc/passwd >> $CREATE_FILE 2>&1
		      echo " " > Home.ahnlab
		    else
		      echo "����" > no_Home.ahnlab
	    fi
    done

  echo " " >> $CREATE_FILE 2>&1

  if [ ! -f no_Home.ahnlab ]
    then
		  echo "Ȩ ���͸��� �������� ���� ������ �߰ߵ��� �ʾҽ��ϴ�" >> $CREATE_FILE 2>&1
    else
		  rm -rf no_Home.ahnlab
  fi
  
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  
  echo "�� root ���� �� '/'�� Ȩ���͸��� ����ϴ� ��������Ʈ" >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1
  
  if [ `cat /etc/passwd | egrep -v -i "nologin|false" | grep -v root | awk -F":" 'length($6) > 0' | awk -F":" '$6 == "/"' | wc -l` -eq 0 ]
  then
        echo "root ���� �� '/'�� Ȩ ���͸��� ����ϴ� ������ �������� �ʽ��ϴ�." >> $CREATE_FILE 2>&1
  else
        cat /etc/passwd | egrep -v -i "nologin|false" | grep -v root | awk -F":" 'length($6) > 0' | awk -F":" '$6 == "/"' >> $CREATE_FILE 2>&1
        echo "���" >> DHOME_pan.ahnlab
  fi
        

  echo " " >> $CREATE_FILE 2>&1

  if [ ! -f Home.ahnlab ]
    then
      echo "��ȣ" >> DHOME_pan.ahnlab
    else
      echo "���" >> DHOME_pan.ahnlab
      rm -rf Home.ahnlab
  fi
  
  if [ `cat DHOME_pan.ahnlab | grep "���" | wc -l` -eq 0 ]
    then
      echo "�� U_34. ��� : ��ȣ" >> $CREATE_FILE 2>&1
    else
      echo "�� U_34. ��� : ���" >> $CREATE_FILE 2>&1
      
	  
  fi
  rm -rf DHOME_pan.ahnlab
  
	
	
  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_35() {
  echo -n "U_35. ������ ���� �� ���͸� �˻� �� ���� >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_35. ������ ���� �� ���͸� �˻� �� ���� " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : ���͸� �� ������ ������ Ȯ���Ͽ�, ���ʿ��� ���� ������ �Ϸ��� ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  echo "�� ������ ���� �� ���͸� ��Ȳ" >> $CREATE_FILE 2>&1
  echo "--------------------------------------------------------------------" >> $CREATE_FILE 2>&1

  find /tmp -name ".*" -ls > hidden-file.ahnlab
  find /home -name ".*" -ls >> hidden-file.ahnlab
  find /usr -name ".*" -ls >> hidden-file.ahnlab
  find /var -name ".*" -ls >> hidden-file.ahnlab

  echo " " >> $CREATE_FILE 2>&1

  if [ -s hidden-file.ahnlab ]
    then
      cat hidden-file.ahnlab >> $CREATE_FILE 2>&1
      echo " " >> $CREATE_FILE 2>&1
      echo "�� U_35. ��� : ��������" >> $CREATE_FILE 2>&1
      rm -rf hidden-file.ahnlab
    else
      echo "�� U_35. ��� :  ��ȣ" >> $CREATE_FILE 2>&1
  fi

  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_36() {
  echo -n "U_36. Finger ���� ��Ȱ��ȭ >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_36. Finger ���� ��Ȱ��ȭ " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : Finger ���񽺰� ��Ȱ��ȭ �Ǿ� �ִ� ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  SERVICE_INETD="finger"
  
  echo "�� finger ��Ʈ Ȱ��ȭ ����" >> $CREATE_FILE 2>&1
  echo "--------------------------------------" >> $CREATE_FILE 2>&1
  if [ `netstat -na | grep :79 | grep -i listen | wc -l` -ge 1 ]
	then
		echo "finger ���� ��Ʈ Ȱ��ȭ" >>$CREATE_FILE 2>&1
		echo "���" >> service.ahnlab
		echo " " >> $CREATE_FILE 2>&1
		echo " finger Service Enable" >> $CREATE_FILE 2>&1
	

  echo "�� inetd.conf ���Ͽ��� finger ����" >> $CREATE_FILE 2>&1
  echo "-------------------------------------- " >> $CREATE_FILE 2>&1
  if [ -f /etc/inetd.conf ]
  	then
	    cat /etc/inetd.conf | grep -v "^ *#" | egrep $SERVICE_INETD >> $CREATE_FILE 2>&1
	  else
	    echo "/etc/inetd.conf ���� �������� ����" >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  echo "�� /etc/xinetd.d ����" >> $CREATE_FILE 2>&1
  echo "-------------------------" >> $CREATE_FILE 2>&1
  if [ -d /etc/xinetd.d/ ]; then
   if [ `ls -alL /etc/xinetd.d/* | egrep $SERVICE_INETD | wc -l` -gt 0 ]
    then
      ls -alL /etc/xinetd.d/* | egrep $SERVICE_INETD  >> $CREATE_FILE 2>&1
    else
      echo "finger ���񽺰� �������� ����" >> $CREATE_FILE 2>&1
   fi
  fi
  
  echo " " >> $CREATE_FILE 2>&1
  echo "�� /etc/xinetd.d ���� " >> $CREATE_FILE 2>&1
  echo "------------------------" >> $CREATE_FILE 2>&1
  if [ -d /etc/xinetd.d ]; then
  if [ `ls -alL /etc/xinetd.d | egrep $SERVICE_INETD | wc -l` -gt 0 ]
    then
      for VVV in `ls -alL /etc/xinetd.d | egrep $SERVICE_INETD | grep -v "ssf" | awk '{print $9}'`
      do
        echo " $VVV ����" >> $CREATE_FILE 2>&1
        cat /etc/xinetd.d/$VVV | grep -i "disable" >> $CREATE_FILE 2>&1
        echo "   " >> $CREATE_FILE 2>&1
      done
    else
      echo "xinetd.d���͸��� finger ������ �����ϴ�" >> $CREATE_FILE 2>&1
  fi
  fi
  echo " " >> $CREATE_FILE 2>&1


  echo " " > service.ahnlab

  if [ -f /etc/inetd.conf ]
    then
      if [ `cat /etc/inetd.conf | grep -v '^ *#' | egrep $SERVICE_INETD | wc -l ` -eq 0 ]
        then
          echo "��ȣ" >> service.ahnlab
        else
          echo "���" >> service.ahnlab
      fi
    else
      echo "��ȣ" >> service.ahnlab
  fi

  if [ -d /etc/xinetd.d ]
    then
      if [ `ls -alL /etc/xinetd.d | egrep $SERVICE_INETD | wc -l` -gt 0 ]
        then
          for VVV in `ls -alL /etc/xinetd.d | egrep $SERVICE_INETD | grep -v "ssf" | awk '{print $9}'`
          do
            if [ `cat /etc/xinetd.d/$VVV | grep -i "disable" | grep -i "no" | wc -l` -gt 0 ]
              then
                echo "���" >> service.ahnlab
              else
                echo "��ȣ" >> service.ahnlab
            fi
          done
        else
          echo "��ȣ" >> service.ahnlab
      fi
    else
      echo "��ȣ" >> service.ahnlab
  fi
 
  
  echo  ' ' 	>> $CREATE_FILE 2>&1
  if [ `cat service.ahnlab | grep "���" | wc -l` -eq 0 ]
    then
      echo "�� U_36. ��� : ��ȣ" >> $CREATE_FILE 2>&1
    else
      echo "�� U_36. ��� : ���" >> $CREATE_FILE 2>&1
  fi
else
	echo "finger ���� ��Ʈ ��Ȱ��ȭ" >>$CREATE_FILE 2>&1
	echo " " >> $CREATE_FILE 2>&1
	echo " finger Service Disable" >> $CREATE_FILE 2>&1
	echo " " >> $CREATE_FILE 2>&1
	echo "�� U_36. ��� : ��ȣ" >> $CREATE_FILE 2>&1
		 
  fi
 
  rm -rf service.ahnlab

  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}

U_37() {
  echo -n "U_37. Anonymous FTP ��Ȱ��ȭ >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_37. Anonymous FTP ��Ȱ��ȭ " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : Anonymous FTP (�͸� ftp) ������ ������ ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "				      �⺻ FTP, ProFTP��� ftp���� ��������, vsFTP ��� �������Ͽ��� anonymous_enable �κ� Ȯ��" >>  $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  echo "�� FTP ���μ��� Ȱ��ȭ ����" >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1
  if [ `ps -ef | grep ftp  | grep -v grep | wc -l` -eq 0 ];then
    echo " " >> $CREATE_FILE 2>&1
    echo "�� ftp ���� �� ������ " >> $CREATE_FILE 2>&1
  else
    echo " " >> $CREATE_FILE 2>&1
    ps -ef | grep ftp  | grep -v grep >> $CREATE_FILE >> $CREATE_FILE 2>&1
    echo "�� ftp ���� ������ " >> $CREATE_FILE 2>&1
    
  fi
  
  if [ -f /etc/inetd.conf ]
    then
      if [ `cat /etc/inetd.conf | grep -v '#' | grep ftp  | grep -v "tftp" |  wc -l` -gt 0  ]
        then
          echo "ftp enable" >> ftpps.ahnlab
      fi
  fi

  ps -ef | grep ftp  | grep -v grep | grep -v "tftp" >> ftpps.ahnlab
  echo " " >> $CREATE_FILE 2>&1

  anony_vsftp="/etc/vsftpd/vsftpd.conf /etc/vsftpd.conf"
 
  echo "�� FTP Anonymous ���� ��Ȳ" >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1 
  if [ `cat ftpps.ahnlab | grep ftp | grep -v grep | wc -l` -gt 0 ]
    then
      if [ -f /etc/passwd ]
        then
    echo "�� /etc/passwd ���� ftp ���� ���翩��" >> $CREATE_FILE 2>&1
          cat /etc/passwd | grep "ftp" >> $CREATE_FILE 2>&1
        else
          echo "/etc/passwd ������ �����ϴ�. " >> $CREATE_FILE 2>&1
      fi  
   echo " " >> $CREATE_FILE 2>&1
   
   for file in $anony_vsftp
    do
    if [ -f $file ]
   then
     echo "�� "$file"���� �� anonymous enable ����" >> $CREATE_FILE 2>&1
     cat $file | grep -i "anonymous_enable" >> $CREATE_FILE 2>&1
    fi
    done 
    #vsftpd Ȯ�� �߰�
    
    else
      echo "�� ftp ���� �� ������ " >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1
  
  echo " " > anony.ahnlab

  if [ `cat ftpps.ahnlab | grep ftp | grep -v grep | wc -l` -gt 0 ]
    then
      if [ `grep -v "^ *#" /etc/passwd | grep "ftp" | wc -l` -gt 0 ]
        then
          echo "���" >> anony.ahnlab
      else
          echo "��ȣ" >> anony.ahnlab
      fi
   
   for file in $anony_vsftp
    do
    if [ -f $file ]
   then
     if [ `cat $file | grep -i "anonymous_enable" | grep -i "yes" | grep -v "#" | wc -l` -eq 0 ]
      then
        echo "��ȣ" >> anony.ahnlab
      else
        echo "���" >> anony.ahnlab
     fi
    fi
    done  
   #vsftp Ȯ�� �߰�
   
    else
      echo "��ȣ" >> anony.ahnlab
  fi

  if [ `cat anony.ahnlab | grep "���" | wc -l` -eq 0 ]
    then
      echo "�� U_37. ��� : ��ȣ" >> $CREATE_FILE 2>&1
    else
      echo "�� U_37. ��� : ���" >> $CREATE_FILE 2>&1
  fi
  

  rm -rf anony.ahnlab

    	


  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_38() {
  echo -n "U_38. r �迭 ���� ��Ȱ��ȭ  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_38. r �迭 ���� ��Ȱ��ȭ " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : r �迭 ���񽺰� ��Ȱ��ȭ �Ǿ� �ִ� ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  SERVICE_INETD="shell|login|exec|rsh|rlogin|rexec"
  
  echo "�� ���� ��Ʈ Ȱ��ȭ ���� Ȯ��" >> $CREATE_FILE 2>&1
  echo "------------------------- " >> $CREATE_FILE 2>&1
if [ `netstat -na | egrep ":512|:513|:514" | grep -i "litsen" | grep -i "tcp" | wc -l` -ge 1 ]
  then
    netstat -na | egrep ":512|:513|:514" | grep -i "litsen" | grep -i "tcp" >> $CREATE_FILE 2>&1
    echo " " >> $CREATE_FILE 2>&1
    echo "r command Sevice Enable" >> $CREATE_FILE 2>&1
    echo "���" >> test.s
    echo " " >> $CREATE_FILE 2>&1

  echo " " >> $CREATE_FILE 2>&1
  echo "�� /etc/xinetd.d ���� " >> $CREATE_FILE 2>&1
  echo "------------------------- " >> $CREATE_FILE 2>&1
if [ -d /etc/xinetd.d/ ]; then
  if [ `ls -alL /etc/xinetd.d/* | egrep $SERVICE_INETD |egrep -v "grep|klogin|kshell|kexec" | wc -l` -gt 0 ]
    then
      ls -alL /etc/xinetd.d/* | egrep $SERVICE_INETD  >> $CREATE_FILE 2>&1
    else
      echo "r ���񽺰� �������� ����" >> $CREATE_FILE 2>&1
  fi
fi
  echo " " >> $CREATE_FILE 2>&1
  echo "�� /etc/xinetd.d ���� " >> $CREATE_FILE 2>&1
  echo "---------------------- " >> $CREATE_FILE 2>&1
if [ -d /etc/xinetd.d ]; then
  if [ `ls -alL /etc/xinetd.d | egrep $SERVICE_INETD | egrep -v "grep|klogin|kshell|kexec" | wc -l` -gt 0 ]
    then
      for VVV in `ls -alL /etc/xinetd.d | egrep $SERVICE_INETD | egrep -v "grep|klogin|kshell|kexec" | awk '{print $9}'`
      do
        echo " $VVV ����" >> $CREATE_FILE 2>&1
        cat /etc/xinetd.d/$VVV | grep -i "disable" >> $CREATE_FILE 2>&1
        echo "   " >> $CREATE_FILE 2>&1
      done
    else
      echo "xinetd.d���͸��� r �迭 ������ �����ϴ�" >> $CREATE_FILE 2>&1
  fi
fi
  echo " " >> $CREATE_FILE 2>&1

  
  echo "�� inetd.conf ���Ͽ��� 'r' commnad ���� ���� ����" >> $CREATE_FILE 2>&1
  echo "----------------------------------------------------- " >> $CREATE_FILE 2>&1
  if [ -f /etc/inetd.conf ]
    then
      cat /etc/inetd.conf | grep -v '^ *#' | egrep $SERVICE_INETD | egrep -v "grep|klogin|kshell|kexec" >> $CREATE_FILE 2>&1
    else
      echo "/etc/inetd.conf ������ �������� �ʽ��ϴ�." >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

  if [ -d /etc/xinetd.d ]
    then
      if [ `ls -alL /etc/xinetd.d | egrep $SERVICE_INETD | egrep -v "grep|klogin|kshell|kexec" | wc -l` -gt 0 ]
        then
          for VVV in `ls -alL /etc/xinetd.d | egrep $SERVICE_INETD | egrep -v "grep|klogin|kshell|kexec" | awk '{print $9}'`
          do
            if [ `cat /etc/xinetd.d/$VVV | grep -i "disable" | grep -i "no" | wc -l` -gt 0 ]
              then
						
                echo "���"  >> test.s
                
              else
                echo "��ȣ" >> test.s
            fi
          done
        else
          echo "��ȣ" >> test.s
      fi
    elif [ -f /etc/inetd.conf ]
      then
        if [ `cat /etc/inetd.conf | grep -v '^ *#' | egrep $SERVICE_INETD | egrep -v "grep|klogin|kshell|kexec" |wc -l` -eq 0 ]
          then
            echo "��ȣ" >> test.s
          else
            echo "���" >> test.s
            
        fi
      else
        echo "��ȣ" >> test.s
  fi
	
if [ -f test.s ];then
  if [ `cat test.s | grep "���" | wc -l` -eq 0 ]
    then
      echo "�� U_38. ��� : ��ȣ" >> $CREATE_FILE 2>&1
    else
      echo "�� U_38. ��� : ���" >> $CREATE_FILE 2>&1
  fi
fi


else
    echo " " >> $CREATE_FILE 2>&1
    echo "r command Sevice Disable" >> $CREATE_FILE 2>&1
    echo " " >> $CREATE_FILE 2>&1
    echo "�� U_28. ��� : ��ȣ" >> $CREATE_FILE 2>&1
    echo " " >> $CREATE_FILE 2>&1
  fi
  
  rm -rf r_temp
  rm -rf test.s

  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_39() {
  echo -n "U_39. cron ���� ������ �� ���� ����  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_39. cron ���� ������ �� ���� ���� " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : cron ���� �����ڰ� root�̰�, ������ 640 ������ ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "              �ΰ��� ���� ��� ���� ��� OS �������� ��Ʈ�� ����� �� �ִ� ���� ��� ����ڰ� ����� �� �ִ� ��찡 �����Ƿ� ����� Ȯ�� �ʿ�" >>  $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  crons="/etc/crontab /etc/cron.daily/* /etc/cron.hourly/* /etc/cron.monthly/* /etc/cron.weekly/* /var/spool/cron/*"
  crond="/etc/cron.deny /etc/cron.allow"

  echo "�� Cron ���μ��� Ȱ��ȭ ����" >> $CREATE_FILE 2>&1
  echo "----------------------------" >> $CREATE_FILE 2>&1 
  if [ `ps -ef | grep cron | grep -v grep | wc -l` -ge 1 ];then
    ps -ef | grep cron | grep -v grep >> $CREATE_FILE 2>&1
	  echo " " >> $CREATE_FILE 2>&1
	  echo "�� cron Service Enable"  >> $CREATE_FILE 2>&1
	  echo " " >> $CREATE_FILE 2>&1
	   
  echo "�� Cron ���� ����  " >> $CREATE_FILE 2>&1
  echo "----------------------------" >> $CREATE_FILE 2>&1
   for check_dir in $crons
   do
    if [ -f $check_dir ]
      then
        ls -alL $check_dir >> $CREATE_FILE 2>&1
      else
        echo $check_dir "�� �����ϴ�" >> $CREATE_FILE 2>&1
    fi
  done
  echo " " >>$CREATE_FILE 2>&1
  echo "�� Cron.allow, Cron.deny ���� ����" >> $CREATE_FILE 2>&1
  echo "----------------------------" >> $CREATE_FILE 2>&1
	for check_dir in $crond
   do
    if [ -f $check_dir ]
      then
        ls -alL $check_dir >> $CREATE_FILE 2>&1
			if [ `cat $check_dir | wc -l` -ge 1 ]
			then
				echo "-----------------------" >> $CREATE_FILE 2>&1
				echo $check_dir'������ ����'>>$CREATE_FILE 2>&1
				cat $check_dir >> $CREATE_FILE 2>&1
				echo " " >>$CREATE_FILE 2>&1
			else
				echo "-----------------------" >> $CREATE_FILE 2>&1
				echo $check_dir"������ �������">> $CREATE_FILE 2>&1
        echo " " >>$CREATE_FILE 2>&1
				echo "���" >> crontab.ahnlab
			fi
    else
      echo $check_dir"������ �����ϴ�" >> $CREATE_FILE 2>&1
    fi
  done

  echo " " >> $CREATE_FILE 2>&1

  echo " " > crontab.ahnlab
     
  for check_dir in $crons
  do
	if [ -f $check_dir ] 
	then
    if [  `ls -alL $check_dir | awk '{print $1}' |grep  '.......---' |wc -l` -eq 0 ]
      then
        echo "���" >> crontab.ahnlab
      else
        echo "��ȣ" >> crontab.ahnlab
    fi
	fi
  done

  for check_dir in $crond
  do
	if [ -f $check_dir ] 
	then
    if [  `ls -alL $check_dir | awk '{print $1}' |grep  '.......---' |wc -l` -eq 0 ]
      then
        echo "���" >> crontab.ahnlab
      else
			if [ `cat $check_dir | wc -l` -ge 1 ]
			then 
        		echo "��ȣ" >> crontab.ahnlab
			else
				echo "���" >> crontab.ahnlab
			fi
	  fi
	fi
  done
else
 	echo "�� cron Service Disable"  >> $CREATE_FILE 2>&1
	echo " " >> $CREATE_FILE 2>&1
	echo "��ȣ" >> crontab.ahnlab
fi	
  echo " " >> $CREATE_FILE 2>&1

  if [ `cat crontab.ahnlab | grep "���" | wc -l` -eq 0 ]
    then
      echo "�� U_39. ��� : ��ȣ" >> $CREATE_FILE 2>&1
    else
      echo "�� U_39. ��� : ���" >> $CREATE_FILE 2>&1
  fi



  rm -rf crontab.ahnlab

  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_40() {
  echo -n "U_40. DoS ���ݿ� ����� ���� ��Ȱ��ȭ  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_40. DoS ���ݿ� ����� ���� ��Ȱ��ȭ " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : DoS ���ݿ� ����� echo, discard, daytime, chargen ���񽺰� ��Ȱ��ȭ �� ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  SERVICE_INETD="echo|discard|daytime|chargen"


  echo "�� inetd.conf ���Ͽ��� echo, discard, daytime, chargen ����" >> $CREATE_FILE 2>&1
  echo "----------------------------------------------------------- " >> $CREATE_FILE 2>&1
	if [ -f /etc/inetd.conf ]
  	then
	    cat /etc/inetd.conf | grep -v "^ *#" | egrep $SERVICE_INETD >> $CREATE_FILE 2>&1
	  else
	    echo "/etc/inetd.conf ���� �������� ����" >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  echo "�� /etc/xinetd.d ����" >> $CREATE_FILE 2>&1
  echo "-------------------------" >> $CREATE_FILE 2>&1
if [ -d /etc/xinetd.d/ ]; then
  if [ `ls -alL /etc/xinetd.d/* | egrep $SERVICE_INETD | wc -l` -gt 0 ]
    then
      ls -alL /etc/xinetd.d/* | egrep $SERVICE_INETD  >> $CREATE_FILE 2>&1
    else
      echo "DoS ���ݿ� ����� ���񽺰� �������� ����" >> $CREATE_FILE 2>&1
  fi
fi
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  
  echo "�� /etc/xinetd.d ���� " >> $CREATE_FILE 2>&1
  echo "------------------------" >> $CREATE_FILE 2>&1
if [ -d /etc/xinetd.d ]; then
  if [ `ls -alL /etc/xinetd.d | egrep $SERVICE_INETD | wc -l` -gt 0 ]
    then
      for VVV in `ls -alL /etc/xinetd.d | egrep $SERVICE_INETD | grep -v "ssf" | awk '{print $9}'`
      do
        echo " $VVV ����" >> $CREATE_FILE 2>&1
        cat /etc/xinetd.d/$VVV | grep -i "disable" >> $CREATE_FILE 2>&1
        echo "   " >> $CREATE_FILE 2>&1
      done
    else
      echo "xinetd.d ���͸��� DoS�� ����� ���� ������ �����ϴ�" >> $CREATE_FILE 2>&1
  fi
fi
  echo " " >> $CREATE_FILE 2>&1


  echo " " > service.ahnlab

  if [ -f /etc/inetd.conf ]
    then
      if [ `cat /etc/inetd.conf | grep -v '^ *#' | egrep $SERVICE_INETD | wc -l ` -eq 0 ]
        then
          echo "��ȣ" >> service.ahnlab
        else
          echo "���" >> service.ahnlab
      fi
    else
      echo "��ȣ" >> service.ahnlab
  fi

  if [ -d /etc/xinetd.d ]
    then
      if [ `ls -alL /etc/xinetd.d | egrep $SERVICE_INETD | wc -l` -gt 0 ]
        then
          for VVV in `ls -alL /etc/xinetd.d | egrep $SERVICE_INETD | grep -v "ssf" | awk '{print $9}'`
          do
            if [ `cat /etc/xinetd.d/$VVV | grep -i "disable" | grep -i "no" | wc -l` -gt 0 ]
              then
                echo "���" >> service.ahnlab
              else
                echo "��ȣ" >> service.ahnlab
            fi
          done
        else
          echo "��ȣ" >> service.ahnlab
      fi
    else
      echo "��ȣ" >> service.ahnlab
  fi


  if [ `cat service.ahnlab | grep "���" | wc -l` -eq 0 ]
    then
      echo "�� U_40. ��� : ��ȣ" >> $CREATE_FILE 2>&1
    else
      echo "�� U_40. ��� : ���" >> $CREATE_FILE 2>&1
  fi

  rm -rf service.ahnlab

  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_41() {
  echo -n "U_41. NFS ���� ��Ȱ��ȭ  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_41. NFS ���� ��Ȱ��ȭ " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "�� ���˱��� : NFS ���� ���� ������ ��Ȱ��ȭ �Ǿ� �ִ� ��� ��ȣ" >> $CREATE_FILE 2>&1 
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1 
  echo " " >> $CREATE_FILE 2>&1 
 
  echo "�� NFS Server Daemon(nfsd)Ȯ��" >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1

  if [ `ps -ef | grep "nfsd" | egrep -v "statdaemon|automountd|emi" | grep -v "grep" | wc -l` -gt 0 ] 
    then
      ps -ef | grep "nfsd" | egrep -v "statdaemon|automountd|emi" | grep -v "grep" >> $CREATE_FILE 2>&1
      echo "���" >> nfs-A.ahnlab
		echo "�� NFS Service Enable" >> $CREATE_FILE 2>&1
    else
      echo "�� NFS Service Disable" >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

  echo "�� NFS Client Daemon(statd,lockd)Ȯ��" >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1

  if [ `ps -ef | egrep "statd|lockd" | egrep -v "grep|emi|statdaemon|dsvclockd" | wc -l` -gt 0 ] 
    then
      ps -ef | egrep "statd|lockd" | egrep -v "grep|emi|statdaemon|dsvclockd" >> $CREATE_FILE 2>&1
      echo "���" >> nfs-A.ahnlab
    else
      echo "�� NFS Client(statd,lockd) Disable" >> $CREATE_FILE 2>&1
  fi


  echo " " >> $CREATE_FILE 2>&1


  if [ `cat nfs-A.ahnlab | grep "���" | wc -l` -eq 0 ]
    then
      echo "�� U_41. ��� : ��ȣ" >> $CREATE_FILE 2>&1
    else
      echo "�� U_41. ��� : ���" >> $CREATE_FILE 2>&1
  fi

  rm -rf nfs-A.ahnlab
 
  result="�Ϸ�" 
  echo " " >> $CREATE_FILE 2>&1 
  echo " " >> $CREATE_FILE 2>&1 
  echo "[$result]" 
  echo " " 
}


U_42() {
  echo -n "U_42. NFS ��������  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_42. NFS �������� " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : NFS ���񽺸� ������� �ʰų�, ��� �� everyone ������ ������ ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

   ps -ef | grep "nfsd" | egrep -v "grep|statdaemon|automountd" | grep -v "grep" >> $CREATE_FILE 2>&1  #20160106-01 
  echo " " >> $CREATE_FILE 2>&1 
   
  if [ `ps -ef | grep "nfsd" | egrep -v "grep|statdaemon|automountd" | grep -v "grep" | wc -l` -eq 0 ] 
    then
		  echo "�� NFS Service Disable" >> $CREATE_FILE 2>&1
		  echo " " >> $CREATE_FILE 2>&1 
		  echo "�� U_42. ��� : ��ȣ" >> $CREATE_FILE 2>&1 
	else 
		if [ -f /etc/exports ]; then
			echo "/etc/exports ������ ����" >> $CREATE_FILE 2>&1
			if [ `cat /etc/exports | wc -l` -ge 1 ]; then
				cat /etc/exports  >> $CREATE_FILE 2>&1 
				echo " " >> $CREATE_FILE 2>&1
				echo "�� U_42. ��� : ��������" >> $CREATE_FILE 2>&1 
			else
				echo "/etc/exports ������ �������" >> $CREATE_FILE 2>&1
				echo " " >> $CREATE_FILE 2>&1
				echo "�� U_42. ��� : ���" >> $CREATE_FILE 2>&1 
			fi
		else 
			echo "/etc/exports ������ �������� �ʽ��ϴ�"  >> $CREATE_FILE 2>&1
			echo " " >> $CREATE_FILE 2>&1			
			echo "�� U_42. ��� : ���" >> $CREATE_FILE 2>&1 
		fi 
	fi 
	
	rm -rf nfs_export.txt
	
  result="�Ϸ�" 
  echo " " >> $CREATE_FILE 2>&1 
  echo " " >> $CREATE_FILE 2>&1 
  echo "[$result]" 
  echo " " 

}


U_43() {
  echo -n "U_43. automountd ����  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_43. automountd ���� " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : automountd ���񽺰� ��Ȱ��ȭ �Ǿ� �ִ� ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  echo "�� Automount ���� Ȯ�� " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  ps -ef | egrep 'automountd|autofs' | grep -v "grep" | egrep -v "grep|statdaemon|emi" >> $CREATE_FILE 2>&1

  echo " " >> $CREATE_FILE 2>&1
 # ls -al /etc/rc*.d/* | grep -i "auto" | grep "/S" >> $CREATE_FILE 2>&1

  echo " " >> $CREATE_FILE 2>&1

  if [ `ps -ef | egrep 'automountd|autofs' | grep -v "grep" | egrep -v "grep|statdaemon|emi"  | wc -l` -eq 0 ]
    then
      echo "automount ������ �����ϴ�." >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1


  if [ `ps -ef | egrep 'automountd|autofs' | grep -v "grep" | egrep -v "grep|statdaemon|emi" | wc -l` -eq 0 ]
    then
      echo "�� U_43. ��� : ��ȣ" >> $CREATE_FILE 2>&1
    else
      echo "�� U_43. ��� : ���" >> $CREATE_FILE 2>&1
  fi

  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_44() {
  echo -n "U_44. RPC ���� Ȯ��  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_44. RPC ���� Ȯ�� " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : ���ʿ��� RPC ���񽺰� ��Ȱ��ȭ �Ǿ� �ִ� ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1


  SERVICE_INETD="rpc.cmsd|rpc.ttdbserverd|sadmind|ruserd|walld|sprayd|rstatd|rpc.nisd|rexd|rpc.pcnfsd|rpc.statd|rpc.ypupdated|rpc.rquotad|kcms_server|cachefsd"

  echo "�� inetd.conf ���Ͽ��� RPC ���� ���� ����" >> $CREATE_FILE 2>&1
  echo "---------------------------------------------- " >> $CREATE_FILE 2>&1
	if [ -f /etc/inetd.conf ]
  	then
	    cat /etc/inetd.conf | grep -v "^ *#" | egrep $SERVICE_INETD >> $CREATE_FILE 2>&1
	  else
	    echo "/etc/inetd.conf ���� �������� ����" >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  

  echo "�� /etc/xinetd.d ����" >> $CREATE_FILE 2>&1
  echo "--------------------------" >> $CREATE_FILE 2>&1

  if [ -d /etc/xinetd.d ]
    then
      if [ `ls -alL /etc/xinetd.d/* | egrep $SERVICE_INETD | wc -l` -eq 0 ]
        then
          echo "/etc/xinetd.d RPC ���񽺰� ����" >> $CREATE_FILE 2>&1
        else
          ls -alL /etc/xinetd.d/* | egrep $SERVICE_INETD >> $CREATE_FILE 2>&1
      fi
    else
      echo "/etc/xinetd.d ���丮�� �������� �ʽ��ϴ�. " >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  echo "�� /etc/xinetd.d ���� " >> $CREATE_FILE 2>&1
  echo "---------------------" >> $CREATE_FILE 2>&1
if [ -d /etc/xinetd.d ]; then
  if [ `ls -alL /etc/xinetd.d | egrep $SERVICE_INETD | wc -l` -gt 0 ]
    then
      for VVV in `ls -alL /etc/xinetd.d | egrep $SERVICE_INETD | grep -v "ssf" | awk '{print $9}'`
      do
        echo " $VVV ����" >> $CREATE_FILE 2>&1
        cat /etc/xinetd.d/$VVV | grep -i "disable" >> $CREATE_FILE 2>&1
        echo "   " >> $CREATE_FILE 2>&1
      done
    else
      echo "xinetd.d�� ������ �����ϴ�" >> $CREATE_FILE 2>&1
  fi
fi

  echo " " > rpc.ahnlab

  SERVICE_INETD="rpc.cmsd|rpc.ttdbserverd|sadmind|ruserd|walld|sprayd|rstatd|rpc.nisd|rexd|rpc.pcnfsd|rpc.statd|rpc.ypupdated|rpc.rquotad|kcms_server|cachefsd"

  echo " " >> $CREATE_FILE 2>&1

  if [ -f /etc/inetd.conf ]
    then
      if [ `cat /etc/inetd.conf | grep -v '^ *#' | egrep $SERVICE_INETD | wc -l ` -eq 0 ]
        then
          echo "��ȣ" >> rpc.ahnlab
        else
          echo "���" >> rpc.ahnlab
      fi
    else
      echo "��ȣ" >> rpc.ahnlab
  fi

  if [ -d /etc/xinetd.d ]
    then
      if [ `ls -alL /etc/xinetd.d | egrep $SERVICE_INETD | wc -l` -gt 0 ]
        then
          for VVV in `ls -alL /etc/xinetd.d | egrep $SERVICE_INETD | grep -v "ssf" | awk '{print $9}'`
          do
            if [ `cat /etc/xinetd.d/$VVV | grep -i "disable" | grep -i "no" | wc -l` -gt 0 ]
              then
                echo "���" >> rpc.ahnlab
              else
                echo "��ȣ" >> rpc.ahnlab
            fi
          done
        else
          echo "��ȣ" >> rpc.ahnlab
      fi
    else
      echo "��ȣ" >> rpc.ahnlab
  fi

  if [ `cat rpc.ahnlab | grep "���" | wc -l` -eq 0 ]
    then
      echo "�� U_44. ��� : ��ȣ" >> $CREATE_FILE 2>&1
    else
      echo "�� U_44. ��� : ���" >> $CREATE_FILE 2>&1
  fi

  rm -rf rpc.ahnlab

  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_45() {
  echo -n "U_45. NIS, NIS+ ����  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_45. NIS, NIS+ ���� " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : NIS ���񽺰� ��Ȱ��ȭ �Ǿ� �ְų�, �ʿ� �� NIS+�� ����ϴ� ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  SERVICE="ypserv|ypbind|ypxfrd|rpc.yppasswdd|rpc.ypupdated"

  if [ `ps -ef | egrep $SERVICE | grep -v "grep" | wc -l` -eq 0 ]
    then
	    echo "�� NIS, NIS+ Service Disable" >> $CREATE_FILE 2>&1
    else
	    ps -ef | egrep $SERVICE | grep -v "grep" >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

  if [ `ps -ef | egrep $SERVICE | grep -v "grep" | wc -l` -eq 0 ]
    then
      echo "�� U_45. ��� : ��ȣ" >> $CREATE_FILE 2>&1
    else
      echo "�� U_45. ��� : ���" >> $CREATE_FILE 2>&1
  fi

  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_46() {
  echo -n "U_46. tffp, talk ���� ��Ȱ��ȭ  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_46. tftp, talk ���� ��Ȱ��ȭ " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : tftp, talk, ntalk ���񽺰� ��Ȱ��ȭ �Ǿ� �ִ� ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  SERVICE_INETD="tftp|talk|ntalk"


  echo "�� inetd.conf ���Ͽ��� tftp, talk ����" >> $CREATE_FILE 2>&1
  echo "-------------------------------------- " >> $CREATE_FILE 2>&1
	if [ -f /etc/inetd.conf ]
  	then
	    cat /etc/inetd.conf | grep -v "^ *#" | egrep $SERVICE_INETD >> $CREATE_FILE 2>&1
	  else
	    echo "/etc/inetd.conf ���� �������� ����" >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  echo "�� /etc/xinetd.d ����" >> $CREATE_FILE 2>&1
  echo "-------------------------" >> $CREATE_FILE 2>&1
 
  if [ -d /etc/xinetd.d/ ]; then
 	 if [ `ls -alL /etc/xinetd.d/* | egrep $SERVICE_INETD | wc -l` -gt 0 ]
  	  then
  	    ls -alL /etc/xinetd.d/* | egrep $SERVICE_INETD  >> $CREATE_FILE 2>&1
  	  else
   	   echo "tftp, talk ���񽺰� �������� ����" >> $CREATE_FILE 2>&1
  	fi
  fi

  echo " " >> $CREATE_FILE 2>&1
  echo "�� /etc/xinetd.d ���� " >> $CREATE_FILE 2>&1
  echo "-----------------------" >> $CREATE_FILE 2>&1
 if [ -d /etc/xinetd.d ]; then
  if [ `ls -alL /etc/xinetd.d | egrep $SERVICE_INETD | wc -l` -gt 0 ]
    then
      for VVV in `ls -alL /etc/xinetd.d | egrep $SERVICE_INETD | grep -v "ssf" | awk '{print $9}'`
      do
        echo " $VVV ����" >> $CREATE_FILE 2>&1
        cat /etc/xinetd.d/$VVV | grep -i "disable" >> $CREATE_FILE 2>&1
        echo "   " >> $CREATE_FILE 2>&1
      done
    else
      echo "xinetd.d ���͸��� tftp, talk, ntalk ������ �����ϴ�" >> $CREATE_FILE 2>&1
  fi
 fi
  echo " " >> $CREATE_FILE 2>&1
  
  echo "�� tftp, talk, ntalk ���μ��� Ȱ��ȭ ����" >> $CREATE_FILE 2>&1
  echo "-------------------------------------- " >> $CREATE_FILE 2>&1

  if [ `ps -ef | egrep $SERVICE_INETD | grep -v grep | wc -l` -gt 0 ]
    then
      ps -ef | egrep $SERVICE_INETD | grep -v grep  >> $CREATE_FILE 2>&1
		echo ' ' >> service.ahnlab
	  echo "���" >> service.ahnlab
    else
      echo "�� tftp, talk, ntalk ���μ����� ���������� ����" >> $CREATE_FILE 2>&1
	  echo "��ȣ" >> service.ahnlab
  fi


  echo " " > service.ahnlab

  if [ -f /etc/inetd.conf ]
    then
      if [ `cat /etc/inetd.conf | grep -v '^ *#' | egrep $SERVICE_INETD | wc -l ` -eq 0 ]
        then
          echo "��ȣ" >> service.ahnlab
        else
          echo "���" >> service.ahnlab
      fi
    else
      echo "��ȣ" >> service.ahnlab
  fi

  if [ -d /etc/xinetd.d ]
    then
      if [ `ls -alL /etc/xinetd.d | egrep $SERVICE_INETD | wc -l` -gt 0 ]
        then
          for VVV in `ls -alL /etc/xinetd.d | egrep $SERVICE_INETD | grep -v "ssf" | awk '{print $9}'`
          do
            if [ `cat /etc/xinetd.d/$VVV | grep -i "disable" | grep -i "no" | wc -l` -gt 0 ]
              then
                echo "���" >> service.ahnlab
              else
                echo "��ȣ" >> service.ahnlab
            fi
          done
        else
          echo "��ȣ" >> service.ahnlab
      fi
    else
      echo "��ȣ" >> service.ahnlab
  fi
  echo " " >> $CREATE_FILE 2>&1
	
  if [ `cat service.ahnlab | grep "���" | wc -l` -eq 0 ]
    then
		echo "�� U_46. ��� : ��ȣ" >> $CREATE_FILE 2>&1
    else
		echo "�� U_46. ��� : ���" >> $CREATE_FILE 2>&1
  fi

  rm -rf service.ahnlab


  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}

U_47() {
  echo -n "U_47. Sendmail ���� ����  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_47. Sendmail ���� ���� " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : Sendmail ������ 8.13.8 �̻��� ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  echo "�� Sendmail ���μ��� Ȯ��" >> $CREATE_FILE 2>&1
  echo "-------------------------------------- " >> $CREATE_FILE 2>&1
  if [ `ps -ef | grep sendmail | grep -v "grep" | wc -l` -eq 0 ]
    then
      echo "�� Sendmail Service Disable" >> $CREATE_FILE 2>&1
    else
      ps -ef | grep sendmail | grep -v "grep" >> $CREATE_FILE 2>&1
      echo " " >> $CREATE_FILE 2>&1
   #   ls -al /etc/rc*.d/* | grep -i sendmail | grep "/S" >> $CREATE_FILE 2>&1
      echo " " >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

  if [ -f /etc/mail/sendmail.cf ]
    then
	  echo "�� /etc/mail/sendmail.cf ���� �� ���� Ȯ��" >> $CREATE_FILE 2>&1
	  echo "-------------------------------------- " >> $CREATE_FILE 2>&1
      grep -v '^ *#' /etc/mail/sendmail.cf | grep DZ >> $CREATE_FILE 2>&1
  else if [ -f /etc/sendmail.cf ]
    then
	  echo "�� /etc/sendmail.cf ���� �� ���� Ȯ��" >> $CREATE_FILE 2>&1
	  grep -v '^ *#' /etc/sendmail.cf | grep DZ >> $CREATE_FILE 2>&1
  else
      echo "/etc/mail/sendmail.cf, /etc/sendmail.cf ���� ����" >> $CREATE_FILE 2>&1
  fi
  fi

  echo " " >> $CREATE_FILE 2>&1
  
  if [ `ps -ef | grep sendmail | grep -v "grep" | wc -l` -eq 0 ]
    then
      echo "�� U_47. ��� : ��ȣ" >> $CREATE_FILE 2>&1
    else
      if [ -f /etc/mail/sendmail.cf ]
        then
          if [ `grep -v '^ *#' /etc/mail/sendmail.cf | grep -i dz | awk -F'.' '{print $2}'` -ge 14 ]
            then
					echo "�� U_47. ��� : ��ȣ" >> $CREATE_FILE 2>&1

        elif [ `grep -v '^ *#' /etc/mail/sendmail.cf | grep -i dz | awk -F'.' '{print $2}'` -eq 13 ]
				then
					if [ `grep -v '^ *#' /etc/mail/sendmail.cf | grep -i dz | awk -F'.' '{print $3}'` -ge 8 ]
						then
							echo "�� U_47. ��� : ��ȣ" >> $CREATE_FILE 2>&1
            		else
              			echo "�� U_47. ��� : ���" >> $CREATE_FILE 2>&1
          		fi
		
			fi
	   else if [ -f /etc/sendmail.cf ]
	     then
			  if [ `grep -v '^ *#' /etc/sendmail.cf | grep -i dz | awk -F'.' '{print $2}'` -ge 14 ]
            then
					echo "�� U_47. ��� : ��ȣ" >> $CREATE_FILE 2>&1

     	   elif [ `grep -v '^ *#' /etc/sendmail.cf | grep -i dz | awk -F'.' '{print $2}'` -eq 13 ]
				then
					if [ `grep -v '^ *#' /etc/sendmail.cf | grep -i dz | awk -F'.' '{print $3}'` -ge 8 ]
						then
				  			echo "�� U_47. ��� : ��ȣ" >> $CREATE_FILE 2>&1
            		else
              			echo "�� U_47. ��� : ���" >> $CREATE_FILE 2>&1
          		fi
		 	fi
       else
          echo "�� U_47. ��� : ��������" >> $CREATE_FILE 2>&1
      fi
	 fi
  fi

  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}



U_48() {
  echo -n "U_48. ���� ���� ������ ����  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_48. ���� ���� ������ ���� " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : SMTP ���񽺸� ������� �ʰų� ������ ������ �����Ǿ� �ִ� ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  echo "�� Sendmail ���μ��� Ȯ��" >> $CREATE_FILE 2>&1
  echo "-------------------------------------- " >> $CREATE_FILE 2>&1
  if [ `ps -ef | grep sendmail | grep -v "grep" | wc -l` -eq 0 ]
    then
      echo "�� Sendmail Service Disable" >> $CREATE_FILE 2>&1
    else
      ps -ef | grep sendmail | grep -v "grep" >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1



  echo " " >> $CREATE_FILE 2>&1

  echo "�� /etc/mail/sendmail.cf ������ �ɼ� Ȯ��" >> $CREATE_FILE 2>&1
  echo "-------------------------------------- " >> $CREATE_FILE 2>&1
  if [ -f /etc/mail/sendmail.cf ]
    then
      cat /etc/mail/sendmail.cf | grep "R$\*" | grep "Relaying denied" >> $CREATE_FILE 2>&1
    else
      echo "/etc/mail/sendmail.cf ���� ����" >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

  if [ `ps -ef | grep sendmail | grep -v "grep" | wc -l` -eq 0 ]
    then
      echo "�� U_48. ��� : ��ȣ" >> $CREATE_FILE 2>&1
    else
      if [ -f /etc/mail/sendmail.cf ]
        then
          if [ `cat /etc/mail/sendmail.cf | grep -v "^#" | grep "R$\*" | grep -i "Relaying denied" | wc -l ` -gt 0 ]
            then
              echo "�� U_48. ��� : ��ȣ" >> $CREATE_FILE 2>&1
            else
              echo "�� U_48. ��� : ���" >> $CREATE_FILE 2>&1
          fi
        else
          echo "�� U_48. ��� : ��������" >> $CREATE_FILE 2>&1
      fi
  fi


  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_49() {
  echo -n "U_49. �Ϲݻ������ Sendmail ���� ����  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_49. �Ϲݻ������ Sendmail ���� ���� " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : SMTP ���� �̻�� �Ǵ�, �Ϲ� ������� Sendmail ���� ������ ���� �� ��� ��ȣ(restrictqrun �ɼ� Ȯ��)" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  echo "�� Sendmail ���μ��� Ȯ��" >> $CREATE_FILE 2>&1
  echo "-------------------------------------- " >> $CREATE_FILE 2>&1
  if [ `ps -ef | grep sendmail | grep -v "grep" | wc -l` -eq 0 ]
    then
      echo "�� Sendmail Service Disable" >> $CREATE_FILE 2>&1
    else
      ps -ef | grep sendmail | grep -v "grep" >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1



  echo " " >> $CREATE_FILE 2>&1

  echo "�� /etc/mail/sendmail.cf ������ �ɼ� Ȯ��" >> $CREATE_FILE 2>&1
  echo "-------------------------------------- " >> $CREATE_FILE 2>&1
  if [ -f /etc/mail/sendmail.cf ]
    then
      grep -v '^ *#' /etc/mail/sendmail.cf | grep PrivacyOptions >> $CREATE_FILE 2>&1
    else
      echo "/etc/mail/sendmail.cf ���� ����" >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

  if [ `ps -ef | grep sendmail | grep -v "grep" | wc -l` -eq 0 ]
    then
      echo "�� U_49. ��� : ��ȣ" >> $CREATE_FILE 2>&1
    else
      if [ -f /etc/mail/sendmail.cf ]
        then
          if [ `cat /etc/mail/sendmail.cf | grep -i "restrictqrun" | grep -v "#" |wc -l ` -eq 1 ]
            then
              echo "�� U_49. ��� : ��ȣ" >> $CREATE_FILE 2>&1
            else
              echo "�� U_49. ��� : ���" >> $CREATE_FILE 2>&1
          fi
        else
          echo "�� U_49. ���  : ��������" >> $CREATE_FILE 2>&1
      fi
  fi

  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_50() {
  echo -n "U_50. DNS ���� ���� ��ġ  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_50. DNS ���� ���� ��ġ " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : DNS ���񽺸� ������� �ʰų� �ֱ������� ��ġ�� �����ϰ� �ִ� ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� ������� : BIND 9.0.x ~ 9.9.8, BIND 9.10.0 ~ 9.10.3"  >> $CREATE_FILE 2>&1
  echo "�� �ֽŹ��� : BIND 9.9.8-P2, 9.10.3-P2, 9.9.8-S3�� ������Ʈ " >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  DNSPR=`ps -ef | egrep -i "/named|/in.named" | grep -v "grep" | awk 'BEGIN{ OFS="\n"} {i=1; while(i<=NF) {print $i; i++}}'| grep "/" | uniq`
  DNSPR=`echo $DNSPR | awk '{print $1}'`

  if [ `ps -ef | egrep -i "/named|/in.named" | grep -v grep | wc -l` -gt 0 ]
    then
      if [ -f $DNSPR ]
        then
          echo "BIND ���� Ȯ��" >> $CREATE_FILE 2>&1
          echo "--------------" >> $CREATE_FILE 2>&1
          $DNSPR -v | grep BIND >> $CREATE_FILE 2>&1
        else
          echo "$DNSPR ���� ����" >> $CREATE_FILE 2>&1
      fi
    else
      echo "�� DNS Service Disable" >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1


  if [ `ps -ef | egrep -i "/named|/in.named" | grep -v "grep" | wc -l` -eq 0 ]
    then
      echo "�� U_50. ��� : ��ȣ" >> $CREATE_FILE 2>&1
    else
      if [ -f $DNSPR ]
        then
          if [ `$DNSPR -v | grep BIND | egrep '8.4.6 | 8.4.7 | 9.2.8-P1 | 9.3.4-P1 | 9.4.1-P1 | 9.5.0a6' | wc -l` -gt 0 ]
            then
              echo "�� U_50. ��� : ��ȣ" >> $CREATE_FILE 2>&1
            else
              echo "�� U_50. ��� : ���" >> $CREATE_FILE 2>&1
          fi
        else
          echo "�� U_50. ��� : ��������" >> $CREATE_FILE 2>&1
      fi
  fi


  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_51() {
  echo -n "U_51. DNS Zone Transfer ����  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_51. DNS Zone Transfer ���� " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : DNS ���� �̻�� �Ǵ�, Zone Transfer�� �㰡�� ����ڿ��Ը� ����� ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "              allow-transfer ���� none �Ǵ� Ư�� IP�� ���� ���־����� Ȯ��" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  echo "�� DNS ���μ��� Ȯ�� " >> $CREATE_FILE 2>&1
  echo "-------------------------------------- " >> $CREATE_FILE 2>&1
  if [ `ps -ef | egrep -i "/named|/in.named" | grep -v "grep" | wc -l` -eq 0 ]
    then
      echo "�� DNS Service Disable" >> $CREATE_FILE 2>&1
    else
      ps -ef | grep named | grep -v "grep" >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

  #ls -al /etc/rc*.d/* | grep -i named | grep "/S" >> $CREATE_FILE 2>&1

  echo " " >> $CREATE_FILE 2>&1

  echo "�� /etc/named.conf ������ allow-transfer Ȯ��" >> $CREATE_FILE 2>&1
  echo "-------------------------------------- " >> $CREATE_FILE 2>&1
    if [ -f /etc/named.conf ]
      then
	    if [ `cat /etc/named.conf | grep -i 'allow-transfer' | wc -l` -eq 0 ]
		 then
		   echo "/etc/named.conf ���� �� allow-transfer ���� ����" >> $CREATE_FILE 2>&1
		 else
		   cat /etc/named.conf | grep 'allow-transfer' >> $CREATE_FILE 2>&1
	    fi
      else
        echo "/etc/named.conf ���� ����" >> $CREATE_FILE 2>&1
   fi

  echo " " >> $CREATE_FILE 2>&1

  echo "�� /etc/named.boot ������ xfrnets Ȯ��" >> $CREATE_FILE 2>&1
  echo "-------------------------------------- " >> $CREATE_FILE 2>&1
    if [ -f /etc/named.boot ]
      then
	    if [ `cat /etc/named.boot | grep "\xfrnets" | wc -l` -eq 0 ]
		 then
		   echo "/etc/named.boot ���� �� xfrnets ���� ����" >> $CREATE_FILE 2>&1
		 else
		   cat /etc/named.boot | grep "\xfrnets" >> $CREATE_FILE 2>&1
		fi
      else
        echo "/etc/named.boot ���� ����" >> $CREATE_FILE 2>&1
    fi
	echo  " " >> $CREATE_FILE 2>&1
	
		
		 
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  if [ `ps -ef | egrep -i "/named|/in.named" | grep -v "grep" | wc -l` -eq 0 ]
    then
      echo "�� U_51. ��� : ��ȣ" >> $CREATE_FILE 2>&1
    else
      if [ -f /etc/named.conf ]
        then
          if [ `cat /etc/named.conf | egrep -i "\allow-transfer.*[0-256].[0-256].[0-256].[0-256].*|none" | grep -v "#" | wc -l` -eq 0 ]
            then
              echo "�� U_51. ��� : ���" >> $CREATE_FILE 2>&1
            else
              echo "�� U_51. ��� : ��ȣ" >> $CREATE_FILE 2>&1
          fi
        else
          if [ -f /etc/named.boot ]
            then
              if [ `cat /etc/named.boot | egrep -i "\xfrnets.*[0-256].[0-256].[0-256].[0-256].*|none" | grep -v "#" | wc -l` -eq 0 ]
                then
                  echo "�� U_51. ��� : ���" >> $CREATE_FILE 2>&1
                else
                  echo "�� U_51. ��� : ��ȣ" >> $CREATE_FILE 2>&1
              fi
           else
              echo "�� U_51. ��� : ��������" >> $CREATE_FILE 2>&1
          fi
      fi
  fi

  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_52() {
  echo -n "U_52. Apache ���͸� ������ ����  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_52. Apache ���͸� ������ ���� " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : ���͸� �˻� ����� ������� �ʴ� ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  if [ $web = 'httpd' ];then
		
		if [ `cat $conf |grep -i Indexes | grep -i -v '\-Indexes' | grep -v '\#'|wc -l` -eq 0 ]; then
			echo ' ' >> $CREATE_FILE 2>&1
			echo '�� Indexes �ɼ��� ���� �Ǿ� ����' >> $CREATE_FILE 2>&1
			echo ' ' >> $CREATE_FILE 2>&1
			echo "�� U_52. ��� : ��ȣ" >> $CREATE_FILE 2>&1
		else
			cat $conf |grep -i Indexes| grep -i -v '\-Indexes' | grep -v '\#' >> $CREATE_FILE 2>&1
			echo ' ' >> $CREATE_FILE 2>&1
			echo '�� Indexes �ɼ��� ���� �Ǿ� ���� ����' >> $CREATE_FILE 2>&1
			echo ' ' >> $CREATE_FILE 2>&1
			echo "�� U_52. ��� : ���" >> $CREATE_FILE 2>&1
		fi

  elif [ $web = 'apache2' ];then
	
		if [ `cat "$apache"sites-available/default |grep -i Indexes | grep -i -v '\-Indexes' | grep -v '\#'|wc -l` -eq 0 ]; then
			echo ' ' >> $CREATE_FILE 2>&1
			echo '�� Indexes �ɼ��� ���� �Ǿ� ����' >> $CREATE_FILE 2>&1
			echo ' ' >> $CREATE_FILE 2>&1
			echo "�� U_52. ��� : ��ȣ" >> $CREATE_FILE 2>&1
		else
			cat "$apache"sites-available/default |grep -i Indexes| grep -i -v '\-Indexes' | grep -v '\#' >> $CREATE_FILE 2>&1
			echo ' ' >> $CREATE_FILE 2>&1
			echo '�� Indexes �ɼ��� ���� �Ǿ� ���� ����' >> $CREATE_FILE 2>&1
			echo ' ' >> $CREATE_FILE 2>&1
			echo "�� U_52. ��� : ���" >> $CREATE_FILE 2>&1
		fi
  else
	echo '�� �� ���񽺰� ���������� ����' >> $CREATE_FILE 2>&1
	echo ' ' >> $CREATE_FILE 2>&1
	echo "�� U_52. ��� :  ��ȣ" >> $CREATE_FILE 2>&1
fi


  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_53() {
  echo -n "U_53. Apache �� ���μ��� ���� ���� >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_53. Apache �� ���μ��� ���� ���� " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : Apache ������ root �������� �������� �ʴ� ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  if [ $web = 'httpd' ];then
	if [ `ps -ef | grep httpd | grep -v grep | wc -l` -gt 0 ]; then
		if [ `ps -ef | grep httpd | grep -v grep | grep -v root | wc -l` -eq 0 ]; then
			ps -ef | grep httpd | grep -v grep | grep -v root >>  $CREATE_FILE 2>&1
			echo ' ' >>  $CREATE_FILE 2>&1
			echo '�� root��������  Apache ���񽺸� ������' >> $CREATE_FILE 2>&1
			echo ' ' >> $CREATE_FILE 2>&1
			cat $conf | egrep "User |Group " | grep -v '#' >> $CREATE_FILE 2>&1
			echo ' ' >> $CREATE_FILE 2>&1
			echo "�� U_53. ��� : ���" >> $CREATE_FILE 2>&1
		else
			ps -ef | grep httpd | grep -v grep >>  $CREATE_FILE 2>&1
			echo ' ' >> $CREATE_FILE 2>&1
			echo '�� root��������  Apache ���񽺸� �������� ����' >> $CREATE_FILE 2>&1
			echo ' ' >> $CREATE_FILE 2>&1
			echo $conf'������ ���� ����' >> $CREATE_FILE 2>&1
			echo '------------------------' >> $CREATE_FILE 2>&1
			cat $conf | egrep "User |Group " | grep -v '#' >> $CREATE_FILE 2>&1
			echo '------------------------' >> $CREATE_FILE 2>&1
			echo ' ' >> $CREATE_FILE 2>&1
			echo "�� U_53. ��� : ��ȣ" >> $CREATE_FILE 2>&1
		fi
	fi

elif [ $web = 'apache2' ];then
	if [ `ps -ef | grep apache2 | grep -v grep | wc -l` -gt 0 ]; then
		if [ `ps -ef | grep apache2 | grep -v grep | grep -v root | wc -l` -eq 0 ]; then
			ps -ef | grep apache2 | grep -v grep | grep -v root >>  $CREATE_FILE 2>&1
			echo ' ' >>  $CREATE_FILE 2>&1
			echo '�� root��������  Apache ���񽺸� ������' >> $CREATE_FILE 2>&1
			echo ' ' >> $CREATE_FILE 2>&1
			cat $conf | egrep "User |Group " | grep -v '#' >> $CREATE_FILE 2>&1
			echo ' ' >> $CREATE_FILE 2>&1
			echo "�� U_53. ��� : ���" >> $CREATE_FILE 2>&1
		else
			ps -ef | grep apache2 | grep -v grep >>  $CREATE_FILE 2>&1
			echo ' ' >> $CREATE_FILE 2>&1
			echo '�� root��������  Apache ���񽺸� �������� ����' >> $CREATE_FILE 2>&1
			echo ' ' >> $CREATE_FILE 2>&1
			echo $conf'������ ���� ����' >> $CREATE_FILE 2>&1
			echo '------------------------' >> $CREATE_FILE 2>&1
			cat $conf | egrep "User |Group " | grep -v '#' >> $CREATE_FILE 2>&1
			echo '------------------------' >> $CREATE_FILE 2>&1
			echo ' ' >> $CREATE_FILE 2>&1
			echo "�� U_53. ��� : ��ȣ" >> $CREATE_FILE 2>&1
		fi
	fi
else
	echo '�� �� ���񽺰� ���������� ����' >> $CREATE_FILE 2>&1
	echo ' ' >> $CREATE_FILE 2>&1
	echo "�� U_52. ��� :  ��ȣ" >> $CREATE_FILE 2>&1	
fi
  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_54() {
  echo -n "U_54. Apache ���� ���͸� ���� ���� >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_54. Apache ���� ���͸� ���� ���� " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : ���� ���͸��� �̵� ������ ������ ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  if [ $web = 'httpd' ];then
	if [ `cat $conf | grep -i 'AllowOverride' | grep -v '#' | grep -i "None" | wc -l` -eq 0 ];then
		echo '�� AuthConfig �ɼ� �����Ǿ� ����'>> $CREATE_FILE 2>&1
		echo ' ' >>  $CREATE_FILE 2>&1
		echo "�� U_54. ��� : ��ȣ" >> $CREATE_FILE 2>&1
	else
		cat $conf| grep -i 'AllowOverride' | grep -v '#' >> $CREATE_FILE 2>&1
		echo ' ' >> $CREATE_FILE 2>&1
		echo '�� AuthConfig �ɼ� �����Ǿ� ���� ����' >> $CREATE_FILE 2>&1
		echo ' ' >>  $CREATE_FILE 2>&1
		echo "�� U_54. ��� : ���" >> $CREATE_FILE 2>&1
	fi

  elif [ $web = 'apache2' ];then
	if [ `cat "$apache"sites-available/default |grep AllowOverride| grep -v '#'| grep -i "None" | wc -l` -eq 0 ];then
	    cat "$apache"sites-available/default |grep AllowOverride|grep -v '\#' >> $CREATE_FILE 2>&1
			echo ' ' >> $CREATE_FILE 2>&1
			echo '�� AuthConfig �ɼ� �����Ǿ� ����' >>$CREATE_FILE 2>&1
			echo ' ' >>  $CREATE_FILE 2>&1
			echo "�� U_54. ��� : ��ȣ" >> $CREATE_FILE 2>&1
		else
			cat "$apache"sites-available/default |grep AllowOverride|grep -v '\#' >> $CREATE_FILE 2>&1
			echo ' ' >> $CREATE_FILE 2>&1
			echo '�� AuthConfig �ɼ� �����Ǿ� ���� ����' >>$CREATE_FILE 2>&1
			echo ' ' >>  $CREATE_FILE 2>&1
			echo "�� U_54. ��� : ���" >> $CREATE_FILE 2>&1
	fi
 else
	echo '�� �� ���񽺰� ���������� ����' >> $CREATE_FILE 2>&1
	echo ' ' >> $CREATE_FILE 2>&1
    echo "�� U_52. ��� :  ��ȣ" >> $CREATE_FILE 2>&1
  fi
  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_55() {
  echo -n "U_55. Apache ���ʿ��� ���� ���� >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_55. Apache ���ʿ��� ���� ���� " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : �޴��� ���� �� ���͸��� ���ŵǾ� �ִ� ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

if [ `ps -ef | egrep "httpd|apache2" | grep -v grep | wc -l` -ge 1 ]
then
	if [ -d "$docroot"/../ ]; then
	  	if [ `ls -l "$docroot"/../ | grep 'manual' |wc -l` -eq 0 ]; then
			echo '�� Manual ���丮�� �������� ����' >> $CREATE_FILE 2>&1
			echo ' ' >>  $CREATE_FILE 2>&1
			echo "�� U_55. ��� : ��ȣ" >> $CREATE_FILE 2>&1
	
 		else
			ls -l "$docroot"/../ | grep 'manual' >> $CREATE_FILE 2>&1
			echo ' ' >> $CREATE_FILE 2>&1
			echo '�� Manual ���丮��  ������' >>  $CREATE_FILE 2>&1
			echo ' ' >>  $CREATE_FILE 2>&1
			echo "�� U_55. ��� : ���" >> $CREATE_FILE 2>&1
		fi
	fi
	if [ -d "$docroot"/../htdocs/ ]; then 
		if [ `ls -l "$docroot"/../htdocs/ | grep 'manual' |wc -l` -eq 0 ]; then
			echo '�� Manual ���丮�� �������� ����' >> $CREATE_FILE 2>&1
			echo ' ' >>  $CREATE_FILE 2>&1
			echo "�� U_55. ��� : ��ȣ" >> $CREATE_FILE 2>&1
	
 		else
			ls -l "$docroot"/../htdocs/ | grep 'manual' >> $CREATE_FILE 2>&1
			echo ' ' >>  $CREATE_FILE 2>&1
			echo '�� Manual ���丮��  ������' >>  $CREATE_FILE 2>&1
			echo ' ' >>  $CREATE_FILE 2>&1
			echo "�� U_55. ��� : ���" >> $CREATE_FILE 2>&1
		fi
	fi
   echo " " >> $CREATE_FILE 2>&1
else  
   echo '�� �� ���񽺰� ���������� ����' >> $CREATE_FILE 2>&1
	echo ' ' >> $CREATE_FILE 2>&1
    echo "�� U_52. ��� :  ��ȣ" >> $CREATE_FILE 2>&1
fi
  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_56() {
  echo -n "U_56. Apache ��ũ ������ >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_56. Apache ��ũ ������ " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : �ɺ��� ��ũ, aliases ����� ������ ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  if [ $web = 'httpd' ];then
	if [ `cat $conf | grep -i 'FollowSymLinks' | grep -i -v '\-FollowSymLinks' | grep -v '#' | wc -l` -eq 0 ];then
		echo '�� Apache ��ũ ��� �������� �������� ����' >> $CREATE_FILE 2>&1
		echo ' ' >>  $CREATE_FILE 2>&1
		echo "�� U_56. ��� : ��ȣ" >> $CREATE_FILE 2>&1
	else
		cat  $conf | grep -i 'FollowSymLinks' | grep -i -v '\-FollowSymLinks' | grep -v '\#' >> $CREATE_FILE 2>&1
		echo ' ' >> $CREATE_FILE 2>&1
		echo '�� Apache ��ũ ��� �������� ����' >> $CREATE_FILE 2>&1
		echo ' ' >>  $CREATE_FILE 2>&1
		echo "�� U_56. ��� : ���" >> $CREATE_FILE 2>&1
	fi
  elif [ $web = 'apache2' ];then
	if [ `cat "$apache"sites-available/default | grep -i 'FollowSymLinks'| grep -i -v '\-FollowSymLinks' | grep -v '#'| wc -l` -eq 0 ]; then
			echo ' ' >> $CREATE_FILE 2>&1
			echo '�� Apache ��ũ ��� �������� �������� ����' >> $CREATE_FILE 2>&1
			echo ' ' >>  $CREATE_FILE 2>&1
			echo "�� U_56. ��� : ��ȣ" >> $CREATE_FILE 2>&1
		else
			cat "$apache"sites-available/default |grep -i 'FollowSymLinks' | grep -i -v '\FollowSymLinks' | grep -v '\#' >> $CREATE_FILE 2>&1
			echo ' ' >> $CREATE_FILE 2>&1
			echo '�� Apache ��ũ ��� �������� ����' >> $CREATE_FILE 2>&1
			echo ' ' >>  $CREATE_FILE 2>&1
			echo "�� U_56. ��� : ���" >> $CREATE_FILE 2>&1
	fi
  
  echo " " >> $CREATE_FILE 2>&1  
  else
	echo '�� �� ���񽺰� ���������� ����' >> $CREATE_FILE 2>&1
	echo ' ' >> $CREATE_FILE 2>&1
  	echo "�� U_52. ��� :  ��ȣ" >> $CREATE_FILE 2>&1
  fi 
  


  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_57() {
  echo -n "U_57. Apache ���� ���ε� �� �ٿ�ε� ���� >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_57. Apache ���� ���ε� �� �ٿ�ε� ���� " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : ���� ���ε� �� �ٿ�ε带 ������ ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  if [ $web = 'httpd' ];then
	
	if [ `cat $conf | grep -i LimitRequestBody | grep -v "#" | wc -l` -eq 0 ];then
		
		echo '�� ���� ���ε� �� �ٿ�ε� ���� ������ ����' >> $CREATE_FILE 2>&1
		echo ' ' >>  $CREATE_FILE 2>&1
		echo "�� U_57. ��� : ���" >> $CREATE_FILE 2>&1
		
	else
		cat $conf | grep -i 'LimitRequestBody' >> $CREATE_FILE 2>&1
		
		echo '�� ���� ���ε� �� �ٿ�ε� ���� ������' >> $CREATE_FILE 2>&1
		echo ' ' >>  $CREATE_FILE 2>&1
		echo "�� U_57. ��� : ��ȣ" >> $CREATE_FILE 2>&1
		
	fi
   elif [ $web = 'apache2' ];then
	if [ `cat "$apache"sites-available/default |grep LimitRequestBody| grep -v '#'| wc -l` -eq 0 ]; then
			
			echo '�� ���� ���ε� �� �ٿ�ε� ���� ������ ����' >> $CREATE_FILE 2>&1
			echo ' ' >>  $CREATE_FILE 2>&1
			echo "�� U_57. ��� : ��������" >> $CREATE_FILE 2>&1
		else
			cat "$apache"sites-available/default |grep LimitRequestBody|grep -v '#' >> $CREATE_FILE 2>&1
			
			echo '�� Apache ��ũ ��� �������� ����' >> $CREATE_FILE 2>&1
			echo ' ' >>  $CREATE_FILE 2>&1
			echo "�� U_57. ��� : ��ȣ" >> $CREATE_FILE 2>&1
	fi
  
  echo " " >> $CREATE_FILE 2>&1
  else 
	echo '�� �� ���񽺰� ���������� ����' >> $CREATE_FILE 2>&1
	echo ' ' >> $CREATE_FILE 2>&1
  	echo "�� U_52. ��� :  ��ȣ" >> $CREATE_FILE 2>&1
  fi
  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_58() {
  echo -n "U_58. Apache �� ���� ������ �и� >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_58. Apache �� ���� ������ �и� " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : DocumentRoot�� ������ ���͸��� ������ ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "              �⺻ ���(/usr/local/apache/htdocs, /usr/local/apache2/htdocs, /var/www/html, /opt/hpws/apache/htdocs ��)��� ���� Ȯ��" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  
  dir="/usr/local/apache/htdocs /usr/local/apache2/htdocs /var/www/html /opt/hpws/apache/htdocs"
  

if [ $web = 'httpd' ];then
  if [ -f $conf ]
	then
		echo '�� Apache DocumentRoot ���' >> $CREATE_FILE 2>&1
		echo ' ' >> $CREATE_FILE 2>&1
		cat $conf | grep -i 'DocumentRoot'  | grep -v '#'>> $CREATE_FILE 2>&1
		echo ' ' >> $CREATE_FILE 2>&1
		for d in $dir
		do
			if [ `cat "$conf" | grep -i 'DocumentRoot' | grep -v '#' | grep -i "$d" | wc -l` -eq 0 ]
			then
				echo "��ȣ" >> webdir.ahnlab
			else
				echo "���" >> webdir.ahnlab
			fi
		done
   fi
   if [ `cat webdir.ahnlab | grep "���" | wc -l` -gt 0 ]
    then
	  echo "�� �⺻��� �����" >> $CREATE_FILE 2>&1
	  echo " " >> $CREATE_FILE 2>&1	
      echo "�� U_58. ��� : ���" >> $CREATE_FILE 2>&1
    else
      echo "�� U_58. ��� : ��ȣ" >> $CREATE_FILE 2>&1
  fi
  rm -rf webdir.ahnlab
   
elif [ $web = 'apache2' ];then
	 if [ -d $apache ]
	  then		
		echo '�� Apache DocumentRoot ���' >> $CREATE_FILE 2>&1
		echo ' ' >> $CREATE_FILE 2>&1
		cat "$apache"sites-available/default | grep -i 'DocumentRoot'  | grep -v '#'>> $CREATE_FILE 2>&1
		echo ' ' >> $CREATE_FILE 2>&1
		for d in $dir
		do
			if [ `cat "$conf" | grep -i 'DocumentRoot' | grep -v '#' | grep -i "$d" | wc -l` -eq 0 ]
			then
				echo "��ȣ" >> webdir.ahnlab
			else
				echo "���" >> webdir.ahnlab
			fi
		done
	fi
	if [ `cat webdir.ahnlab | grep "���" | wc -l` -gt 0 ]
    then
	  echo "�� �⺻��� �����" >> $CREATE_FILE 2>&1
	  echo " " >> $CREATE_FILE 2>&1	
      echo "�� U_58. ��� : ���" >> $CREATE_FILE 2>&1
    else
      echo "�� U_58. ��� : ��ȣ" >> $CREATE_FILE 2>&1
	fi
else
		echo '�� �� ���񽺰� ���������� ����' >> $CREATE_FILE 2>&1
		echo ' ' >> $CREATE_FILE 2>&1
		echo "�� U_52. ��� :  ��ȣ" >> $CREATE_FILE 2>&1
fi  
  echo " " >> $CREATE_FILE 2>&1
  
  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_59() {
  echo -n "U_59. ssh �������� ��� >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_59. ssh �������� ��� " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : ���� ���� �� SSH ���������� ����ϴ� ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  echo "�� ���μ��� ���� ���� Ȯ��" >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1

  if [ `ps -ef | grep sshd | grep -v "grep" | wc -l` -eq 0 ]
	  then
		  echo "�� SSH Service Disable" >> $CREATE_FILE 2>&1
	  else
		  ps -ef | grep sshd | grep -v "grep" >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

  echo "�� ���� ��Ʈ Ȯ��" >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1

  echo " " > ssh-result.ahnlab

  ServiceDIR="/etc/sshd_config /etc/ssh/sshd_config /usr/local/etc/sshd_config /usr/local/sshd/etc/sshd_config /usr/local/ssh/etc/sshd_config /etc/opt/ssh/sshd_config"

  for file in $ServiceDIR
    do
	    if [ -f $file ]
	      then
		      if [ `cat $file | grep "^Port" | grep -v "^#" | wc -l` -gt 0 ]
		        then
			        cat $file | grep "^Port" | grep -v "^#" | awk '{print "SSH ��������('${file}'): " $0 }' >> ssh-result.ahnlab
			        port1=`cat $file | grep "^Port" | grep -v "^#" | awk '{print $2}'`
			        echo " " > port1-search.ahnlab
		        else
			        echo "SSH ��������($file): ��Ʈ ���� X (Default ����: 22��Ʈ ���)" >> ssh-result.ahnlab
		      fi
	    fi
    done

  if [ `cat ssh-result.ahnlab | grep -v "^ *$" | wc -l` -gt 0 ]
    then
	    cat ssh-result.ahnlab | grep -v "^ *$" >> $CREATE_FILE 2>&1
    else
	    echo "SSH ��������: ���� ������ ã�� �� �����ϴ�." >> $CREATE_FILE 2>&1
  fi
  
  echo " " >> $CREATE_FILE 2>&1

  # ���� ��Ʈ ����
  echo "�� ���� ��Ʈ Ȱ��ȭ ���� Ȯ��" >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1

  if [ -f port1-search.ahnlab ]
    then
	    if [ `netstat -nat | grep ":$port1 " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -eq 0 ]
	      then
		      echo "�� SSH Service Disable" >> $CREATE_FILE 2>&1
	      else
		      netstat -na | grep ":$port1 " | grep -i "^tcp" | grep -i "LISTEN" >> $CREATE_FILE 2>&1
	    fi
    else
	    if [ `netstat -nat | grep ":22 " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -eq 0 ]
	      then
		      echo "�� SSH Service Disable" >> $CREATE_FILE 2>&1
	      else
		      netstat -nat | grep ":22 " | grep -i "^tcp" | grep -i "LISTEN" >> $CREATE_FILE 2>&1
	    fi
  fi

  echo " " >> $CREATE_FILE 2>&1

  if [ -f port1-search.ahnlab ]
    then
      if [ `netstat -nat | grep ":$port1 " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -eq 0 ]
        then
          echo "�� U_59. ��� : ���" >> $CREATE_FILE 2>&1
        else
          echo "�� U_59. ��� : ��ȣ" >> $CREATE_FILE 2>&1
      fi
    else
	    if [ `netstat -nat | grep ":22 " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -eq 0 ]
	      then
	        echo "�� U_59. ��� : ���" >> $CREATE_FILE 2>&1
	      else
	        echo "�� U_59. ��� : ��ȣ" >> $CREATE_FILE 2>&1
	    fi
	fi


  rm -rf ssh-result.ahnlab port1-search.ahnlab

  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_60() {
  echo -n "U_60. ftp ���� Ȯ�� >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_60. ftp ���� Ȯ�� " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : FTP ���񽺰� ��Ȱ��ȭ �Ǿ� �ִ� ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  find /etc -name "proftpd.conf" > proftpd.ahnlab
  find /etc -name "vsftpd.conf" > vsftpd.ahnlab
  profile=`cat proftpd.ahnlab`
  vsfile=`cat vsftpd.ahnlab`

  echo "�� /etc/services ���Ͽ��� ��Ʈ Ȯ��" >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1

  if [ `cat /etc/services | awk -F" " '$1=="ftp" {print "(1)/etc/service����:" $1 " " $2}' | grep "tcp" | wc -l` -gt 0 ]
    then
	    cat /etc/services | awk -F" " '$1=="ftp" {print "(1)/etc/service����:" $1 " " $2}' | grep "tcp" >> $CREATE_FILE 2>&1
    else
	    echo "(1)/etc/service����: ��Ʈ ���� X (Default 21�� ��Ʈ)" >> $CREATE_FILE 2>&1
  fi

  if [ -s vsftpd.ahnlab ]
    then
	    if [ `cat $vsfile | grep "listen_port" | grep -v "^#" | awk '{print "(3)VsFTP ��Ʈ: " $1 "  " $2}' | wc -l` -gt 0 ]
	      then
		      cat $vsfile | grep "listen_port" | grep -v "^#" | awk '{print "(3)VsFTP ��Ʈ: " $1 "  " $2}' >> $CREATE_FILE 2>&1
	      else
		      echo "(2)VsFTP ��Ʈ: ��Ʈ ���� X (Default 21�� ��Ʈ �����)" >> $CREATE_FILE 2>&1
	    fi
    else
	    echo "(2)VsFTP ��Ʈ: VsFTP�� ��ġ�Ǿ� ���� �ʽ��ϴ�." >> $CREATE_FILE 2>&1
  fi


  if [ -s proftpd.ahnlab ]
    then
	    if [ `cat $profile | grep "Port" | grep -v "^#" | awk '{print "(2)ProFTP ��Ʈ: " $1 "  " $2}' | wc -l` -gt 0 ]
	      then
		      cat $profile | grep "Port" | grep -v "^#" | awk '{print "(2)ProFTP ��Ʈ: " $1 "  " $2}' >> $CREATE_FILE 2>&1
	      else
		      echo "(3)ProFTP ��Ʈ: ��Ʈ ���� X (/etc/service ���Ͽ� ������ ��Ʈ �����)" >> $CREATE_FILE 2>&1
	    fi
    else
	    echo "(3)ProFTP ��Ʈ: ProFTP�� ��ġ�Ǿ� ���� �ʽ��ϴ�." >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

  echo "�� ���� ��Ʈ Ȱ��ȭ ���� Ȯ��" >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1

  ################# /etc/services ���Ͽ��� ��Ʈ Ȯ�� #################

  if [ `cat /etc/services | awk -F" " '$1=="ftp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
    then
	    port=`cat /etc/services | awk -F" " '$1=="ftp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	    
	    if [ `netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -gt 0 ]
	      then
		      netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN" >> $CREATE_FILE 2>&1
		      echo "ftp enable" > ftpenable.ahnlab
	    fi
    else
	    netstat -nat | grep ":21 " | grep -i "^tcp" | grep -i "LISTEN" >> $CREATE_FILE 2>&1
	    echo "ftp enable" > ftpenable.ahnlab
  fi

  ################# vsftpd ���� ��Ʈ Ȯ�� ############################

  if [ -s vsftpd.ahnlab ]
    then
	    if [ `cat $vsfile | grep "listen_port" | grep -v "^#" | awk -F"=" '{print $2}' | wc -l` -eq 0 ]
	      then
		      port=21
	      else
		      port=`cat $vsfile | grep "listen_port" | grep -v "^#" | awk -F"=" '{print $2}'`
	    fi
	    if [ `netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -gt 0 ]
	      then
		      netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN" >> $CREATE_FILE 2>&1
		      echo "ftp Service Enable" >> ftpenable.ahnlab
	    fi
	  else
	    echo "ftp Service Disable" >> ftpenable.ahnlab
  fi

  ################# proftpd ���� ��Ʈ Ȯ�� ###########################

  if [ -s proftpd.ahnlab ]
    then
	    port=`cat $profile | grep "Port" | grep -v "^#" | awk '{print $2}'`
	    
	    if [ `netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN" | wc -l` -gt 0 ]
	      then
		      netstat -nat | grep ":$port " | grep -i "^tcp" | grep -i "LISTEN" >> $CREATE_FILE 2>&1
				echo " " >> $CREATE_FILE 2>&1
				echo "ftp Service Enable" >> $CREATE_FILE 2>&1 
		      echo "ftp Service Enable"  >> ftpenable.ahnlab
		    else
				echo " " >> $CREATE_FILE 2>&1
				echo "ftp Service Disable" >> $CREATE_FILE 2>&1
		      echo "ftp Service Disable" >> ftpenable.ahnlab
	    fi
	  else
	    echo "ftp disable" >> ftpenable.ahnlab
  fi
	echo " " >> $CREATE_FILE 2>&1
	echo "�鼭�� Ȱ��ȭ Ȯ��" >> $CREATE_FILE 2>&1
	echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1
	if [ `ps -ef | grep ftp | grep -v grep | wc -l` -eq 0 ]
	then
		echo ' ' >> $CREATE_FILE 2>&1
		echo "�� ftp Service Disable" >> $CREATE_FILE 2>&1
	else
		echo ' ' >> $CREATE_FILE 2>&1
		echo "�� ftp Service Enable" >> $CREATE_FILE 2>&1
	fi

  echo " " >> $CREATE_FILE 2>&1

  if [ `cat ftpenable.ahnlab | grep "enable" | wc -l` -gt 0 ]
    then
      echo "�� U_60. ��� : ���" >> $CREATE_FILE 2>&1
    else
      echo "�� U_60. ��� : ��ȣ" >> $CREATE_FILE 2>&1
  fi

  rm -rf proftpd.ahnlab vsftpd.ahnlab


  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_61() {
  echo -n "U_61. ftp ���� shell ���� >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_61. ftp ���� shell ���� " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : ftp ������ /bin/fasle ���� �ο��Ǿ� �ִ� ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
if [ `ps -ef | grep -i ftp | grep -v grep | wc -l` -gt 0 ]
    then
		echo "�� FTP Service Enable" >> $CREATE_FILE 2>&1
		echo " " >> $CREATE_FILE 2>&1
  echo "�� ftp ���� �� Ȯ��(ftp ������ false �Ǵ� nologin ������ ��ȣ)" >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1

  if [ `cat /etc/passwd | awk -F: '$1=="ftp"' | wc -l` -gt 0 ]
    then
	    cat /etc/passwd | awk -F: '$1=="ftp"' >> $CREATE_FILE 2>&1
		echo " " >> $CREATE_FILE 2>&1
			if [ `cat /etc/passwd | awk -F: '$1=="ftp"' | egrep "false|nologin" | wc -l` -gt 0 ]
	   	 then
		 	   echo "�� U_61. ��� : ��ȣ" >> $CREATE_FILE 2>&1
	  		 else
   			   echo "�� U_61. ��� : ���" >> $CREATE_FILE 2>&1
  			fi
   else
	   echo "ftp ������ �������� ����." >> $CREATE_FILE 2>&1
	   echo " " >> $CREATE_FILE 2>&1
	   echo "�� U_61. ��� : ��ȣ" >> $CREATE_FILE 2>&1
  fi
else
	echo "�� ftp Service Disable" >> $CREATE_FILE 2>&1
	echo " " >> $CREATE_FILE 2>&1
	echo "�� U_61. ��� : ��ȣ" >> $CREATE_FILE 2>&1
fi
  echo " " >> $CREATE_FILE 2>&1

  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_62() {
  echo -n "U_62. Ftpusers ���� ������ �� ���� ���� >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_62. Ftpusers ���� ������ �� ���� ���� " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : ftpusers ������ �����ڰ� root�̰�, ������ 640 ������ ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo " " > ftpusers.ahnlab
if [ `ps -ef | grep -i ftp | grep -v grep | wc -l` -gt 0 ]
    then
		echo "�� FTP Service Enable" >> $CREATE_FILE 2>&1
		echo " " >> $CREATE_FILE 2>&1
  if [ -f /etc/ftpd/ftpusers ]
    then
      ls -alL /etc/ftpd/ftpusers  >> $CREATE_FILE 2>&1
		if [ `ls -alL /etc/ftpd/ftpusers | awk '{print $1}' | grep '.....-----' | wc -l` -eq 0 ]
        then
          echo "���" >> ftpusers.ahnlab
        else
          echo "��ȣ" >> ftpusers.ahnlab
     fi
    else
      echo " /etc/ftpd/ftpusers ������ �����ϴ�."  >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

  if [ -f /etc/ftpusers ]
    then
      ls -alL /etc/ftpusers  >> $CREATE_FILE 2>&1
		if [ `ls -alL /etc/ftpusers | awk '{print $1}' | grep '.....-----'| wc -l` -eq 0 ]
        then
          echo "���" >> ftpusers.ahnlab
        else
          echo "��ȣ" >> ftpusers.ahnlab
      fi
    else
      echo " /etc/ftpusers ������ �����ϴ�."  >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1
	if [ -f /etc/vsftpd.ftpusers ]
    then
      ls -alL /etc/vsftpd.ftpusers  >> $CREATE_FILE 2>&1
		if [ `ls -alL /etc/vsftpd.ftpusers | awk '{print $1}' | grep '.....-----' | wc -l` -eq 0 ]
			then
				echo "���" >> ftpusers.ahnlab
      	else
       	   echo "��ȣ" >> ftpusers.ahnlab
      fi
	else
		echo " /etc/vsftpd.ftpusers ������ �����ϴ�."  >> $CREATE_FILE 2>&1
	fi
	echo " " >> $CREATE_FILE 2>&1
	
	if [ -f /etc/vsftpd/ftpusers ]
		then
			ls -alL /etc/vsftpd/ftpusers  >> $CREATE_FILE 2>&1
			if [ `ls -alL /etc/vsftpd/ftpusers | awk '{print $1}' | grep '.....-----' | wc -l` -eq 0 ]
       	 then
      	    echo "���" >> ftpusers.ahnlab
        	else
        	  echo "��ȣ" >> ftpusers.ahnlab
				
      	fi
	else
      echo " /etc/vsftpd/ftpusers ������ �����ϴ�."  >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

	if [ -f /etc/vsftpd.user_list ]
   then
      ls -alL /etc/vsftpd.user_list >> $CREATE_FILE 2>&1
		if [ `ls -alL /etc/vsftpd.user_list | awk '{print $1}' | grep '.....-----' | wc -l` -eq 0 ]
				then
					echo "���" >> ftpusers.ahnlab
        	else
					echo "��ȣ" >> ftpusers.ahnlab
      fi
	else
		echo " /etc/vsftpd.user_list ������ �����ϴ�."  >> $CREATE_FILE 2>&1
 	fi 

	echo " " >> $CREATE_FILE 2>&1

	if [ -f /etc/vsftpd/user_list ]
	then
		ls -alL /etc/vsftpd/user_list >> $CREATE_FILE 2>&1
		if [ `ls -alL /etc/vsftpd/user_list | awk '{print $1}' | grep '.....-----' | wc -l` -eq 0 ]
        then
          echo "���" >> ftpusers.ahnlab
      else
          echo "��ȣ" >> ftpusers.ahnlab
		fi
	else
      
		echo " " >> $CREATE_FILE 2>&1
		echo " /etc/vsftpd/user_list ������ �����ϴ�."  >> $CREATE_FILE 2>&1
  fi
else
	echo "�� ftp Service Disable" >> $CREATE_FILE 2>&1
	echo " " >> $CREATE_FILE 2>&1
fi

  
  

	
  if [ `cat ftpusers.ahnlab | grep "���" | wc -l` -gt 0 ]
    then
      echo "�� U_62. ��� : ���" >> $CREATE_FILE 2>&1
    else
      echo "�� U_62. ��� : ��ȣ" >> $CREATE_FILE 2>&1
  fi

  rm -rf ftpusers.ahnlab


  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_63() {
  echo -n "U_63. Ftpusers ���� ���� >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_63. Ftpusers ���� ���� " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : FTP ���񽺰� ��Ȱ��ȭ �Ǿ� �ְų�, Ȱ��ȭ �� root ���� ������ ������ ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  if [ `cat ftpenable.ahnlab | grep "enable" | wc -l` -gt 0 ]
    then
		echo "�� FTP Service Enable" >> $CREATE_FILE 2>&1
		echo " " >> $CREATE_FILE 2>&1
		if [ -f /etc/ftpd/ftpusers ]
        then
			echo "/etc/ftpd/ftpusers ��������" >> $CREATE_FILE 2>&1
			echo "/etc/ftpd/ftpusers ����" >>$CREATE_FILE 2>&1
			 
			 if [ `cat /etc/ftpd/ftpusers | grep root | grep -v '#' | wc -l` -eq 1 ]
			 then
					cat /etc/ftpd/ftpusers | grep root | grep -v '#' >>$CREATE_FILE 2>&1
					echo "��root ���� ���� ���ܵ�" >> $CREATE_FILE 2>&1
					cat /etc/ftpd/ftpusers | grep root >> ftp.ahnlab 2>&1
			else
				echo "��root ���� ���� ���ܵ��� ����" >> $CREATE_FILE 2>&1 
			 fi
			echo ' ' >> $CREATE_FILE 2>&1          
        else
          echo "/etc/ftpd/ftpusers  ������ �����ϴ�." >> $CREATE_FILE 2>&1
		  echo ' ' >> $CREATE_FILE 2>&1
		fi

      if [ -f /etc/ftpusers ]
        then
          echo "/etc/ftpuser ��������" >> $CREATE_FILE 2>&1
          echo "/etc/ftpuser ����" >> $CREATE_FILE 2>&1
          
			 if [ `cat /etc/ftpusers | grep root | grep -v '#' | wc -l` -eq 1 ]
			 then
					cat /etc/ftpusers | grep root | grep -v '#' >>$CREATE_FILE 2>&1
					echo "��root ���� ���� ���ܵ�" >> $CREATE_FILE 2>&1
					cat /etc/ftpusers | grep root >> ftp.ahnlab 2>&1
			else
				echo "��root ���� ���� ���ܵ��� ����" >> $CREATE_FILE 2>&1 
			 fi
			echo ' ' >> $CREATE_FILE 2>&1
  
        else
          echo "/etc/ftpusers  ������ �����ϴ�." >> $CREATE_FILE 2>&1
			echo ' ' >> $CREATE_FILE 2>&1
      fi

      if [ -f /etc/vsftpd/ftpusers ]
        then
          echo "/etc/vsftpd/ftpusers ��������" >> $CREATE_FILE 2>&1
          echo "/etc/vsftpd/ftpusers ����" >> $CREATE_FILE 2>&1
			 
			 if [ `cat /etc/vsftpd/ftpusers | grep root | grep -v '#' | wc -l` -eq 1 ]
			 then
					cat /etc/vsftpd/ftpusers | grep root | grep -v '#' >>$CREATE_FILE 2>&1
					echo "��root ���� ���� ���ܵ�" >> $CREATE_FILE 2>&1
					cat /etc/vsftpd/ftpusers | grep root >> ftp.ahnlab 2>&1
			else
				echo "��root ���� ���� ���ܵ��� ����" >> $CREATE_FILE 2>&1 
			 fi
			echo ' ' >> $CREATE_FILE 2>&1
        else
          echo "/etc/vsftpd/ftpusers ������ �����ϴ�. " >> $CREATE_FILE 2>&1
			echo ' ' >> $CREATE_FILE 2>&1
      fi

		if [ -f /etc/vsftpd.ftpusers ]
        then
          echo "/etc/vsftpd.ftpusers ��������" >> $CREATE_FILE 2>&1
          echo "/etc/vsftpd.ftpusers ����">>$CREATE_FILE 2>&1
			 
          if [ `cat /etc/vsftpd.ftpusers | grep root | grep -v '#' | wc -l` -eq 1 ]
			 then
					cat /etc/vsftpd.ftpusers | grep root | grep -v '#' >>$CREATE_FILE 2>&1
					echo "��root ���� ���� ���ܵ�" >> $CREATE_FILE 2>&1
					cat /etc/vsftpd.ftpusers | grep root >> ftp.ahnlab 2>&1
			else
				echo "��root ���� ���� ���ܵ��� ����" >> $CREATE_FILE 2>&1 
			 fi
			 echo ' ' >> $CREATE_FILE 2>&1
        else
          echo "/etc/vsftpd.ftpusers ������ �����ϴ�. " >> $CREATE_FILE 2>&1
			echo ' ' >> $CREATE_FILE 2>&1
      fi

		if [ -f /etc/vsftpd/user_list ]
        then
          echo "/etc/vsftpd/user_list ��������" >> $CREATE_FILE 2>&1
          echo " /etc/vsftpd/user_list ����" >> $CREATE_FILE 2>&1
			 
          if [ `cat /etc/vsftpd/user_list | grep root | grep -v '#' | wc -l` -eq 1 ]
			 then
					cat /etc/vsftpd/user_list | grep root | grep -v '#' >>$CREATE_FILE 2>&1
					echo "��root ���� ���� ���ܵ�" >> $CREATE_FILE 2>&1
					cat /etc/vsftpd/user_list | grep root >> ftp.ahnlab 2>&1
			else
				echo "��root ���� ���� ���ܵ��� ����" >> $CREATE_FILE 2>&1 
			 fi
			 echo ' ' >> $CREATE_FILE 2>&1
  
        else
          echo "vsftpd/user_list ������ �����ϴ�. " >> $CREATE_FILE 2>&1
			echo ' ' >> $CREATE_FILE 2>&1
      fi

      if [ -f /etc/vsftpd.user_list ]
        then
          echo "/etc/vsftpd.user_list ��������" >> $CREATE_FILE 2>&1
          echo " /etc/vsftpd.user_list ����" >> $CREATE_FILE 2>&1
			 
          if [ `cat /etc/vsftpd/user_list | grep root | grep -v '#' | wc -l` -eq 1 ]
			    then
					  cat /etc/vsftpd/user_list | grep root | grep -v '#' >>$CREATE_FILE 2>&1
					  echo "��root ���� ���� ���ܵ�" >> $CREATE_FILE 2>&1
					  cat /etc/vsftpd/user_list | grep root >> ftp.ahnlab 2>&1
			    else
				    echo "��root ���� ���� ���ܵ��� ����" >> $CREATE_FILE 2>&1 
			    fi
			  echo ' ' >> $CREATE_FILE 2>&1
  
      else
        echo "vsftpd.user_list ������ �����ϴ�. " >> $CREATE_FILE 2>&1
			echo ' ' >> $CREATE_FILE 2>&1
      fi
      
      if [ -f /etc/proftpd.conf ]
        then
          echo "/etc/proftpd.conf ��������" >> $CREATE_FILE 2>&1
          echo " /etc/proftpd.conf ����" >> $CREATE_FILE 2>&1
          if [ `cat /etc/vsftpd/user_list | grep root | grep -v '#' | wc -l` -eq 1 ]
          then
            cat /etc/proftpd.conf | grep -i rootlogin | grep -v '#' >> $CREATE_FILE 2>&1
            echo "��root ���� ���� ���ܵ�" >> $CREATE_FILE 2>&1
            cat /etc/proftpd.conf | grep -i rootlogin | grep -v '#' >> ftp.ahnlab 2>&1
          else
            echo "��root ���� ���� ���ܵ��� ����" >> $CREATE_FILE 2>&1
          fi
        
        else
          echo "/etc/proftpd.conf ������ �����ϴ�. " >> $CREATE_FILE 2>&1
      fi 
  
  else
    echo "�� ftp Service Disable" >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

  if [ `cat ftpenable.ahnlab | grep "enable" | wc -l` -gt 0 ]
    then
      if [ `cat ftp.ahnlab | grep root | grep -v grep | wc -l` -eq 0 ]
        then
          echo "�� U_63. ��� : ���" >> $CREATE_FILE 2>&1
        else
          echo "�� U_63. ��� : ��ȣ" >> $CREATE_FILE 2>&1
      fi
    else
      echo "�� U_63. ��� : ��ȣ" >> $CREATE_FILE 2>&1
  fi

  rm -rf ftpenable.ahnlab ftp.ahnlab

  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_64() {
  echo -n "U_64. at ���� ������ �� ���� ���� >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_64. at ���� ������ �� ���� ���� " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : at �������� ������ �����ڰ� root�̰�, ������ 640 ������ ��� ��ȣ(���� 640������ ���Ͽ� ���� ���� �� ���)" >> $CREATE_FILE 2>&1
  echo "              at.deny, at.allow���� ��� ���� �� ������ ���� �ܴ̿� ������� ���ϹǷ� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  
  
  if [ -f /etc/at.allow ]
    then
      echo "/etc/at.allow ������ �����մϴ�." >> $CREATE_FILE 2>&1
	  	echo `ls -l /etc/at.allow` >> $CREATE_FILE 2>&1
		  echo " " >> $CREATE_FILE 2>&1
		  echo "��/etc/at.allow ���� ����" >> $CREATE_FILE 2>&1
		  echo "----------------------">>$CREATE_FILE 2>&1
		  if [ `cat /etc/at.allow | wc -l` -ge 1 ];then
			  cat /etc/at.allow >> $CREATE_FILE 2>&1
		  else
			  echo "���� ������ �����ϴ�." >> $CREATE_FILE 2>&1
		  fi
		  echo "----------------------">>$CREATE_FILE 2>&1
		
	   if [ \( `ls -l /etc/at.allow | awk '{print $3}' | grep -i root |wc -l` -eq 1 \) -a \( `ls -l /etc/at.allow | grep '...-.-----' | wc -l` -eq 1 \) ]; then
			if [ `cat /etc/at.allow | wc -l` -ge 1 ]; then
				allow_result='true'
			else
				allow_result='false'
			fi
		else
			allow_result='false'
		fi
  else
	  echo "/etc/at.allow ������ �����ϴ�." >> $CREATE_FILE 2>&1
		allow_result='true'
  fi
  
  if [ -f /etc/at.deny ]
    then					
      echo "/etc/at.deny ������ �����մϴ�." >> $CREATE_FILE 2>&1
	  	echo `ls -l /etc/at.deny` >> $CREATE_FILE 2>&1
	  	echo " " >> $CREATE_FILE 2>&1
	  	echo "��/etc/at.deny ���� ����" >> $CREATE_FILE 2>&1
	  	echo "----------------------">>$CREATE_FILE 2>&1
		  if [ `cat /etc/at.deny | wc -l` -ge 1 ];then
			  cat /etc/at.deny >> $CREATE_FILE 2>&1
		  else
			  echo "���� ������ �����ϴ�." >> $CREATE_FILE 2>&1
		  fi
		  echo "----------------------">>$CREATE_FILE 2>&1
	  
		  if [ \( `ls -l /etc/at.deny | awk '{print $3}' | grep -i root |wc -l` -eq 1 \) -a \( `ls -l /etc/at.deny | grep '...-.-----' | wc -l` -eq 1 \) ]; then
			  if [ `cat /etc/at.deny | wc -l` -ge 1 ];then
    			deny_result='true'
			  else
				  deny_result='false'
			  fi
			 
		else
			deny_result='false'
		fi
  else
	echo "/etc/at.deny ������ �����ϴ�." >> $CREATE_FILE 2>&1
		deny_result='true'
  fi
	  
  echo " " >> $CREATE_FILE 2>&1
    
  if [ $allow_result = 'false' -o $deny_result = 'false' ]
    then
      echo "�� U_64. ��� : ���" >> $CREATE_FILE 2>&1
    else
      echo "�� U_64. ��� : ��ȣ" >> $CREATE_FILE 2>&1
  fi


  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_65() {
  echo -n "U_65. SNMP ���� ���� ���� >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_65. SNMP ���� ���� ���� " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : SNMP ���񽺸� ������� �ʴ� ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  echo "[SNMP ���� ����]" >> $CREATE_FILE 2>&1
 
  echo " " >> $CREATE_FILE 2>&1

  if [ `ps -ef | grep snmp | grep -v "dmi" | grep -v "grep" | wc -l` -eq 0 ]
    then
      echo "�� SNMP Service Disable. "  >> $CREATE_FILE 2>&1
    else
      ps -ef | grep snmp | grep -v "dmi" | grep -v "grep" >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1
   
  echo " " >> $CREATE_FILE 2>&1


  echo " " >> $CREATE_FILE 2>&1

  if [ `ps -ef | grep snmp | grep -v "dmi" | grep -v "grep" | wc -l` -eq 0 ]
    then
      echo "�� U_65. ��� : ��ȣ" >> $CREATE_FILE 2>&1
    else
      echo "�� U_65. ��� : ���" >> $CREATE_FILE 2>&1
  fi


  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_66() {
  echo -n "U_66. SNMP ���� Community String�� ���⼺ ���� >>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_66. SNMP ���� Community string�� ���⼺ ���� " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : SNMP Community �̸��� public, private �� �ƴ� ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  echo "�� SNMP ���� ���� " >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1
  if [ `ps -ef | grep snmp | grep -v "dmi" | grep -v "grep" | wc -l` -ge 1 ]
    then
    	echo " " >> $CREATE_FILE 2>&1
    	ps -ef | grep snmp | grep -v "dmi" | grep -v "grep" >> $CREATE_FILE 2>&1
    	echo " " >> $CREATE_FILE 2>&1
    	echo "SNMP�� �������Դϴ�. "  >> $CREATE_FILE 2>&1
  
  echo " " >> $CREATE_FILE 2>&1

  echo "�� �������� CommunityString ��Ȳ " >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1
    
  SPCONF_DIR="/etc/snmpd.conf /etc/snmpdv3.conf /etc/snmp/snmpd.conf /etc/snmp/conf/snmpd.conf /etc/sma/snmp/snmpd.conf"

 for file in $SPCONF_DIR
 do
  if [ -f $file ]
  then
     echo "�� "$file"���� �� CommunityString ����" >> $CREATE_FILE 2>&1
     echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1
     echo " " >> $CREATE_FILE 2>&1
     cat $file | grep -i -A1 -B1 "Community" | grep -v "#" >> $CREATE_FILE 2>&1
     echo " " >> $CREATE_FILE 2>&1
  fi
 done 
  
  echo "�� U_66. ��� : ��������" >> $CREATE_FILE 2>&1  
  
else
  echo "SNMP�� ��������Դϴ�. "  >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "�� U_66. ��� : ��ȣ" >> $CREATE_FILE 2>&1
fi

	
  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}

U_67() {
  echo -n "U_67. �α׿� �� ��� �޽��� ���� >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_67. �α׿� �� ��� �޽��� ���� " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : ���� �� Telnet ���񽺿� �α׿� �޽����� �����Ǿ� �ִ� ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  echo "  " >> $CREATE_FILE 2>&1
  
  echo "  " > banner.ahnlab
  echo " " > banner_temp.ahnlab
  
  echo "�� ���� �α׿� �� ��� ���(/etc/motd) Ȯ��" >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1
  if [ -f /etc/motd ]
	then  
		if [ `cat /etc/motd | wc -l` -gt 0 ]
    	then
			 echo "��ȣ" >> banner.ahnlab
	   	 cat /etc/motd >> $CREATE_FILE 2>&1
		else
			echo
			echo "���" >> banner.ahnlab 
		fi
  else
	  echo "/etc/motd ������ �������� �ʽ��ϴ�." >> $CREATE_FILE 2>&1
	  echo "���" >> banner.ahnlab
  fi
  
  echo "  " >> $CREATE_FILE 2>&1

  echo "�� SSH ���� ���� " >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1
  if [ `ps -ef | grep sshd | grep -v "grep" | wc -l` -eq 0 ]
	  then
		  echo "�� SSH Service Disable" >> $CREATE_FILE 2>&1
	  else
		  echo "�� SSH Service Enable" >> $CREATE_FILE 2>&1
		  echo "  " >> $CREATE_FILE 2>&1
          echo "�� ssh ��� ���� ����" >> $CREATE_FILE 2>&1		  
		  cat ssh-banner.ahnlab >> $CREATE_FILE 2>&1
		  # ssh-banner.ahnlab�� U_01���� ���� for�� �ι������� �ʱ�����..
		  
		  echo "  " >> $CREATE_FILE 2>&1
		  echo "�� ������ ssh ������� ����� �ش� ���� ����" >> $CREATE_FILE 2>&1
		  
		  if [ `cat ssh-banner.ahnlab | grep -v "#" | wc -l` -gt 0 ]
		  then
		     cat ssh-banner.ahnlab | grep -v "#" | awk -F " " '{print $4}' >> $CREATE_FILE 2>&1
			 echo "��ȣ" >> banner.ahnlab
		  else
		     echo "ssh ��� ������ �������� �ʽ��ϴ�." >> $CREATE_FILE 2>&1
			 echo "���" >> banner.ahnlab
		  fi
  fi
  echo "  " >> $CREATE_FILE 2>&1
  echo "  " >> $CREATE_FILE 2>&1

  ps -ef | grep telnetd  | grep -v grep >> banner_temp.ahnlab
  
  if [ -f /etc/inetd.conf ]
  then
  cat /etc/inetd.conf | grep 'telnetd' | grep -v '#' >> banner_temp.ahnlab
  fi
  
  echo "�� telnet ���� ���� " >> $CREATE_FILE 2>&1
  echo "------------------------------------------------------------------------------" >> $CREATE_FILE 2>&1
  if [ `cat banner_temp.ahnlab | grep telnetd | grep -v grep | wc -l` -gt 0 ]
    then
      echo "�� Telnet Service Enable" >> $CREATE_FILE 2>&1
	  echo "  " >> $CREATE_FILE 2>&1
      echo "�� TELNET ���" >> $CREATE_FILE 2>&1
      if [ -f /etc/inetd.conf ]
        then
          if [ `cat /etc/inetd.conf | grep "telnetd" | grep -v "#" | grep "\-b" | grep "\/etc/issue" | wc -l` -eq 0 ]
            then
              echo "���" >> banner.ahnlab
              echo "/etc/inetd.conf ���� ���� ����" >> $CREATE_FILE 2>&1
            else
              echo "��ȣ" >> banner.ahnlab
              echo "/etc/inetd.conf ���� ����" >> $CREATE_FILE 2>&1
              cat /etc/inetd.conf | grep "telnetd" >> $CREATE_FILE 2>&1
          fi
        else
          echo "��������" >> banner.ahnlab
          echo "/etc/inetd.conf ���� �������� ����" >> $CREATE_FILE 2>&1
      fi
    else
      echo "��ȣ" >> banner.ahnlab
      echo "�� Telnet Service Disable" >> $CREATE_FILE 2>&1
  fi

  echo "  " >> $CREATE_FILE 2>&1
  echo "  " >> $CREATE_FILE 2>&1
  
  echo " " > banner_temp.ahnlab

  ps -ef | grep ftpd | grep -v grep >> banner_temp.ahnlab
  
  if [ -f /etc/inetd.conf ]
  then
  cat /etc/inetd.conf | grep 'ftpd' | grep -v '#' >> banner_temp.ahnlab
  fi

  echo "  " >> $CREATE_FILE 2>&1

  if [ `cat banner.ahnlab | grep "���" | wc -l` -eq 0 ]
    then
      echo "�� U_67. ��� : ��ȣ" >> $CREATE_FILE 2>&1
    else
      echo "�� U_67. ��� : ���" >> $CREATE_FILE 2>&1
  fi

  rm -rf banner.ahnlab
  rm -rf banner_temp.ahnlab
  rm -rf ssh-banner.ahnlab

  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_68() {
  echo -n "U_68. NFS �������� ���ٱ��� >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_68. NFS �������� ���ٱ��� " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : NFS �������� ���������� �����ڰ� root�̰�, ������ 644 ������ ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  if [ `ps -ef | grep "nfsd" | egrep -v "statdaemon|automountd|emi" | grep -v "grep" | wc -l` -gt 0 ] 
    then
      ps -ef | grep "nfsd" | egrep -v "statdaemon|automountd|emi" | grep -v "grep" >> $CREATE_FILE 2>&1
      echo " " >> $CREATE_FILE 2>&1
	  echo "�� NFS Service Enable" >> $CREATE_FILE 2>&1
    	
	
	if [ -f /etc/exports ]
	then
      if [ `ls -alL /etc/exports | awk '{print $1}' | grep '.....--.--' | wc -l` -eq 1 ]
        then
		  echo "/etc/exports ���� ����"	>> $CREATE_FILE 2>&1
		  echo " " >> $CREATE_FILE 2>&1
		  ls -alL /etc/exports  >> $CREATE_FILE 2>&1
		  echo " " >> $CREATE_FILE 2>&1
          echo "�� U_68. ��� : ��ȣ" >> $CREATE_FILE 2>&1
        else
          echo "�� U_68. ��� : ���" >> $CREATE_FILE 2>&1
      fi
    else
	  echo " /etc/exports ������ �����ϴ�"  >> $CREATE_FILE 2>&1
	  echo " " >> $CREATE_FILE 2>&1
      echo "�� U_68. ��� : ���" >> $CREATE_FILE 2>&1
	fi
  
  else
      echo "�� NFS Service Disable" >> $CREATE_FILE 2>&1
	   echo " " >> $CREATE_FILE 2>&1
	  echo "�� U_68. ��� : ��ȣ" >> $CREATE_FILE 2>&1
  fi


  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_69() {
  echo -n "U_69. expn, vrfy ��ɾ� ���� >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_69. expn, vrfy ��ɾ� ���� " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : SMTP ���� �̻�� �Ǵ�, noexpn, novrfy �ɼ��� �����Ǿ� �ִ� ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  echo "�� Sendmail ���μ��� Ȯ��" >> $CREATE_FILE 2>&1
  
  if [ `ps -ef | grep sendmail | grep -v "grep" | wc -l` -eq 0 ]
    then
      echo "Sendmail Service Disable" >> $CREATE_FILE 2>&1
    else
      ps -ef | grep sendmail | grep -v "grep" >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1


  echo " " >> $CREATE_FILE 2>&1

  echo "�� /etc/mail/sendmail.cf ������ �ɼ� Ȯ��" >> $CREATE_FILE 2>&1

  if [ -f /etc/mail/sendmail.cf ]
    then
      grep -v '^ *#' /etc/mail/sendmail.cf | grep PrivacyOptions >> $CREATE_FILE 2>&1
    else
      echo "/etc/mail/sendmail.cf ���� ����" >> $CREATE_FILE 2>&1
  fi

  echo " " >> $CREATE_FILE 2>&1

  if [ `ps -ef | grep sendmail | grep -v "grep" | wc -l` -eq 0 ]
    then
      echo "�� U_69. ��� : ��ȣ" >> $CREATE_FILE 2>&1
    else
      if [ -f /etc/mail/sendmail.cf ]
        then
          if [ `cat /etc/mail/sendmail.cf | grep -i "O PrivacyOptions" | grep -i "noexpn" | grep -i "novrfy" |grep -v "#" |wc -l ` -eq 1 ]
            then
              echo "�� U_69. ��� : ��ȣ" >> $CREATE_FILE 2>&1
            else
              echo "�� U_69. ��� : ���" >> $CREATE_FILE 2>&1
          fi
        else
          echo "�� U_69. ��� : ��ȣ" >> $CREATE_FILE 2>&1
      fi
  fi


  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}

U_70() {
  echo -n "U_70. Apache ������  ���� ����>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_70. Apache ������ ���� ���� " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : ServerTokens �����ڿ� Prod �ɼ��� �����Ǿ� �ִ� ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  confdir="/etc/apache2/apache2.conf /etc/apache2/conf.d/security /etc/apache2/conf-available/security.conf /etc/apache2/conf-enabled/security.conf"

  if [ $web = 'httpd' ]; then
 	if [ -f $conf ]; then
		if [ `cat $conf | grep -i 'servertoken' | grep -i -o "prod" | grep -v '#' | wc -l` -gt 0 ]; then
			echo $conf"�� ����" >> $CREATE_FILE 2>&1
			echo " " >> $CREATE_FILE 2>&1
			cat $conf | grep -i "servertokens" >> $CREATE_FILE 2>&1
			echo " " >> $CREATE_FILE 2>&1
			echo '�� ServerToken�� prod�� �����Ǿ� ����' >> $CREATE_FILE 2>&1
			echo " " >> $CREATE_FILE 2>&1
			echo "�� U_70. ��� : ��ȣ" >> $CREATE_FILE 2>&1 
		else
			cat $conf | grep -i "servertokens" >> $CREATE_FILE 2>&1
			echo $conf"�� ����" >> $CREATE_FILE 2>&1
			echo " " >> $CREATE_FILE 2>&1
			echo '�� ServerToken�� prod�� �����Ǿ� ���� ����' >> $CREATE_FILE 2>&1
			echo " " >> $CREATE_FILE 2>&1
			echo "�� U_70. ��� : ���" >> $CREATE_FILE 2>&1
		fi
	 
	fi
	
	
   elif [ $web = 'apache2' ]; then
	
	for file in $confdir
	do
		if [ -f $file ]; then
			if [ `cat $file | grep -i 'servertoken' | grep -i -o "prod" | grep -v '#' | wc -l` -gt 0 ]; then
				echo $file"�� ���� ����" >> $CREATE_FILE 2>&1
				echo ' ' >> $CREATE_FILE 2>&1
				cat $file | grep -i "servertokens">> $CREATE_FILE 2>&1
				cat $file | grep -i "servertokens" >> header 2>&1
				echo ' ' >> $CREATE_FILE 2>&1
		  fi
		fi
	done
  else
		echo '�� �� ���񽺰� ���������� ����' >> $CREATE_FILE 2>&1
 		echo ' ' >> $CREATE_FILE 2>&1
		echo "�� U_52. ��� :  ��ȣ" >> $CREATE_FILE 2>&1
 fi
	
	if [ -f header ]; then
 	  if [ `cat header | grep -i 'servertoken' | grep -i -o 'prod' | grep -v '#' | wc -l` -gt 0 ]
  	  then
  	    echo "�� U_70. ��� : ��ȣ" >> $CREATE_FILE 2>&1
  	  else
 	     echo "�� U_70. ��� : ���" >> $CREATE_FILE 2>&1
 	 fi
	fi
  
	rm -rf header
  
  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}

U_71() {
  echo -n "U_71. �ֽ� ������ġ �� ���� �ǰ���� ���� >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_71. �ֽ� ������ġ �� ���� �ǰ���� ���� " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : ��ġ ���� ��å�� �����Ͽ� �ֱ������� ��ġ�� �����ϰ� �ִ� ��� ��ȣ(����� ���ͺ並 ���� Ȯ��)" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  confdir="/bin/rpm /usr/bin/rpm /usr/bin/apt-get"
	
	for file in $confdir
	do
		if [ -f $file ]; then
			if [ `ls -l $file | grep -o rpm | wc -l` -gt 0 ]; then
				rpm -qa | sort >> $CREATE_FILE 2>&1
  			else
				dpkg -l >> $CREATE_FILE 2>&1
			fi
		fi
	done
  
  echo " " >> $CREATE_FILE 2>&1
  echo "�� U_71. ��� : ��������" >> $CREATE_FILE 2>&1


  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}

U_72() {
  echo -n "U_72. �α��� ������ ���� �� ���� >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_72. �α��� ������ ���� �� ���� " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : �α� ����� ����, �м�, ����Ʈ �ۼ� �� ���� ���� ���������� �̷������ ��� ��ȣ" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  
  echo "�� ������Ʈ ���ܰ�� �ݿ�" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "�� U_72. ��� : ��������" >> $CREATE_FILE 2>&1


  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}


U_73() {
  echo -n "U_73. ��å�� ���� �ý��� �α� ���� >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  echo "##############################################################################" >> $CREATE_FILE 2>&1
  echo "U_73. ��å�� ���� �ý��� �α� ���� " >> $CREATE_FILE 2>&1
  echo "##############################################################################" >> $CREATE_FILE 2>&1

  echo "�� ���˱��� : ��å�� ���� �ý��� �α� ����" >> $CREATE_FILE 2>&1
  echo "�� �ý��� ��Ȳ" >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1

  echo "�� syslog ���μ���" >> $CREATE_FILE 2>&1
  
  ps -ef | grep 'syslog' | grep -v 'grep' >> $CREATE_FILE 2>&1

  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  
  echo "�� �ý��� �α� ����" >> $CREATE_FILE 2>&1
 
  echo " " >> $CREATE_FILE 2>&1
  
  echo " " > syslog.ahnlab
  
  LoggingDIR="/etc/syslog.conf /etc/rsyslog.conf /etc/syslog-ng.conf"

  for file in $LoggingDIR
	do
	if [ -f $file ]
	 then
	    echo "�� "$file"���� ����" >> $CREATE_FILE 2>&1
		echo "-------------------------------------------------------" >> $CREATE_FILE 2>&1
		cat $file | grep -v "#" | grep -ve '^ *$'  >> $CREATE_FILE 2>&1
		echo " " >> $CREATE_FILE 2>&1
		
		if [ `cat $file | egrep "info|alert|notice|debug" | egrep "var|log" | wc -l` -gt 0 ]
		 then
		    echo "��ȣ" >> syslog.ahnlab
		else	
			echo "���" >> syslog.ahnlab
		fi
		if [ `cat $file | egrep "alert|err|crit" | egrep "console|sysmsg" | wc -l` -gt 0 ]
		 then
		    echo "��ȣ" >> syslog.ahnlab
		else	
			echo "���" >> syslog.ahnlab
		fi
		if [ `cat $file | grep "emerg" | grep "\*" | wc -l` -gt 0 ]
		 then
		    echo "��ȣ" >> syslog.ahnlab
		else	
			echo "���" >> syslog.ahnlab
		fi
	else
	  echo "�� "$file"������ �߰ߵ��� �ʾҽ��ϴ�." >> $CREATE_FILE 2>&1
	  echo "��������" >> syslog.ahnlab
	  echo " " >> $CREATE_FILE 2>&1
	fi
	done 
  
  
  echo " " >> $CREATE_FILE 2>&1

  if [ `cat syslog.ahnlab | grep "���" | wc -l` -eq 0 ]
    then
      if [ `cat syslog.ahnlab | grep "��������" | wc -l` -eq 3 ]
	   then
	     echo "�� U_73. ��� : ��������" >> $CREATE_FILE 2>&1
	   else
	     echo "�� U_73. ��� : ��ȣ" >> $CREATE_FILE 2>&1
	  fi
    else
      echo "�� U_73. ��� : ���" >> $CREATE_FILE 2>&1
  fi


  rm -rf syslog.ahnlab
  
  result="�Ϸ�"
  echo " " >> $CREATE_FILE 2>&1
  echo " " >> $CREATE_FILE 2>&1
  echo "[$result]"
  echo " "
}

#U1. ��������
U_01
U_02
U_03
U_04
U_05
U_06
U_07
U_08
U_09
U_10
U_11
U_12
U_13
U_14
U_15
#U2. ���� �� ���͸� ����
U_16
U_17
U_18
U_19
U_20
U_21
U_22
U_23
U_24
U_25
U_26
U_27
U_28
U_29
U_30
U_31
U_32
U_33
U_34
#U3. ���� ����
U_35
U_36
U_37
U_38
U_39
U_40
U_41
U_42
U_43
U_44
U_45
U_46
U_47
U_48
U_49
U_50
U_51
U_52
U_53
U_54
U_55
U_56
U_57
U_58
U_59
U_60
U_61
U_62
U_63
U_64
U_65
U_66
U_67
U_68
U_69
U_70
#U4. ��ġ ����
U_71
#U5. �α� ����
U_72
U_73




echo "�� �����۾��� �Ϸ�Ǿ����ϴ�. �����ϼ̽��ϴ�!"

# "***************************************  ��ü ����� ���� ���� ����  ***********************************"

_HOSTNAME=`hostname`
CREATE_FILE_RESULT="Linux__"${_HOSTNAME}"__result".txt
#CREATE_FILE_RESULT=`hostname`"_"`date +%m%d`.txt
echo > $CREATE_FILE_RESULT

echo " "

# "***************************************  ��ü ����� ���� ���� �� **************************************"

# "**************************************** ���� ����� ��� ���� *****************************************"

#echo "�� ���ܰ�� ��" > `hostname`_result.txt 2>&1
#echo " " >> `hostname`_result.txt 2>&1

#cat $CREATE_FILE | egrep '��ȣ|���|��������|�ش����' | grep '�� ' >> `hostname`_result.txt 2>&1

#echo " " >> `hostname`_result.txt 2>&1

# "**************************************** ���� ����� ��� �� *******************************************"
cat $CREATE_FILE >> $CREATE_FILE_RESULT 2>&1

unset FILES
unset HOMEDIRS
unset SERVICE_INETD
unset SERVICE
unset APROC1
unset APROC
unset ACONF
unset AHOME
unset ACFILE
unset ServiceDIR
unset vsfile
unset profile
unset result

rm -Rf list.txt
rm -Rf result.txt
rm -Rf telnetps.ahnlab ftpps.ahnlab



rm -Rf $CREATE_FILE 2>&1

#20160105-01 : U-03 pam_tally2.so ���� ���� �߰� ,  �Ӱ谪 5 ���� ��ȣ �Ǵ� ���� 
#20160105-02 : U-22 rsyslog ���� ���� �߰�  
#20160106-01 : U-26 ���˹�� ���� 
#20160106-02 : ���� ��� ����
#20160106-03 : ���� ��� ���� 
#20160106-01 : ���� ��� ��ü ���� 
