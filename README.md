# daily-checks 
Script that checks if wordpress websites defined in the 1`$WP_URLs` variavble are up to date. 
I have it running with a cronjob daily. Do so you can simply run:
```bash
(crontab -l ; echo "0 10 * * * /path_to/daily_checks.sh -a") | crontab
```
![sample_run_gif](/media/daily_update_check.gif)
# update-wordpress.sh
Script used to update hosted wordpress websites. It iterates through all of them and updates them. A sample run follows (at the tim of the upload the websites were already up to date :p)

![sample_run_gif](/media/update-wordpress.gif)