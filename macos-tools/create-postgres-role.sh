if ! psql -U postgres -c '\q' &> /dev/null; then
    echo "Creating postgres superuser..."
    createuser -s postgres
fi
