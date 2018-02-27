cd $(dirname "$0")
wget -O "/tmp/archive.csv" "https://docs.google.com/spreadsheets/d/1X1HTxkI6SqsdpNSkSSivMzpxNT-oeTbjFFDdEkXD30o/export?format=csv&id=1X1HTxkI6SqsdpNSkSSivMzpxNT-oeTbjFFDdEkXD30o"
echo 'done downloading'
bundle exec ruby cli.rb --source /tmp/archive.csv --target archive.db
