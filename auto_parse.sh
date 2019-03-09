cd $(dirname "$0")
echo `date` >> /home/stan/parse.log
wget -O "/tmp/archive.csv" "https://docs.google.com/spreadsheets/d/1X1HTxkI6SqsdpNSkSSivMzpxNT-oeTbjFFDdEkXD30o/export?format=csv&id=1X1HTxkI6SqsdpNSkSSivMzpxNT-oeTbjFFDdEkXD30o"
echo 'done downloading'
/usr/local/bin/bundle exec ruby cli.rb --source /tmp/archive.csv --target archive.db --date=2018-08-01
