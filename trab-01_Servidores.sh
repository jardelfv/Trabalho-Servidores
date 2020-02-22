#!/bin/bash
# Jardel F.V. jardel.fv@gmail.com
# Jardel, Erickson e Luiza

##### Atenção! lembre-se de dar a permição de execução do arquivo: chmod +x arquivo.sh ####

linha=$"=================+++000+++==========================="
echo "Bem vindo"
echo "$linha"
echo "Esse script instala ou remove programas"
echo "Também realiza configuração básica de IP"
echo "$linha"
echo ""

##PS3="Informe a opção escolhida: "
##select i in instalar remover ip_config reparar_pacote sair

op="sair"

while true $op !="op"
do
    clear
    echo ""
    echo "MENU PRINCIPAL"
    echo ""
    echo "1 - Instalar pacotes ou programas"
    echo "2 - Remover pacotes ou programas"
    echo "3 - Configurar rede"
    echo "4 - Reparar pacote com problemas"
    echo "5 - Informações úteis"
    echo "6 - Sair"
    echo ""
    echo "Digite a opção desejada: "
    read op

    case "$op" in
        1)
            echo "     || Instalar pacotes ou programas ||"
            echo ""
            echo -n "Informe o nome do pacote/programa: " 
            read nome
            pacote=$(dpkg --get-selections | grep "$nome" ) 
            echo ""
            
            if [ -n "$pacote" ] ;
                then
                    echo ""
                    echo "Ok, O $nome ja está instalado"
                    
                else
                    echo ""
                    echo "Pacote não instalado, vamos instalar..."
                    sudo apt-get install $nome
                fi
            ;;
    
        2)
            echo "     || Remover pacotes ou programas ||"
			echo ""
			echo "Digite o nome do pacote a ser removido:"
			read nome
			echo "Removendo..."
			apt-get remove --purge $nome
			sleep 5
			echo ""
            ;;
        
        3)
            echo "     || Configurar rede ||"
            echo ""

            ## mostrar IP atual-----##################
            meuIP=$(hostname -I | awk '{print $1}')
            echo "Seu IP atual: $meuIP"
            echo ""
            ## ---------------------##################

            pesquisa=$(dpkg --get-selections | grep "net-tools" )
            if [ -n "$pesquisa" ] ;
            then
                echo "Ok, pacote $pesquisa encontrado"
                echo ""
                echo "Digite o indereço IP: " 
                read ip
                echo "Digite a mascara de rede: " 
                read mascara
                echo "Digite o gateway: " 
                read gateway

                echo "Digite a interface: " 
                read interface
                
                ifconfig $interface $ip netmask $mascara
                route add default gw $gateway
                echo "reiniciando interface de rede..."
                sudo /etc/init.d/networking restart
                echo ""
                
            else
                echo "O pacote net-tools não foi encontrado iremos instalar para você"
                sudo apt install net-tools
            fi
            
			echo ""
            ;;
		
		4)
            echo "     || Reparar pacote com problemas ||"
			echo ""
			echo "Reparando..."
			sleep 5
			dpkg --configure -a
			
			echo ""
            ;;
        
        5)
			echo "     || Informações úteis ||"
            echo ""
            echo "Informações úteis de arquivos e locais de rede:"
			echo "-----------------------------------------"
			echo "|Interface: 	/etc/network/interfaces"
			echo "|Servidor DNS: /etc/resolv.conf"
			echo "|Hosts:   /etc/hosts"
			echo "-----------------------------------------"
			echo ""
            echo "-----------------------------------------"
            echo "LINUX VERSION:"
            lsb_release -a
            echo "-----------------------------------------"
            echo ""
            ;;
        6)
            echo "saindo do script..."
            break
            ;;
        
        *)
            echo "Opção inválida"
            ;;
    
    esac
done

exit 0
