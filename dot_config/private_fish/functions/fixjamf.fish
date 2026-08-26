function fixjamf --description "Clear Jamf Protect database to fix high CPU usage"
    sudo rm -rf "/Library/Application Support/JamfProtect/db"
    echo "Jamf Protect DB cleared - CPU should drop within 30 seconds"
end
