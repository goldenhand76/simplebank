#!/bin/bash
API_BASE="http://127.0.0.1:8080"
ACCESS_TOKEN="v2.local.fqpobxhGlJCTYTAC9uV64I_nNO_CkSRhbDuJMjvfzVi5aCu6d_aCupCwPEkxIn9IZaZN1IlblDwXkMIKUh4miaGsLnSmnXR3NzsaebKRp8iW3W09h0k58r_eP0xBUBqkSUSOv4dYi24aqptvb8AXYx2HKhv8q2q3byZQCxenbsAsywsNUmPPP-ugETuhz42ov6nY-eXHne2pJJhellHxGMmvKXivDbi-jZtbQyLX_YNPzHRFqMZ360WGwZzaljp5ZQ.bnVsbA"

while true; do
    echo "API Client Menu"
    echo "1) Create User"
    echo "2) Login"
    echo "3) Create Account"
    echo "4) Get Account"
    echo "5) Get Accounts"
    echo "6) Transfer"

    read -rp "Select an option (1-4): " option
    
    case $option in
        1)
            read -rp "Enter username: " username
            read -rp "Enter password: " password
            read -rp "Enter email:    " email
            read -rp "Enter fullname: " full_name
            curl -s -X POST "$API_BASE/users" -H "Content-Type: application/json" -d '{"username":"'"$username"'","password":"'"$password"'","email":"'"$email"'","full_name":"'"$full_name"'"}' | jq
            ;;
        2)
            read -rp "Enter Username: " username
            read -rp "Enter Password: " password
            curl -s -X POST "$API_BASE/users/login" -H "Content-Type: application/json" -d '{"username":"'"$username"'","password":"'"$password"'"}' | jq
            ;;
        3)
            read -rp "Enter username: " username
            read -rp "Enter email: " email
            curl -s -X POST "h$API_BASE/users" \
                -H "Content-Type: application/json" \
                -d '{"name":"'"$username"'","email":"'"$email"'"}' | jq
            ;;
        4)
            curl -s "$API_BASE/accounts" | jq
            ;;
        5)
            curl -s "$API_BASE/accounts" | jq
            ;;
        6)
            echo "Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid option, try again"
            ;;
    esac
    
    echo  # Add blank line for readability
done