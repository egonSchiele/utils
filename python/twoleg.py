# Very simple 2-leg OAuth.

import time
from hashlib import sha1
import hmac
import urllib as u
import binascii
from random import randint

class TwoLeg:
    def __init__(self, url, consumer_key, consumer_secret):
        self.request_url = url
        self.consumer_key = consumer_key
        self.consumer_secret = consumer_secret
    
    @property
    def nonce(self):
        return ''.join([str(randint(0, 9)) for i in range(10)])

    @property
    def signature(self):
        hashed = hmac.new(u.quote(self.consumer_secret) + "&", self.base_string, sha1)
        return binascii.b2a_base64(hashed.digest())[:-1]


    @property
    def query_string(self):
        # you might be wondering why I didn't use
        #     u.urlencode(self.params)
        # instead. The reason is, urlencode is not fucking deterministic with dicts.
        # So we have to force it to be, like so:
        return u.urlencode([(k, self.params[k]) for k in sorted(self.params.keys())])

    @property
    def base_string(self):
        return "&".join(["GET", u.quote(self.request_url, ""), u.quote(str(self.query_string))])

    def sign(self, hash):
        self.params = {
            'oauth_consumer_key' : self.consumer_key,
            'oauth_nonce' : self.nonce,
            'oauth_signature_method' : 'HMAC-SHA1',
            'oauth_timestamp' : str(int(time.time())),
            'oauth_version' : "1.0",
        }
        self.params.update(hash)
        self.params["oauth_signature"] = self.signature
            

        return self

    def merge_api_call_params(self, hash):
        self.params.update(hash)
        return self

    def api_call(self, hash):
        query_string = self.sign(hash).query_string
        sock = u.urlopen(self.request_url + "?" + query_string)
        return sock.read()


# try it with yahoo boss!
if __name__ == "__main__":
    KEY = "some key--"
    SECRET = "some secret"

    t = TwoLeg("http://yboss.yahooapis.com/ysearch/web", KEY, SECRET)

    args = {"format" : "json", "q" : "watch1", "count" : 10 }

    print t.api_call(args)


