if ! psql -U postgres -c '\q' &> /dev/null; then
    createuser -s postgres
fi
