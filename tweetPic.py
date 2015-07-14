import datetime, socket, sys
from twython import Twython

def tweet(msg):
        CONSUMER_KEY = "****"
        CONSUMER_SECRET = "****"
        ACCESS_KEY = "****"
        ACCESS_SECRET = "****"

        photo = open(sys.argv[1], 'rb')

        api = Twython(CONSUMER_KEY, CONSUMER_SECRET, ACCESS_KEY, ACCESS_SECRET)
        api.update_status_with_media(media=photo, status=msg)

def prepMSG():
        dt = datetime.datetime.now() # Import datetime to get around duplicate $
        message = "Date & Time: " + str(dt)
        return message

if __name__ == "__main__":
        msg = prepMSG()
        tweet(msg)
