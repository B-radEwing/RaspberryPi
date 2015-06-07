import socket
from twython import Twython

def tweet(msg):
        CONSUMER_KEY = "***"
        CONSUMER_SECRET = "***"
        ACCESS_KEY = "***"
        ACCESS_SECRET = "***"

        api = Twython(CONSUMER_KEY, CONSUMER_SECRET, ACCESS_KEY, ACCESS_SECRET)
        api.update_status(status=msg)

def getIP():
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect("github.com", 80)
        ip = s.getsockname()[0]
        s.close()

        return ip

if __name__ == "__main__":
        ip = getIP()
        tweet(ip)
