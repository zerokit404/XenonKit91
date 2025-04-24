clear
BLACK='\033[30m'
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
CYAN='\033[34m'
MAGENTA='\033[35m'
BLUE='\033[36m'
WHITE='\033[37m'
RESET='\033[0m'

get_public_ip() {
    ip=$(curl -s https://api64.ipify.org)
    echo "Your IP Public: $ip"
}

spinner() {
    sp="/-\|"
    while true; do
        for i in `seq 0 3`; do
            echo -ne "\r${sp:$i:1} Tracing IP..."
            sleep 0.1
        done
    done
}

menu_start() {
    echo -e "${GREEN}"
    figlet -f slant "Tracer"
    echo
    echo -e "${BLUE}Menu${RESET}"
    echo -e "${GREEN}"
    echo -e "[1].Your IP"
    echo -e "[2].Trace IP"
    echo -e "[3].Username tracer"
    echo -e "[0].Exit"
    read -p "[>]" menu
}

menu() {
    case $menu in
        1)
            clear
            echo -e "${GREEN}"
            figlet -f slant "Your IP"
            get_public_ip
            read -p "Press enter to return to the main menu..."
            menu_start
            menu
            ;;
        2)
            clear
            toilet -f slant -F border --gay "IP Tracer" | lolcat
            echo -e "${GREEN}"
            read -p "Enter the IP to trace => " ip_address
            echo -e "${RESET}"

            if [ -z "$ip_address" ]; then
                echo -e "${RED}IP Address cannot be empty!${RESET}"
                exit 1
            fi


            spinner &
            SPINNER_PID=$!

            
            response=$(curl -s "http://ip-api.com/json/$ip_address")

             kill $SPINNER_PID

            status=$(echo $response | jq -r '.status')

            if [ "$status" == "success" ]; then
                country=$(echo $response | jq -r '.country')
                region=$(echo $response | jq -r '.regionName')
                city=$(echo $response | jq -r '.city')
                isp=$(echo $response | jq -r '.isp')
                timezone=$(echo $response | jq -r '.timezone')
                lat=$(echo $response | jq -r '.lat')
                lon=$(echo $response | jq -r '.lon')

                echo -e "${GREEN}IP Trace Result:${RESET}"
                echo -e "  ${CYAN}Country     : ${RESET}$country"
                echo -e "  ${CYAN}Region      : ${RESET}$region"
                echo -e "  ${CYAN}City        : ${RESET}$city"
                echo -e "  ${CYAN}ISP         : ${RESET}$isp"
                echo -e "  ${CYAN}Timezone    : ${RESET}$timezone"
                echo -e "  ${CYAN}Latitude    : ${RESET}$lat"
                echo -e "  ${CYAN}Longitude   : ${RESET}$lon"
                echo -e "  ${CYAN}Google Maps : https://www.google.com/maps?q=$lat,$lon"
            else
                echo -e "${RED}Failed to trace IP. Make sure the IP is valid.${RESET}"
            fi
            read -p "Press enter to return to the main menu..."
            menu_start
            menu
            ;;
        3)
            clear
            read -p "Enter the username: " username

            echo -e "\nSearching username on various platforms...\n"

            declare -a sites=(
                "https://github.com/$username"
                "https://www.instagram.com/$username"
                "https://twitter.com/$username"
                "https://www.reddit.com/user/$username"
                "https://www.pinterest.com/$username"
                "https://www.facebook.com/$username"
                "https://www.tiktok.com/@$username"
                "https://www.youtube.com/$username"
            )

            for site in "${sites[@]}"; do
                response=$(curl -s -o /dev/null -w "%{http_code}" $site)
                if [[ $response == "200" ]]; then
                    echo "[+] Found: $site"
                else
                    echo "[-] Not found: $site"
                fi
            done

            echo -e "\nSearch completed."
            read -p "Press enter to return to the main menu..."
            menu_start
            menu
            ;;
        0)
            echo -e "${BLUE}Exiting the program...${RESET}"
            exit 0
            ;;
        *)
            echo "Invalid option!"
            read -p "Press enter to return to the main menu..."
            menu_start
            menu
            ;;
    esac
}

menu_start
menu
