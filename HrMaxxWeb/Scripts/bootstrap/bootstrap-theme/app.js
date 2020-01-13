﻿(function () {
    function t(t, e) {
        function i() {
            this.constructor = t
        }
        for (var n in e) G.call(e, n) && (t[n] = e[n]);
        return i.prototype = e.prototype, t.prototype = new i, t.__super__ = e.prototype, t
    }
    var l, h, e, i, o, n, s, r, a, _, c, u, b, d, p, f, g, y, w, m, v, C, x, k, D, T, S, E, I, A, P, N, O, M, $, H, L, R, W, F, j, z, q, B, U, Y, K, V, X, Q = [].slice,
        G = {}.hasOwnProperty,
        J = [].indexOf || function (t) {
            for (var e = 0, i = this.length; e < i; e++)
                if (e in this && this[e] === t) return e;
            return -1
        };
    for (v = {
        catchupTime: 100,
        initialRate: .03,
        minTime: 250,
        ghostTime: 100,
        maxProgressPerFrame: 20,
        easeFactor: 1.25,
        startOnPageLoad: !0,
        restartOnPushState: !0,
        restartOnRequestAfter: 500,
        target: "body",
        elements: {
            checkInterval: 100,
            selectors: ["body"]
        },
        eventLag: {
            minSamples: 10,
            sampleCount: 3,
            lagThreshold: 3
        },
        ajax: {
            trackMethods: ["GET"],
            trackWebSockets: !0,
            ignoreURLs: []
        }
    }, I = function () {
        var t;
        return null != (t = "undefined" != typeof performance && null !== performance && "function" == typeof performance.now ? performance.now() : void 0) ? t : +new Date
    }, P = window.requestAnimationFrame || window.mozRequestAnimationFrame || window.webkitRequestAnimationFrame || window.msRequestAnimationFrame, m = window.cancelAnimationFrame || window.mozCancelAnimationFrame, null == P && (P = function (t) {
        return setTimeout(t, 50)
    }, m = function (t) {
        return clearTimeout(t)
    }), O = function (e) {
        var i, n;
        return i = I(), (n = function () {
            var t;
            return 33 <= (t = I() - i) ? (i = I(), e(t, function () {
                return P(n)
            })) : setTimeout(n, 33 - t)
        })()
    }, N = function () {
        var t, e, i;
        return i = arguments[0], e = arguments[1], t = 3 <= arguments.length ? Q.call(arguments, 2) : [], "function" == typeof i[e] ? i[e].apply(i, t) : i[e]
    }, C = function () {
        var t, e, i, n, s, o, r;
        for (e = arguments[0], o = 0, r = (n = 2 <= arguments.length ? Q.call(arguments, 1) : []).length; o < r; o++)
            if (i = n[o])
                for (t in i) G.call(i, t) && (s = i[t], null != e[t] && "object" == typeof e[t] && null != s && "object" == typeof s ? C(e[t], s) : e[t] = s);
        return e
    }, g = function (t) {
        var e, i, n, s, o;
        for (i = e = 0, s = 0, o = t.length; s < o; s++) n = t[s], i += Math.abs(n), e++;
        return i / e
    }, k = function (t, e) {
        var i, n;
        if (null == t && (t = "options"), null == e && (e = !0), n = document.querySelector("[data-pace-" + t + "]")) {
            if (i = n.getAttribute("data-pace-" + t), !e) return i;
            try {
                return JSON.parse(i)
            } catch (t) {
                return "undefined" != typeof console && null !== console ? console.error("Error parsing inline pace options", t) : void 0
            }
        }
    }, Z.prototype.on = function (t, e, i, n) {
        var s;
        return null == n && (n = !1), null == this.bindings && (this.bindings = {}), null == (s = this.bindings)[t] && (s[t] = []), this.bindings[t].push({
            handler: e,
            ctx: i,
            once: n
        })
    }, Z.prototype.once = function (t, e, i) {
        return this.on(t, e, i, !0)
    }, Z.prototype.off = function (t, e) {
        var i, n, s;
        if (null != (null != (n = this.bindings) ? n[t] : void 0)) {
            if (null == e) return delete this.bindings[t];
            for (i = 0, s = []; i < this.bindings[t].length;) this.bindings[t][i].handler === e ? s.push(this.bindings[t].splice(i, 1)) : s.push(i++);
            return s
        }
    }, Z.prototype.trigger = function () {
        var t, e, i, n, s, o, r, a, l;
        if (i = arguments[0], t = 2 <= arguments.length ? Q.call(arguments, 1) : [], null != (r = this.bindings) && r[i]) {
            for (s = 0, l = []; s < this.bindings[i].length;) n = (a = this.bindings[i][s]).handler, e = a.ctx, o = a.once, n.apply(null != e ? e : this, t), o ? l.push(this.bindings[i].splice(s, 1)) : l.push(s++);
            return l
        }
    }, s = Z, _ = window.Pace || {}, window.Pace = _, C(_, s.prototype), A = _.options = C({}, v, window.paceOptions, k()), q = 0, U = (K = ["ajax", "document", "eventLag", "elements"]).length; q < U; q++) !0 === A[L = K[q]] && (A[L] = v[L]);

    function Z() { }

    function tt(t) {
        this.source = t, this.last = this.sinceLastUpdate = 0, this.rate = A.initialRate, this.catchup = 0, this.progress = this.lastProgress = 0, null != this.source && (this.progress = N(this.source, "progress"))
    }

    function et() {
        var t, e, i = this;
        this.progress = null != (e = this.states[document.readyState]) ? e : 100, t = document.onreadystatechange, document.onreadystatechange = function () {
            return null != i.states[document.readyState] && (i.progress = i.states[document.readyState]), "function" == typeof t ? t.apply(null, arguments) : void 0
        }
    }

    function it(t) {
        this.selector = t, this.progress = 0, this.check()
    }

    function nt() {
        var t = this;
        this.elements = [], D().on("request", function () {
            return t.watch.apply(t, arguments)
        })
    }

    function st() {
        var i, o = this;
        st.__super__.constructor.apply(this, arguments), i = function (n) {
            var s;
            return s = n.open, n.open = function (t, e, i) {
                return H(t) && o.trigger("request", {
                    type: t,
                    url: e,
                    request: n
                }), s.apply(n, arguments)
            }
        }, window.XMLHttpRequest = function (t) {
            var e;
            return e = new z(t), i(e), e
        };
        try {
            x(window.XMLHttpRequest, z)
        } catch (t) { }
        if (null != j) {
            window.XDomainRequest = function () {
                var t;
                return t = new j, i(t), t
            };
            try {
                x(window.XDomainRequest, j)
            } catch (t) { }
        }
        if (null != F && A.ajax.trackWebSockets) {
            window.WebSocket = function (t, e) {
                var i;
                return i = null != e ? new F(t, e) : new F(t), H("socket") && o.trigger("request", {
                    type: "socket",
                    url: t,
                    protocols: e,
                    request: i
                }), i
            };
            try {
                x(window.WebSocket, F)
            } catch (t) { }
        }
    }

    function ot() {
        this.bindings = {}
    }

    function rt() {
        this.progress = 0
    }

    function at() {
        return at.__super__.constructor.apply(this, arguments)
    }
    X = Error, t(at, X), a = at, rt.prototype.getElement = function () {
        var t;
        if (null == this.el) {
            if (!(t = document.querySelector(A.target))) throw new a;
            this.el = document.createElement("div"), this.el.className = "pace pace-active", document.body.className = document.body.className.replace(/pace-done/g, ""), document.body.className += " pace-running", this.el.innerHTML = '<div class="pace-progress">\n  <div class="pace-progress-inner"></div>\n</div>\n<div class="pace-activity"></div>', null != t.firstChild ? t.insertBefore(this.el, t.firstChild) : t.appendChild(this.el)
        }
        return this.el
    }, rt.prototype.finish = function () {
        var t;
        return (t = this.getElement()).className = t.className.replace("pace-active", ""), t.className += " pace-inactive", document.body.className = document.body.className.replace("pace-running", ""), document.body.className += " pace-done"
    }, rt.prototype.update = function (t) {
        return this.progress = t, this.render()
    }, rt.prototype.destroy = function () {
        try {
            this.getElement().parentNode.removeChild(this.getElement())
        } catch (t) {
            a = t
        }
        return this.el = void 0
    }, rt.prototype.render = function () {
        var t, e, i, n, s, o, r;
        if (null == document.querySelector(A.target)) return !1;
        for (t = this.getElement(), n = "translate3d(" + this.progress + "%, 0, 0)", s = 0, o = (r = ["webkitTransform", "msTransform", "transform"]).length; s < o; s++) e = r[s], t.children[0].style[e] = n;
        return (!this.lastRenderedProgress || this.lastRenderedProgress | 0 !== this.progress | 0) && (t.children[0].setAttribute("data-progress-text", (0 | this.progress) + "%"), 100 <= this.progress ? i = "99" : (i = this.progress < 10 ? "0" : "", i += 0 | this.progress), t.children[0].setAttribute("data-progress", "" + i)), this.lastRenderedProgress = this.progress
    }, rt.prototype.done = function () {
        return 100 <= this.progress
    }, h = rt, ot.prototype.trigger = function (t, e) {
        var i, n, s, o, r;
        if (null != this.bindings[t]) {
            for (r = [], n = 0, s = (o = this.bindings[t]).length; n < s; n++) i = o[n], r.push(i.call(this, e));
            return r
        }
    }, ot.prototype.on = function (t, e) {
        var i;
        return null == (i = this.bindings)[t] && (i[t] = []), this.bindings[t].push(e)
    }, r = ot, z = window.XMLHttpRequest, j = window.XDomainRequest, F = window.WebSocket, x = function (t, e) {
        var i, n;
        for (i in n = [], e.prototype) try {
            null == t[i] && "function" != typeof e[i] ? "function" == typeof Object.defineProperty ? n.push(Object.defineProperty(t, i, {
                get: function () {
                    return e.prototype[i]
                },
                configurable: !0,
                enumerable: !0
            })) : n.push(t[i] = e.prototype[i]) : n.push(void 0)
        } catch (t) {
            0
        }
        return n
    }, S = [], _.ignore = function () {
        var t, e, i;
        return e = arguments[0], t = 2 <= arguments.length ? Q.call(arguments, 1) : [], S.unshift("ignore"), i = e.apply(null, t), S.shift(), i
    }, _.track = function () {
        var t, e, i;
        return e = arguments[0], t = 2 <= arguments.length ? Q.call(arguments, 1) : [], S.unshift("track"), i = e.apply(null, t), S.shift(), i
    }, H = function (t) {
        var e;
        if (null == t && (t = "GET"), "track" === S[0]) return "force";
        if (!S.length && A.ajax) {
            if ("socket" === t && A.ajax.trackWebSockets) return !0;
            if (e = t.toUpperCase(), 0 <= J.call(A.ajax.trackMethods, e)) return !0
        }
        return !1
    }, t(st, r), c = st, B = null, $ = function (t) {
        var e, i, n, s;
        for (i = 0, n = (s = A.ajax.ignoreURLs).length; i < n; i++)
            if ("string" == typeof (e = s[i])) {
                if (-1 !== t.indexOf(e)) return !0
            } else if (e.test(t)) return !0;
        return !1
    }, (D = function () {
        return null == B && (B = new c), B
    })().on("request", function (t) {
        var e, o, r, a, i;
        return a = t.type, r = t.request, i = t.url, $(i) || _.running || !1 === A.restartOnRequestAfter && "force" !== H(a) ? void 0 : (o = arguments, "boolean" == typeof (e = A.restartOnRequestAfter || 0) && (e = 0), setTimeout(function () {
            var t, e, i, n, s;
            if ("socket" === a ? r.readyState < 2 : 0 < (i = r.readyState) && i < 4) {
                for (_.restart(), s = [], t = 0, e = (n = _.sources).length; t < e; t++) {
                    if ((L = n[t]) instanceof l) {
                        L.watch.apply(L, o);
                        break
                    }
                    s.push(void 0)
                }
                return s
            }
        }, e))
    }), nt.prototype.watch = function (t) {
        var e, i, n, s;
        return n = t.type, e = t.request, s = t.url, $(s) ? void 0 : (i = new ("socket" === n ? d : p)(e), this.elements.push(i))
    }, l = nt, p = function (e) {
        var t, i, n, s, o, r = this;
        if (this.progress = 0, null != window.ProgressEvent)
            for (e.addEventListener("progress", function (t) {
                return t.lengthComputable ? r.progress = 100 * t.loaded / t.total : r.progress = r.progress + (100 - r.progress) / 2
            }, !1), i = 0, n = (o = ["load", "abort", "timeout", "error"]).length; i < n; i++) t = o[i], e.addEventListener(t, function () {
                return r.progress = 100
            }, !1);
        else s = e.onreadystatechange, e.onreadystatechange = function () {
            var t;
            return 0 === (t = e.readyState) || 4 === t ? r.progress = 100 : 3 === e.readyState && (r.progress = 50), "function" == typeof s ? s.apply(null, arguments) : void 0
        }
    }, d = function (t) {
        var e, i, n, s, o = this;
        for (i = this.progress = 0, n = (s = ["error", "open"]).length; i < n; i++) e = s[i], t.addEventListener(e, function () {
            return o.progress = 100
        }, !1)
    }, i = function (t) {
        var e, i, n, s;
        for (null == t && (t = {}), this.elements = [], null == t.selectors && (t.selectors = []), i = 0, n = (s = t.selectors).length; i < n; i++) e = s[i], this.elements.push(new o(e))
    }, it.prototype.check = function () {
        var t = this;
        return document.querySelector(this.selector) ? this.done() : setTimeout(function () {
            return t.check()
        }, A.elements.checkInterval)
    }, it.prototype.done = function () {
        return this.progress = 100
    }, o = it, et.prototype.states = {
        loading: 0,
        interactive: 50,
        complete: 100
    }, e = et, n = function () {
        var e, i, n, s, o, r = this;
        this.progress = 0, o = [], s = e = 0, n = I(), i = setInterval(function () {
            var t;
            return t = I() - n - 50, n = I(), o.push(t), o.length > A.eventLag.sampleCount && o.shift(), e = g(o), ++s >= A.eventLag.minSamples && e < A.eventLag.lagThreshold ? (r.progress = 100, clearInterval(i)) : r.progress = 3 / (e + 3) * 100
        }, 50)
    }, tt.prototype.tick = function (t, e) {
        var i;
        return null == e && (e = N(this.source, "progress")), 100 <= e && (this.done = !0), e === this.last ? this.sinceLastUpdate += t : (this.sinceLastUpdate && (this.rate = (e - this.last) / this.sinceLastUpdate), this.catchup = (e - this.progress) / A.catchupTime, this.sinceLastUpdate = 0, this.last = e), e > this.progress && (this.progress += this.catchup * t), i = 1 - Math.pow(this.progress / 100, A.easeFactor), this.progress += i * this.rate * t, this.progress = Math.min(this.lastProgress + A.maxProgressPerFrame, this.progress), this.progress = Math.max(0, this.progress), this.progress = Math.min(100, this.progress), this.lastProgress = this.progress, this.progress
    }, b = tt, w = f = W = y = M = R = null, _.running = !1, T = function () {
        return A.restartOnPushState ? _.restart() : void 0
    }, null != window.history.pushState && (Y = window.history.pushState, window.history.pushState = function () {
        return T(), Y.apply(window.history, arguments)
    }), null != window.history.replaceState && (V = window.history.replaceState, window.history.replaceState = function () {
        return T(), V.apply(window.history, arguments)
    }), u = {
        ajax: l,
        elements: i,
        document: e,
        eventLag: n
    }, (E = function () {
        var t, e, i, n, s, o, r, a;
        for (_.sources = R = [], e = 0, n = (o = ["ajax", "elements", "document", "eventLag"]).length; e < n; e++) !1 !== A[t = o[e]] && R.push(new u[t](A[t]));
        for (i = 0, s = (a = null != (r = A.extraSources) ? r : []).length; i < s; i++) L = a[i], R.push(new L(A));
        return _.bar = y = new h, M = [], W = new b
    })(), _.stop = function () {
        return _.trigger("stop"), _.running = !1, y.destroy(), w = !0, null != f && ("function" == typeof m && m(f), f = null), E()
    }, _.restart = function () {
        return _.trigger("restart"), _.stop(), _.start()
    }, _.go = function () {
        var v;
        return _.running = !0, y.render(), v = I(), w = !1, f = O(function (t, e) {
            var i, n, s, o, r, a, l, h, c, u, d, p, f, g, m;
            for (y.progress, n = u = 0, s = !0, a = d = 0, f = R.length; d < f; a = ++d)
                for (L = R[a], c = null != M[a] ? M[a] : M[a] = [], l = p = 0, g = (r = null != (m = L.elements) ? m : [L]).length; p < g; l = ++p) o = r[l], s &= (h = null != c[l] ? c[l] : c[l] = new b(o)).done, h.done || (n++ , u += h.tick(t));
            return i = u / n, y.update(W.tick(t, i)), y.done() || s || w ? (y.update(100), _.trigger("done"), setTimeout(function () {
                return y.finish(), _.running = !1, _.trigger("hide")
            }, Math.max(A.ghostTime, Math.max(A.minTime - (I() - v), 0)))) : e()
        })
    }, _.start = function (t) {
        C(A, t), _.running = !0;
        try {
            y.render()
        } catch (t) {
            a = t
        }
        return document.querySelector(".pace") ? (_.trigger("start"), _.go()) : setTimeout(_.start, 50)
    }, "function" == typeof define && define.amd ? define(["pace"], function () {
        return _
    }) : "object" == typeof exports ? module.exports = _ : A.startOnPageLoad && _.start()
}).call(this),
    function (t, e) {
        "use strict";
        "object" == typeof module && "object" == typeof module.exports ? module.exports = t.document ? e(t, !0) : function (t) {
            if (!t.document) throw new Error("jQuery requires a window with a document");
            return e(t)
        } : e(t)
    }("undefined" != typeof window ? window : this, function (x, t) {
        "use strict";

        function g(t) {
            return null != t && t === t.window
        }
        var e = [],
            k = x.document,
            n = Object.getPrototypeOf,
            a = e.slice,
            m = e.concat,
            l = e.push,
            s = e.indexOf,
            i = {},
            o = i.toString,
            v = i.hasOwnProperty,
            r = v.toString,
            h = r.call(Object),
            _ = {},
            b = function (t) {
                return "function" == typeof t && "number" != typeof t.nodeType
            },
            c = {
                type: !0,
                src: !0,
                nonce: !0,
                noModule: !0
            };

        function y(t, e, i) {
            var n, s, o = (i = i || k).createElement("script");
            if (o.text = t, e)
                for (n in c) (s = e[n] || e.getAttribute && e.getAttribute(n)) && o.setAttribute(n, s);
            i.head.appendChild(o).parentNode.removeChild(o)
        }

        function w(t) {
            return null == t ? t + "" : "object" == typeof t || "function" == typeof t ? i[o.call(t)] || "object" : typeof t
        }
        var D = function (t, e) {
            return new D.fn.init(t, e)
        },
            u = /^[\s\uFEFF\xA0]+|[\s\uFEFF\xA0]+$/g;

        function d(t) {
            var e = !!t && "length" in t && t.length,
                i = w(t);
            return !b(t) && !g(t) && ("array" === i || 0 === e || "number" == typeof e && 0 < e && e - 1 in t)
        }
        D.fn = D.prototype = {
            jquery: "3.4.1",
            constructor: D,
            length: 0,
            toArray: function () {
                return a.call(this)
            },
            get: function (t) {
                return null == t ? a.call(this) : t < 0 ? this[t + this.length] : this[t]
            },
            pushStack: function (t) {
                var e = D.merge(this.constructor(), t);
                return e.prevObject = this, e
            },
            each: function (t) {
                return D.each(this, t)
            },
            map: function (i) {
                return this.pushStack(D.map(this, function (t, e) {
                    return i.call(t, e, t)
                }))
            },
            slice: function () {
                return this.pushStack(a.apply(this, arguments))
            },
            first: function () {
                return this.eq(0)
            },
            last: function () {
                return this.eq(-1)
            },
            eq: function (t) {
                var e = this.length,
                    i = +t + (t < 0 ? e : 0);
                return this.pushStack(0 <= i && i < e ? [this[i]] : [])
            },
            end: function () {
                return this.prevObject || this.constructor()
            },
            push: l,
            sort: e.sort,
            splice: e.splice
        }, D.extend = D.fn.extend = function () {
            var t, e, i, n, s, o, r = arguments[0] || {},
                a = 1,
                l = arguments.length,
                h = !1;
            for ("boolean" == typeof r && (h = r, r = arguments[a] || {}, a++), "object" == typeof r || b(r) || (r = {}), a === l && (r = this, a--); a < l; a++)
                if (null != (t = arguments[a]))
                    for (e in t) n = t[e], "__proto__" !== e && r !== n && (h && n && (D.isPlainObject(n) || (s = Array.isArray(n))) ? (i = r[e], o = s && !Array.isArray(i) ? [] : s || D.isPlainObject(i) ? i : {}, s = !1, r[e] = D.extend(h, o, n)) : void 0 !== n && (r[e] = n));
            return r
        }, D.extend({
            expando: "jQuery" + ("3.4.1" + Math.random()).replace(/\D/g, ""),
            isReady: !0,
            error: function (t) {
                throw new Error(t)
            },
            noop: function () { },
            isPlainObject: function (t) {
                var e, i;
                return !(!t || "[object Object]" !== o.call(t) || (e = n(t)) && ("function" != typeof (i = v.call(e, "constructor") && e.constructor) || r.call(i) !== h))
            },
            isEmptyObject: function (t) {
                var e;
                for (e in t) return !1;
                return !0
            },
            globalEval: function (t, e) {
                y(t, {
                    nonce: e && e.nonce
                })
            },
            each: function (t, e) {
                var i, n = 0;
                if (d(t))
                    for (i = t.length; n < i && !1 !== e.call(t[n], n, t[n]); n++);
                else
                    for (n in t)
                        if (!1 === e.call(t[n], n, t[n])) break; return t
            },
            trim: function (t) {
                return null == t ? "" : (t + "").replace(u, "")
            },
            makeArray: function (t, e) {
                var i = e || [];
                return null != t && (d(Object(t)) ? D.merge(i, "string" == typeof t ? [t] : t) : l.call(i, t)), i
            },
            inArray: function (t, e, i) {
                return null == e ? -1 : s.call(e, t, i)
            },
            merge: function (t, e) {
                for (var i = +e.length, n = 0, s = t.length; n < i; n++) t[s++] = e[n];
                return t.length = s, t
            },
            grep: function (t, e, i) {
                for (var n = [], s = 0, o = t.length, r = !i; s < o; s++) !e(t[s], s) != r && n.push(t[s]);
                return n
            },
            map: function (t, e, i) {
                var n, s, o = 0,
                    r = [];
                if (d(t))
                    for (n = t.length; o < n; o++) null != (s = e(t[o], o, i)) && r.push(s);
                else
                    for (o in t) null != (s = e(t[o], o, i)) && r.push(s);
                return m.apply([], r)
            },
            guid: 1,
            support: _
        }), "function" == typeof Symbol && (D.fn[Symbol.iterator] = e[Symbol.iterator]), D.each("Boolean Number String Function Array Date RegExp Object Error Symbol".split(" "), function (t, e) {
            i["[object " + e + "]"] = e.toLowerCase()
        });
        var p = function (i) {
            function u(t, e, i) {
                var n = "0x" + e - 65536;
                return n != n || i ? e : n < 0 ? String.fromCharCode(65536 + n) : String.fromCharCode(n >> 10 | 55296, 1023 & n | 56320)
            }

            function s() {
                C()
            }
            var t, p, y, o, r, f, d, g, w, l, h, C, x, a, k, m, c, v, _, D = "sizzle" + +new Date,
                b = i.document,
                T = 0,
                n = 0,
                S = lt(),
                E = lt(),
                I = lt(),
                A = lt(),
                P = function (t, e) {
                    return t === e && (h = !0), 0
                },
                N = {}.hasOwnProperty,
                e = [],
                O = e.pop,
                M = e.push,
                $ = e.push,
                H = e.slice,
                L = function (t, e) {
                    for (var i = 0, n = t.length; i < n; i++)
                        if (t[i] === e) return i;
                    return -1
                },
                R = "checked|selected|async|autofocus|autoplay|controls|defer|disabled|hidden|ismap|loop|multiple|open|readonly|required|scoped",
                W = "[\\x20\\t\\r\\n\\f]",
                F = "(?:\\\\.|[\\w-]|[^\0-\\xa0])+",
                j = "\\[" + W + "*(" + F + ")(?:" + W + "*([*^$|!~]?=)" + W + "*(?:'((?:\\\\.|[^\\\\'])*)'|\"((?:\\\\.|[^\\\\\"])*)\"|(" + F + "))|)" + W + "*\\]",
                z = ":(" + F + ")(?:\\((('((?:\\\\.|[^\\\\'])*)'|\"((?:\\\\.|[^\\\\\"])*)\")|((?:\\\\.|[^\\\\()[\\]]|" + j + ")*)|.*)\\)|)",
                q = new RegExp(W + "+", "g"),
                B = new RegExp("^" + W + "+|((?:^|[^\\\\])(?:\\\\.)*)" + W + "+$", "g"),
                U = new RegExp("^" + W + "*," + W + "*"),
                Y = new RegExp("^" + W + "*([>+~]|" + W + ")" + W + "*"),
                K = new RegExp(W + "|>"),
                V = new RegExp(z),
                X = new RegExp("^" + F + "$"),
                Q = {
                    ID: new RegExp("^#(" + F + ")"),
                    CLASS: new RegExp("^\\.(" + F + ")"),
                    TAG: new RegExp("^(" + F + "|[*])"),
                    ATTR: new RegExp("^" + j),
                    PSEUDO: new RegExp("^" + z),
                    CHILD: new RegExp("^:(only|first|last|nth|nth-last)-(child|of-type)(?:\\(" + W + "*(even|odd|(([+-]|)(\\d*)n|)" + W + "*(?:([+-]|)" + W + "*(\\d+)|))" + W + "*\\)|)", "i"),
                    bool: new RegExp("^(?:" + R + ")$", "i"),
                    needsContext: new RegExp("^" + W + "*[>+~]|:(even|odd|eq|gt|lt|nth|first|last)(?:\\(" + W + "*((?:-\\d)?\\d*)" + W + "*\\)|)(?=[^-]|$)", "i")
                },
                G = /HTML$/i,
                J = /^(?:input|select|textarea|button)$/i,
                Z = /^h\d$/i,
                tt = /^[^{]+\{\s*\[native \w/,
                et = /^(?:#([\w-]+)|(\w+)|\.([\w-]+))$/,
                it = /[+~]/,
                nt = new RegExp("\\\\([\\da-f]{1,6}" + W + "?|(" + W + ")|.)", "ig"),
                st = /([\0-\x1f\x7f]|^-?\d)|^-$|[^\0-\x1f\x7f-\uFFFF\w-]/g,
                ot = function (t, e) {
                    return e ? "\0" === t ? "�" : t.slice(0, -1) + "\\" + t.charCodeAt(t.length - 1).toString(16) + " " : "\\" + t
                },
                rt = yt(function (t) {
                    return !0 === t.disabled && "fieldset" === t.nodeName.toLowerCase()
                }, {
                    dir: "parentNode",
                    next: "legend"
                });
            try {
                $.apply(e = H.call(b.childNodes), b.childNodes), e[b.childNodes.length].nodeType
            } catch (t) {
                $ = {
                    apply: e.length ? function (t, e) {
                        M.apply(t, H.call(e))
                    } : function (t, e) {
                        for (var i = t.length, n = 0; t[i++] = e[n++];);
                        t.length = i - 1
                    }
                }
            }

            function at(t, e, i, n) {
                var s, o, r, a, l, h, c, u = e && e.ownerDocument,
                    d = e ? e.nodeType : 9;
                if (i = i || [], "string" != typeof t || !t || 1 !== d && 9 !== d && 11 !== d) return i;
                if (!n && ((e ? e.ownerDocument || e : b) !== x && C(e), e = e || x, k)) {
                    if (11 !== d && (l = et.exec(t)))
                        if (s = l[1]) {
                            if (9 === d) {
                                if (!(r = e.getElementById(s))) return i;
                                if (r.id === s) return i.push(r), i
                            } else if (u && (r = u.getElementById(s)) && _(e, r) && r.id === s) return i.push(r), i
                        } else {
                            if (l[2]) return $.apply(i, e.getElementsByTagName(t)), i;
                            if ((s = l[3]) && p.getElementsByClassName && e.getElementsByClassName) return $.apply(i, e.getElementsByClassName(s)), i
                        }
                    if (p.qsa && !A[t + " "] && (!m || !m.test(t)) && (1 !== d || "object" !== e.nodeName.toLowerCase())) {
                        if (c = t, u = e, 1 === d && K.test(t)) {
                            for ((a = e.getAttribute("id")) ? a = a.replace(st, ot) : e.setAttribute("id", a = D), o = (h = f(t)).length; o--;) h[o] = "#" + a + " " + bt(h[o]);
                            c = h.join(","), u = it.test(t) && vt(e.parentNode) || e
                        }
                        try {
                            return $.apply(i, u.querySelectorAll(c)), i
                        } catch (e) {
                            A(t, !0)
                        } finally {
                            a === D && e.removeAttribute("id")
                        }
                    }
                }
                return g(t.replace(B, "$1"), e, i, n)
            }

            function lt() {
                var n = [];
                return function t(e, i) {
                    return n.push(e + " ") > y.cacheLength && delete t[n.shift()], t[e + " "] = i
                }
            }

            function ht(t) {
                return t[D] = !0, t
            }

            function ct(t) {
                var e = x.createElement("fieldset");
                try {
                    return !!t(e)
                } catch (t) {
                    return !1
                } finally {
                    e.parentNode && e.parentNode.removeChild(e), e = null
                }
            }

            function ut(t, e) {
                for (var i = t.split("|"), n = i.length; n--;) y.attrHandle[i[n]] = e
            }

            function dt(t, e) {
                var i = e && t,
                    n = i && 1 === t.nodeType && 1 === e.nodeType && t.sourceIndex - e.sourceIndex;
                if (n) return n;
                if (i)
                    for (; i = i.nextSibling;)
                        if (i === e) return -1;
                return t ? 1 : -1
            }

            function pt(e) {
                return function (t) {
                    return "input" === t.nodeName.toLowerCase() && t.type === e
                }
            }

            function ft(i) {
                return function (t) {
                    var e = t.nodeName.toLowerCase();
                    return ("input" === e || "button" === e) && t.type === i
                }
            }

            function gt(e) {
                return function (t) {
                    return "form" in t ? t.parentNode && !1 === t.disabled ? "label" in t ? "label" in t.parentNode ? t.parentNode.disabled === e : t.disabled === e : t.isDisabled === e || t.isDisabled !== !e && rt(t) === e : t.disabled === e : "label" in t && t.disabled === e
                }
            }

            function mt(r) {
                return ht(function (o) {
                    return o = +o, ht(function (t, e) {
                        for (var i, n = r([], t.length, o), s = n.length; s--;) t[i = n[s]] && (t[i] = !(e[i] = t[i]))
                    })
                })
            }

            function vt(t) {
                return t && void 0 !== t.getElementsByTagName && t
            }
            for (t in p = at.support = {}, r = at.isXML = function (t) {
                var e = t.namespaceURI,
                    i = (t.ownerDocument || t).documentElement;
                return !G.test(e || i && i.nodeName || "HTML")
            }, C = at.setDocument = function (t) {
                var e, i, n = t ? t.ownerDocument || t : b;
                return n !== x && 9 === n.nodeType && n.documentElement && (a = (x = n).documentElement, k = !r(x), b !== x && (i = x.defaultView) && i.top !== i && (i.addEventListener ? i.addEventListener("unload", s, !1) : i.attachEvent && i.attachEvent("onunload", s)), p.attributes = ct(function (t) {
                    return t.className = "i", !t.getAttribute("className")
                }), p.getElementsByTagName = ct(function (t) {
                    return t.appendChild(x.createComment("")), !t.getElementsByTagName("*").length
                }), p.getElementsByClassName = tt.test(x.getElementsByClassName), p.getById = ct(function (t) {
                    return a.appendChild(t).id = D, !x.getElementsByName || !x.getElementsByName(D).length
                }), p.getById ? (y.filter.ID = function (t) {
                    var e = t.replace(nt, u);
                    return function (t) {
                        return t.getAttribute("id") === e
                    }
                }, y.find.ID = function (t, e) {
                    if (void 0 !== e.getElementById && k) {
                        var i = e.getElementById(t);
                        return i ? [i] : []
                    }
                }) : (y.filter.ID = function (t) {
                    var i = t.replace(nt, u);
                    return function (t) {
                        var e = void 0 !== t.getAttributeNode && t.getAttributeNode("id");
                        return e && e.value === i
                    }
                }, y.find.ID = function (t, e) {
                    if (void 0 !== e.getElementById && k) {
                        var i, n, s, o = e.getElementById(t);
                        if (o) {
                            if ((i = o.getAttributeNode("id")) && i.value === t) return [o];
                            for (s = e.getElementsByName(t), n = 0; o = s[n++];)
                                if ((i = o.getAttributeNode("id")) && i.value === t) return [o]
                        }
                        return []
                    }
                }), y.find.TAG = p.getElementsByTagName ? function (t, e) {
                    return void 0 !== e.getElementsByTagName ? e.getElementsByTagName(t) : p.qsa ? e.querySelectorAll(t) : void 0
                } : function (t, e) {
                    var i, n = [],
                        s = 0,
                        o = e.getElementsByTagName(t);
                    if ("*" !== t) return o;
                    for (; i = o[s++];) 1 === i.nodeType && n.push(i);
                    return n
                }, y.find.CLASS = p.getElementsByClassName && function (t, e) {
                    if (void 0 !== e.getElementsByClassName && k) return e.getElementsByClassName(t)
                }, c = [], m = [], (p.qsa = tt.test(x.querySelectorAll)) && (ct(function (t) {
                    a.appendChild(t).innerHTML = "<a id='" + D + "'></a><select id='" + D + "-\r\\' msallowcapture=''><option selected=''></option></select>", t.querySelectorAll("[msallowcapture^='']").length && m.push("[*^$]=" + W + "*(?:''|\"\")"), t.querySelectorAll("[selected]").length || m.push("\\[" + W + "*(?:value|" + R + ")"), t.querySelectorAll("[id~=" + D + "-]").length || m.push("~="), t.querySelectorAll(":checked").length || m.push(":checked"), t.querySelectorAll("a#" + D + "+*").length || m.push(".#.+[+~]")
                }), ct(function (t) {
                    t.innerHTML = "<a href='' disabled='disabled'></a><select disabled='disabled'><option/></select>";
                    var e = x.createElement("input");
                    e.setAttribute("type", "hidden"), t.appendChild(e).setAttribute("name", "D"), t.querySelectorAll("[name=d]").length && m.push("name" + W + "*[*^$|!~]?="), 2 !== t.querySelectorAll(":enabled").length && m.push(":enabled", ":disabled"), a.appendChild(t).disabled = !0, 2 !== t.querySelectorAll(":disabled").length && m.push(":enabled", ":disabled"), t.querySelectorAll("*,:x"), m.push(",.*:")
                })), (p.matchesSelector = tt.test(v = a.matches || a.webkitMatchesSelector || a.mozMatchesSelector || a.oMatchesSelector || a.msMatchesSelector)) && ct(function (t) {
                    p.disconnectedMatch = v.call(t, "*"), v.call(t, "[s!='']:x"), c.push("!=", z)
                }), m = m.length && new RegExp(m.join("|")), c = c.length && new RegExp(c.join("|")), e = tt.test(a.compareDocumentPosition), _ = e || tt.test(a.contains) ? function (t, e) {
                    var i = 9 === t.nodeType ? t.documentElement : t,
                        n = e && e.parentNode;
                    return t === n || !(!n || 1 !== n.nodeType || !(i.contains ? i.contains(n) : t.compareDocumentPosition && 16 & t.compareDocumentPosition(n)))
                } : function (t, e) {
                    if (e)
                        for (; e = e.parentNode;)
                            if (e === t) return !0;
                    return !1
                }, P = e ? function (t, e) {
                    if (t === e) return h = !0, 0;
                    var i = !t.compareDocumentPosition - !e.compareDocumentPosition;
                    return i || (1 & (i = (t.ownerDocument || t) === (e.ownerDocument || e) ? t.compareDocumentPosition(e) : 1) || !p.sortDetached && e.compareDocumentPosition(t) === i ? t === x || t.ownerDocument === b && _(b, t) ? -1 : e === x || e.ownerDocument === b && _(b, e) ? 1 : l ? L(l, t) - L(l, e) : 0 : 4 & i ? -1 : 1)
                } : function (t, e) {
                    if (t === e) return h = !0, 0;
                    var i, n = 0,
                        s = t.parentNode,
                        o = e.parentNode,
                        r = [t],
                        a = [e];
                    if (!s || !o) return t === x ? -1 : e === x ? 1 : s ? -1 : o ? 1 : l ? L(l, t) - L(l, e) : 0;
                    if (s === o) return dt(t, e);
                    for (i = t; i = i.parentNode;) r.unshift(i);
                    for (i = e; i = i.parentNode;) a.unshift(i);
                    for (; r[n] === a[n];) n++;
                    return n ? dt(r[n], a[n]) : r[n] === b ? -1 : a[n] === b ? 1 : 0
                }), x
            }, at.matches = function (t, e) {
                return at(t, null, null, e)
            }, at.matchesSelector = function (t, e) {
                if ((t.ownerDocument || t) !== x && C(t), p.matchesSelector && k && !A[e + " "] && (!c || !c.test(e)) && (!m || !m.test(e))) try {
                    var i = v.call(t, e);
                    if (i || p.disconnectedMatch || t.document && 11 !== t.document.nodeType) return i
                } catch (t) {
                    A(e, !0)
                }
                return 0 < at(e, x, null, [t]).length
            }, at.contains = function (t, e) {
                return (t.ownerDocument || t) !== x && C(t), _(t, e)
            }, at.attr = function (t, e) {
                (t.ownerDocument || t) !== x && C(t);
                var i = y.attrHandle[e.toLowerCase()],
                    n = i && N.call(y.attrHandle, e.toLowerCase()) ? i(t, e, !k) : void 0;
                return void 0 !== n ? n : p.attributes || !k ? t.getAttribute(e) : (n = t.getAttributeNode(e)) && n.specified ? n.value : null
            }, at.escape = function (t) {
                return (t + "").replace(st, ot)
            }, at.error = function (t) {
                throw new Error("Syntax error, unrecognized expression: " + t)
            }, at.uniqueSort = function (t) {
                var e, i = [],
                    n = 0,
                    s = 0;
                if (h = !p.detectDuplicates, l = !p.sortStable && t.slice(0), t.sort(P), h) {
                    for (; e = t[s++];) e === t[s] && (n = i.push(s));
                    for (; n--;) t.splice(i[n], 1)
                }
                return l = null, t
            }, o = at.getText = function (t) {
                var e, i = "",
                    n = 0,
                    s = t.nodeType;
                if (s) {
                    if (1 === s || 9 === s || 11 === s) {
                        if ("string" == typeof t.textContent) return t.textContent;
                        for (t = t.firstChild; t; t = t.nextSibling) i += o(t)
                    } else if (3 === s || 4 === s) return t.nodeValue
                } else
                    for (; e = t[n++];) i += o(e);
                return i
            }, (y = at.selectors = {
                cacheLength: 50,
                createPseudo: ht,
                match: Q,
                attrHandle: {},
                find: {},
                relative: {
                    ">": {
                        dir: "parentNode",
                        first: !0
                    },
                    " ": {
                        dir: "parentNode"
                    },
                    "+": {
                        dir: "previousSibling",
                        first: !0
                    },
                    "~": {
                        dir: "previousSibling"
                    }
                },
                preFilter: {
                    ATTR: function (t) {
                        return t[1] = t[1].replace(nt, u), t[3] = (t[3] || t[4] || t[5] || "").replace(nt, u), "~=" === t[2] && (t[3] = " " + t[3] + " "), t.slice(0, 4)
                    },
                    CHILD: function (t) {
                        return t[1] = t[1].toLowerCase(), "nth" === t[1].slice(0, 3) ? (t[3] || at.error(t[0]), t[4] = +(t[4] ? t[5] + (t[6] || 1) : 2 * ("even" === t[3] || "odd" === t[3])), t[5] = +(t[7] + t[8] || "odd" === t[3])) : t[3] && at.error(t[0]), t
                    },
                    PSEUDO: function (t) {
                        var e, i = !t[6] && t[2];
                        return Q.CHILD.test(t[0]) ? null : (t[3] ? t[2] = t[4] || t[5] || "" : i && V.test(i) && (e = f(i, !0)) && (e = i.indexOf(")", i.length - e) - i.length) && (t[0] = t[0].slice(0, e), t[2] = i.slice(0, e)), t.slice(0, 3))
                    }
                },
                filter: {
                    TAG: function (t) {
                        var e = t.replace(nt, u).toLowerCase();
                        return "*" === t ? function () {
                            return !0
                        } : function (t) {
                            return t.nodeName && t.nodeName.toLowerCase() === e
                        }
                    },
                    CLASS: function (t) {
                        var e = S[t + " "];
                        return e || (e = new RegExp("(^|" + W + ")" + t + "(" + W + "|$)")) && S(t, function (t) {
                            return e.test("string" == typeof t.className && t.className || void 0 !== t.getAttribute && t.getAttribute("class") || "")
                        })
                    },
                    ATTR: function (i, n, s) {
                        return function (t) {
                            var e = at.attr(t, i);
                            return null == e ? "!=" === n : !n || (e += "", "=" === n ? e === s : "!=" === n ? e !== s : "^=" === n ? s && 0 === e.indexOf(s) : "*=" === n ? s && -1 < e.indexOf(s) : "$=" === n ? s && e.slice(-s.length) === s : "~=" === n ? -1 < (" " + e.replace(q, " ") + " ").indexOf(s) : "|=" === n && (e === s || e.slice(0, s.length + 1) === s + "-"))
                        }
                    },
                    CHILD: function (f, t, e, g, m) {
                        var v = "nth" !== f.slice(0, 3),
                            _ = "last" !== f.slice(-4),
                            b = "of-type" === t;
                        return 1 === g && 0 === m ? function (t) {
                            return !!t.parentNode
                        } : function (t, e, i) {
                            var n, s, o, r, a, l, h = v != _ ? "nextSibling" : "previousSibling",
                                c = t.parentNode,
                                u = b && t.nodeName.toLowerCase(),
                                d = !i && !b,
                                p = !1;
                            if (c) {
                                if (v) {
                                    for (; h;) {
                                        for (r = t; r = r[h];)
                                            if (b ? r.nodeName.toLowerCase() === u : 1 === r.nodeType) return !1;
                                        l = h = "only" === f && !l && "nextSibling"
                                    }
                                    return !0
                                }
                                if (l = [_ ? c.firstChild : c.lastChild], _ && d) {
                                    for (p = (a = (n = (s = (o = (r = c)[D] || (r[D] = {}))[r.uniqueID] || (o[r.uniqueID] = {}))[f] || [])[0] === T && n[1]) && n[2], r = a && c.childNodes[a]; r = ++a && r && r[h] || (p = a = 0) || l.pop();)
                                        if (1 === r.nodeType && ++p && r === t) {
                                            s[f] = [T, a, p];
                                            break
                                        }
                                } else if (d && (p = a = (n = (s = (o = (r = t)[D] || (r[D] = {}))[r.uniqueID] || (o[r.uniqueID] = {}))[f] || [])[0] === T && n[1]), !1 === p)
                                    for (;
                                        (r = ++a && r && r[h] || (p = a = 0) || l.pop()) && ((b ? r.nodeName.toLowerCase() !== u : 1 !== r.nodeType) || !++p || (d && ((s = (o = r[D] || (r[D] = {}))[r.uniqueID] || (o[r.uniqueID] = {}))[f] = [T, p]), r !== t)););
                                return (p -= m) === g || p % g == 0 && 0 <= p / g
                            }
                        }
                    },
                    PSEUDO: function (t, o) {
                        var e, r = y.pseudos[t] || y.setFilters[t.toLowerCase()] || at.error("unsupported pseudo: " + t);
                        return r[D] ? r(o) : 1 < r.length ? (e = [t, t, "", o], y.setFilters.hasOwnProperty(t.toLowerCase()) ? ht(function (t, e) {
                            for (var i, n = r(t, o), s = n.length; s--;) t[i = L(t, n[s])] = !(e[i] = n[s])
                        }) : function (t) {
                            return r(t, 0, e)
                        }) : r
                    }
                },
                pseudos: {
                    not: ht(function (t) {
                        var n = [],
                            s = [],
                            a = d(t.replace(B, "$1"));
                        return a[D] ? ht(function (t, e, i, n) {
                            for (var s, o = a(t, null, n, []), r = t.length; r--;)(s = o[r]) && (t[r] = !(e[r] = s))
                        }) : function (t, e, i) {
                            return n[0] = t, a(n, null, i, s), n[0] = null, !s.pop()
                        }
                    }),
                    has: ht(function (e) {
                        return function (t) {
                            return 0 < at(e, t).length
                        }
                    }),
                    contains: ht(function (e) {
                        return e = e.replace(nt, u),
                            function (t) {
                                return -1 < (t.textContent || o(t)).indexOf(e)
                            }
                    }),
                    lang: ht(function (i) {
                        return X.test(i || "") || at.error("unsupported lang: " + i), i = i.replace(nt, u).toLowerCase(),
                            function (t) {
                                var e;
                                do {
                                    if (e = k ? t.lang : t.getAttribute("xml:lang") || t.getAttribute("lang")) return (e = e.toLowerCase()) === i || 0 === e.indexOf(i + "-")
                                } while ((t = t.parentNode) && 1 === t.nodeType);
                                return !1
                            }
                    }),
                    target: function (t) {
                        var e = i.location && i.location.hash;
                        return e && e.slice(1) === t.id
                    },
                    root: function (t) {
                        return t === a
                    },
                    focus: function (t) {
                        return t === x.activeElement && (!x.hasFocus || x.hasFocus()) && !!(t.type || t.href || ~t.tabIndex)
                    },
                    enabled: gt(!1),
                    disabled: gt(!0),
                    checked: function (t) {
                        var e = t.nodeName.toLowerCase();
                        return "input" === e && !!t.checked || "option" === e && !!t.selected
                    },
                    selected: function (t) {
                        return t.parentNode && t.parentNode.selectedIndex, !0 === t.selected
                    },
                    empty: function (t) {
                        for (t = t.firstChild; t; t = t.nextSibling)
                            if (t.nodeType < 6) return !1;
                        return !0
                    },
                    parent: function (t) {
                        return !y.pseudos.empty(t)
                    },
                    header: function (t) {
                        return Z.test(t.nodeName)
                    },
                    input: function (t) {
                        return J.test(t.nodeName)
                    },
                    button: function (t) {
                        var e = t.nodeName.toLowerCase();
                        return "input" === e && "button" === t.type || "button" === e
                    },
                    text: function (t) {
                        var e;
                        return "input" === t.nodeName.toLowerCase() && "text" === t.type && (null == (e = t.getAttribute("type")) || "text" === e.toLowerCase())
                    },
                    first: mt(function () {
                        return [0]
                    }),
                    last: mt(function (t, e) {
                        return [e - 1]
                    }),
                    eq: mt(function (t, e, i) {
                        return [i < 0 ? i + e : i]
                    }),
                    even: mt(function (t, e) {
                        for (var i = 0; i < e; i += 2) t.push(i);
                        return t
                    }),
                    odd: mt(function (t, e) {
                        for (var i = 1; i < e; i += 2) t.push(i);
                        return t
                    }),
                    lt: mt(function (t, e, i) {
                        for (var n = i < 0 ? i + e : e < i ? e : i; 0 <= --n;) t.push(n);
                        return t
                    }),
                    gt: mt(function (t, e, i) {
                        for (var n = i < 0 ? i + e : i; ++n < e;) t.push(n);
                        return t
                    })
                }
            }).pseudos.nth = y.pseudos.eq, {
                radio: !0,
                checkbox: !0,
                file: !0,
                password: !0,
                image: !0
            }) y.pseudos[t] = pt(t);
            for (t in {
                submit: !0,
                reset: !0
            }) y.pseudos[t] = ft(t);

            function _t() { }

            function bt(t) {
                for (var e = 0, i = t.length, n = ""; e < i; e++) n += t[e].value;
                return n
            }

            function yt(a, t, e) {
                var l = t.dir,
                    h = t.next,
                    c = h || l,
                    u = e && "parentNode" === c,
                    d = n++;
                return t.first ? function (t, e, i) {
                    for (; t = t[l];)
                        if (1 === t.nodeType || u) return a(t, e, i);
                    return !1
                } : function (t, e, i) {
                    var n, s, o, r = [T, d];
                    if (i) {
                        for (; t = t[l];)
                            if ((1 === t.nodeType || u) && a(t, e, i)) return !0
                    } else
                        for (; t = t[l];)
                            if (1 === t.nodeType || u)
                                if (s = (o = t[D] || (t[D] = {}))[t.uniqueID] || (o[t.uniqueID] = {}), h && h === t.nodeName.toLowerCase()) t = t[l] || t;
                                else {
                                    if ((n = s[c]) && n[0] === T && n[1] === d) return r[2] = n[2];
                                    if ((s[c] = r)[2] = a(t, e, i)) return !0
                                } return !1
                }
            }

            function wt(s) {
                return 1 < s.length ? function (t, e, i) {
                    for (var n = s.length; n--;)
                        if (!s[n](t, e, i)) return !1;
                    return !0
                } : s[0]
            }

            function Ct(t, e, i, n, s) {
                for (var o, r = [], a = 0, l = t.length, h = null != e; a < l; a++)(o = t[a]) && (i && !i(o, n, s) || (r.push(o), h && e.push(a)));
                return r
            }

            function xt(p, f, g, m, v, t) {
                return m && !m[D] && (m = xt(m)), v && !v[D] && (v = xt(v, t)), ht(function (t, e, i, n) {
                    var s, o, r, a = [],
                        l = [],
                        h = e.length,
                        c = t || function (t, e, i) {
                            for (var n = 0, s = e.length; n < s; n++) at(t, e[n], i);
                            return i
                        }(f || "*", i.nodeType ? [i] : i, []),
                        u = !p || !t && f ? c : Ct(c, a, p, i, n),
                        d = g ? v || (t ? p : h || m) ? [] : e : u;
                    if (g && g(u, d, i, n), m)
                        for (s = Ct(d, l), m(s, [], i, n), o = s.length; o--;)(r = s[o]) && (d[l[o]] = !(u[l[o]] = r));
                    if (t) {
                        if (v || p) {
                            if (v) {
                                for (s = [], o = d.length; o--;)(r = d[o]) && s.push(u[o] = r);
                                v(null, d = [], s, n)
                            }
                            for (o = d.length; o--;)(r = d[o]) && -1 < (s = v ? L(t, r) : a[o]) && (t[s] = !(e[s] = r))
                        }
                    } else d = Ct(d === e ? d.splice(h, d.length) : d), v ? v(null, e, d, n) : $.apply(e, d)
                })
            }

            function kt(t) {
                for (var s, e, i, n = t.length, o = y.relative[t[0].type], r = o || y.relative[" "], a = o ? 1 : 0, l = yt(function (t) {
                    return t === s
                }, r, !0), h = yt(function (t) {
                    return -1 < L(s, t)
                }, r, !0), c = [function (t, e, i) {
                    var n = !o && (i || e !== w) || ((s = e).nodeType ? l : h)(t, e, i);
                    return s = null, n
                }]; a < n; a++)
                    if (e = y.relative[t[a].type]) c = [yt(wt(c), e)];
                    else {
                        if ((e = y.filter[t[a].type].apply(null, t[a].matches))[D]) {
                            for (i = ++a; i < n && !y.relative[t[i].type]; i++);
                            return xt(1 < a && wt(c), 1 < a && bt(t.slice(0, a - 1).concat({
                                value: " " === t[a - 2].type ? "*" : ""
                            })).replace(B, "$1"), e, a < i && kt(t.slice(a, i)), i < n && kt(t = t.slice(i)), i < n && bt(t))
                        }
                        c.push(e)
                    }
                return wt(c)
            }
            return _t.prototype = y.filters = y.pseudos, y.setFilters = new _t, f = at.tokenize = function (t, e) {
                var i, n, s, o, r, a, l, h = E[t + " "];
                if (h) return e ? 0 : h.slice(0);
                for (r = t, a = [], l = y.preFilter; r;) {
                    for (o in i && !(n = U.exec(r)) || (n && (r = r.slice(n[0].length) || r), a.push(s = [])), i = !1, (n = Y.exec(r)) && (i = n.shift(), s.push({
                        value: i,
                        type: n[0].replace(B, " ")
                    }), r = r.slice(i.length)), y.filter) !(n = Q[o].exec(r)) || l[o] && !(n = l[o](n)) || (i = n.shift(), s.push({
                        value: i,
                        type: o,
                        matches: n
                    }), r = r.slice(i.length));
                    if (!i) break
                }
                return e ? r.length : r ? at.error(t) : E(t, a).slice(0)
            }, d = at.compile = function (t, e) {
                var i, m, v, _, b, n, s = [],
                    o = [],
                    r = I[t + " "];
                if (!r) {
                    for (i = (e = e || f(t)).length; i--;)(r = kt(e[i]))[D] ? s.push(r) : o.push(r);
                    (r = I(t, (m = o, _ = 0 < (v = s).length, b = 0 < m.length, n = function (t, e, i, n, s) {
                        var o, r, a, l = 0,
                            h = "0",
                            c = t && [],
                            u = [],
                            d = w,
                            p = t || b && y.find.TAG("*", s),
                            f = T += null == d ? 1 : Math.random() || .1,
                            g = p.length;
                        for (s && (w = e === x || e || s); h !== g && null != (o = p[h]); h++) {
                            if (b && o) {
                                for (r = 0, e || o.ownerDocument === x || (C(o), i = !k); a = m[r++];)
                                    if (a(o, e || x, i)) {
                                        n.push(o);
                                        break
                                    }
                                s && (T = f)
                            }
                            _ && ((o = !a && o) && l-- , t && c.push(o))
                        }
                        if (l += h, _ && h !== l) {
                            for (r = 0; a = v[r++];) a(c, u, e, i);
                            if (t) {
                                if (0 < l)
                                    for (; h--;) c[h] || u[h] || (u[h] = O.call(n));
                                u = Ct(u)
                            }
                            $.apply(n, u), s && !t && 0 < u.length && 1 < l + v.length && at.uniqueSort(n)
                        }
                        return s && (T = f, w = d), c
                    }, _ ? ht(n) : n))).selector = t
                }
                return r
            }, g = at.select = function (t, e, i, n) {
                var s, o, r, a, l, h = "function" == typeof t && t,
                    c = !n && f(t = h.selector || t);
                if (i = i || [], 1 === c.length) {
                    if (2 < (o = c[0] = c[0].slice(0)).length && "ID" === (r = o[0]).type && 9 === e.nodeType && k && y.relative[o[1].type]) {
                        if (!(e = (y.find.ID(r.matches[0].replace(nt, u), e) || [])[0])) return i;
                        h && (e = e.parentNode), t = t.slice(o.shift().value.length)
                    }
                    for (s = Q.needsContext.test(t) ? 0 : o.length; s-- && (r = o[s], !y.relative[a = r.type]);)
                        if ((l = y.find[a]) && (n = l(r.matches[0].replace(nt, u), it.test(o[0].type) && vt(e.parentNode) || e))) {
                            if (o.splice(s, 1), !(t = n.length && bt(o))) return $.apply(i, n), i;
                            break
                        }
                }
                return (h || d(t, c))(n, e, !k, i, !e || it.test(t) && vt(e.parentNode) || e), i
            }, p.sortStable = D.split("").sort(P).join("") === D, p.detectDuplicates = !!h, C(), p.sortDetached = ct(function (t) {
                return 1 & t.compareDocumentPosition(x.createElement("fieldset"))
            }), ct(function (t) {
                return t.innerHTML = "<a href='#'></a>", "#" === t.firstChild.getAttribute("href")
            }) || ut("type|href|height|width", function (t, e, i) {
                if (!i) return t.getAttribute(e, "type" === e.toLowerCase() ? 1 : 2)
            }), p.attributes && ct(function (t) {
                return t.innerHTML = "<input/>", t.firstChild.setAttribute("value", ""), "" === t.firstChild.getAttribute("value")
            }) || ut("value", function (t, e, i) {
                if (!i && "input" === t.nodeName.toLowerCase()) return t.defaultValue
            }), ct(function (t) {
                return null == t.getAttribute("disabled")
            }) || ut(R, function (t, e, i) {
                var n;
                if (!i) return !0 === t[e] ? e.toLowerCase() : (n = t.getAttributeNode(e)) && n.specified ? n.value : null
            }), at
        }(x);
        D.find = p, D.expr = p.selectors, D.expr[":"] = D.expr.pseudos, D.uniqueSort = D.unique = p.uniqueSort, D.text = p.getText, D.isXMLDoc = p.isXML, D.contains = p.contains, D.escapeSelector = p.escape;

        function f(t, e, i) {
            for (var n = [], s = void 0 !== i;
                (t = t[e]) && 9 !== t.nodeType;)
                if (1 === t.nodeType) {
                    if (s && D(t).is(i)) break;
                    n.push(t)
                }
            return n
        }

        function C(t, e) {
            for (var i = []; t; t = t.nextSibling) 1 === t.nodeType && t !== e && i.push(t);
            return i
        }
        var T = D.expr.match.needsContext;

        function S(t, e) {
            return t.nodeName && t.nodeName.toLowerCase() === e.toLowerCase()
        }
        var E = /^<([a-z][^\/\0>:\x20\t\r\n\f]*)[\x20\t\r\n\f]*\/?>(?:<\/\1>|)$/i;

        function I(t, i, n) {
            return b(i) ? D.grep(t, function (t, e) {
                return !!i.call(t, e, t) !== n
            }) : i.nodeType ? D.grep(t, function (t) {
                return t === i !== n
            }) : "string" != typeof i ? D.grep(t, function (t) {
                return -1 < s.call(i, t) !== n
            }) : D.filter(i, t, n)
        }
        D.filter = function (t, e, i) {
            var n = e[0];
            return i && (t = ":not(" + t + ")"), 1 === e.length && 1 === n.nodeType ? D.find.matchesSelector(n, t) ? [n] : [] : D.find.matches(t, D.grep(e, function (t) {
                return 1 === t.nodeType
            }))
        }, D.fn.extend({
            find: function (t) {
                var e, i, n = this.length,
                    s = this;
                if ("string" != typeof t) return this.pushStack(D(t).filter(function () {
                    for (e = 0; e < n; e++)
                        if (D.contains(s[e], this)) return !0
                }));
                for (i = this.pushStack([]), e = 0; e < n; e++) D.find(t, s[e], i);
                return 1 < n ? D.uniqueSort(i) : i
            },
            filter: function (t) {
                return this.pushStack(I(this, t || [], !1))
            },
            not: function (t) {
                return this.pushStack(I(this, t || [], !0))
            },
            is: function (t) {
                return !!I(this, "string" == typeof t && T.test(t) ? D(t) : t || [], !1).length
            }
        });
        var A, P = /^(?:\s*(<[\w\W]+>)[^>]*|#([\w-]+))$/;
        (D.fn.init = function (t, e, i) {
            var n, s;
            if (!t) return this;
            if (i = i || A, "string" != typeof t) return t.nodeType ? (this[0] = t, this.length = 1, this) : b(t) ? void 0 !== i.ready ? i.ready(t) : t(D) : D.makeArray(t, this);
            if (!(n = "<" === t[0] && ">" === t[t.length - 1] && 3 <= t.length ? [null, t, null] : P.exec(t)) || !n[1] && e) return !e || e.jquery ? (e || i).find(t) : this.constructor(e).find(t);
            if (n[1]) {
                if (e = e instanceof D ? e[0] : e, D.merge(this, D.parseHTML(n[1], e && e.nodeType ? e.ownerDocument || e : k, !0)), E.test(n[1]) && D.isPlainObject(e))
                    for (n in e) b(this[n]) ? this[n](e[n]) : this.attr(n, e[n]);
                return this
            }
            return (s = k.getElementById(n[2])) && (this[0] = s, this.length = 1), this
        }).prototype = D.fn, A = D(k);
        var N = /^(?:parents|prev(?:Until|All))/,
            O = {
                children: !0,
                contents: !0,
                next: !0,
                prev: !0
            };

        function M(t, e) {
            for (;
                (t = t[e]) && 1 !== t.nodeType;);
            return t
        }
        D.fn.extend({
            has: function (t) {
                var e = D(t, this),
                    i = e.length;
                return this.filter(function () {
                    for (var t = 0; t < i; t++)
                        if (D.contains(this, e[t])) return !0
                })
            },
            closest: function (t, e) {
                var i, n = 0,
                    s = this.length,
                    o = [],
                    r = "string" != typeof t && D(t);
                if (!T.test(t))
                    for (; n < s; n++)
                        for (i = this[n]; i && i !== e; i = i.parentNode)
                            if (i.nodeType < 11 && (r ? -1 < r.index(i) : 1 === i.nodeType && D.find.matchesSelector(i, t))) {
                                o.push(i);
                                break
                            }
                return this.pushStack(1 < o.length ? D.uniqueSort(o) : o)
            },
            index: function (t) {
                return t ? "string" == typeof t ? s.call(D(t), this[0]) : s.call(this, t.jquery ? t[0] : t) : this[0] && this[0].parentNode ? this.first().prevAll().length : -1
            },
            add: function (t, e) {
                return this.pushStack(D.uniqueSort(D.merge(this.get(), D(t, e))))
            },
            addBack: function (t) {
                return this.add(null == t ? this.prevObject : this.prevObject.filter(t))
            }
        }), D.each({
            parent: function (t) {
                var e = t.parentNode;
                return e && 11 !== e.nodeType ? e : null
            },
            parents: function (t) {
                return f(t, "parentNode")
            },
            parentsUntil: function (t, e, i) {
                return f(t, "parentNode", i)
            },
            next: function (t) {
                return M(t, "nextSibling")
            },
            prev: function (t) {
                return M(t, "previousSibling")
            },
            nextAll: function (t) {
                return f(t, "nextSibling")
            },
            prevAll: function (t) {
                return f(t, "previousSibling")
            },
            nextUntil: function (t, e, i) {
                return f(t, "nextSibling", i)
            },
            prevUntil: function (t, e, i) {
                return f(t, "previousSibling", i)
            },
            siblings: function (t) {
                return C((t.parentNode || {}).firstChild, t)
            },
            children: function (t) {
                return C(t.firstChild)
            },
            contents: function (t) {
                return void 0 !== t.contentDocument ? t.contentDocument : (S(t, "template") && (t = t.content || t), D.merge([], t.childNodes))
            }
        }, function (n, s) {
            D.fn[n] = function (t, e) {
                var i = D.map(this, s, t);
                return "Until" !== n.slice(-5) && (e = t), e && "string" == typeof e && (i = D.filter(e, i)), 1 < this.length && (O[n] || D.uniqueSort(i), N.test(n) && i.reverse()), this.pushStack(i)
            }
        });
        var $ = /[^\x20\t\r\n\f]+/g;

        function H(t) {
            return t
        }

        function L(t) {
            throw t
        }

        function R(t, e, i, n) {
            var s;
            try {
                t && b(s = t.promise) ? s.call(t).done(e).fail(i) : t && b(s = t.then) ? s.call(t, e, i) : e.apply(void 0, [t].slice(n))
            } catch (t) {
                i.apply(void 0, [t])
            }
        }
        D.Callbacks = function (n) {
            var i;
            n = "string" == typeof n ? (i = {}, D.each(n.match($) || [], function (t, e) {
                i[e] = !0
            }), i) : D.extend({}, n);

            function s() {
                for (r = r || n.once, e = o = !0; l.length; h = -1)
                    for (t = l.shift(); ++h < a.length;) !1 === a[h].apply(t[0], t[1]) && n.stopOnFalse && (h = a.length, t = !1);
                n.memory || (t = !1), o = !1, r && (a = t ? [] : "")
            }
            var o, t, e, r, a = [],
                l = [],
                h = -1,
                c = {
                    add: function () {
                        return a && (t && !o && (h = a.length - 1, l.push(t)), function i(t) {
                            D.each(t, function (t, e) {
                                b(e) ? n.unique && c.has(e) || a.push(e) : e && e.length && "string" !== w(e) && i(e)
                            })
                        }(arguments), t && !o && s()), this
                    },
                    remove: function () {
                        return D.each(arguments, function (t, e) {
                            for (var i; - 1 < (i = D.inArray(e, a, i));) a.splice(i, 1), i <= h && h--
                        }), this
                    },
                    has: function (t) {
                        return t ? -1 < D.inArray(t, a) : 0 < a.length
                    },
                    empty: function () {
                        return a = a && [], this
                    },
                    disable: function () {
                        return r = l = [], a = t = "", this
                    },
                    disabled: function () {
                        return !a
                    },
                    lock: function () {
                        return r = l = [], t || o || (a = t = ""), this
                    },
                    locked: function () {
                        return !!r
                    },
                    fireWith: function (t, e) {
                        return r || (e = [t, (e = e || []).slice ? e.slice() : e], l.push(e), o || s()), this
                    },
                    fire: function () {
                        return c.fireWith(this, arguments), this
                    },
                    fired: function () {
                        return !!e
                    }
                };
            return c
        }, D.extend({
            Deferred: function (t) {
                var o = [
                    ["notify", "progress", D.Callbacks("memory"), D.Callbacks("memory"), 2],
                    ["resolve", "done", D.Callbacks("once memory"), D.Callbacks("once memory"), 0, "resolved"],
                    ["reject", "fail", D.Callbacks("once memory"), D.Callbacks("once memory"), 1, "rejected"]
                ],
                    s = "pending",
                    r = {
                        state: function () {
                            return s
                        },
                        always: function () {
                            return a.done(arguments).fail(arguments), this
                        },
                        catch: function (t) {
                            return r.then(null, t)
                        },
                        pipe: function () {
                            var s = arguments;
                            return D.Deferred(function (n) {
                                D.each(o, function (t, e) {
                                    var i = b(s[e[4]]) && s[e[4]];
                                    a[e[1]](function () {
                                        var t = i && i.apply(this, arguments);
                                        t && b(t.promise) ? t.promise().progress(n.notify).done(n.resolve).fail(n.reject) : n[e[0] + "With"](this, i ? [t] : arguments)
                                    })
                                }), s = null
                            }).promise()
                        },
                        then: function (e, i, n) {
                            var l = 0;

                            function h(s, o, r, a) {
                                return function () {
                                    function t() {
                                        var t, e;
                                        if (!(s < l)) {
                                            if ((t = r.apply(i, n)) === o.promise()) throw new TypeError("Thenable self-resolution");
                                            e = t && ("object" == typeof t || "function" == typeof t) && t.then, b(e) ? a ? e.call(t, h(l, o, H, a), h(l, o, L, a)) : (l++ , e.call(t, h(l, o, H, a), h(l, o, L, a), h(l, o, H, o.notifyWith))) : (r !== H && (i = void 0, n = [t]), (a || o.resolveWith)(i, n))
                                        }
                                    }
                                    var i = this,
                                        n = arguments,
                                        e = a ? t : function () {
                                            try {
                                                t()
                                            } catch (t) {
                                                D.Deferred.exceptionHook && D.Deferred.exceptionHook(t, e.stackTrace), l <= s + 1 && (r !== L && (i = void 0, n = [t]), o.rejectWith(i, n))
                                            }
                                        };
                                    s ? e() : (D.Deferred.getStackHook && (e.stackTrace = D.Deferred.getStackHook()), x.setTimeout(e))
                                }
                            }
                            return D.Deferred(function (t) {
                                o[0][3].add(h(0, t, b(n) ? n : H, t.notifyWith)), o[1][3].add(h(0, t, b(e) ? e : H)), o[2][3].add(h(0, t, b(i) ? i : L))
                            }).promise()
                        },
                        promise: function (t) {
                            return null != t ? D.extend(t, r) : r
                        }
                    },
                    a = {};
                return D.each(o, function (t, e) {
                    var i = e[2],
                        n = e[5];
                    r[e[1]] = i.add, n && i.add(function () {
                        s = n
                    }, o[3 - t][2].disable, o[3 - t][3].disable, o[0][2].lock, o[0][3].lock), i.add(e[3].fire), a[e[0]] = function () {
                        return a[e[0] + "With"](this === a ? void 0 : this, arguments), this
                    }, a[e[0] + "With"] = i.fireWith
                }), r.promise(a), t && t.call(a, a), a
            },
            when: function (t) {
                function e(e) {
                    return function (t) {
                        s[e] = this, o[e] = 1 < arguments.length ? a.call(arguments) : t, --i || r.resolveWith(s, o)
                    }
                }
                var i = arguments.length,
                    n = i,
                    s = Array(n),
                    o = a.call(arguments),
                    r = D.Deferred();
                if (i <= 1 && (R(t, r.done(e(n)).resolve, r.reject, !i), "pending" === r.state() || b(o[n] && o[n].then))) return r.then();
                for (; n--;) R(o[n], e(n), r.reject);
                return r.promise()
            }
        });
        var W = /^(Eval|Internal|Range|Reference|Syntax|Type|URI)Error$/;
        D.Deferred.exceptionHook = function (t, e) {
            x.console && x.console.warn && t && W.test(t.name) && x.console.warn("jQuery.Deferred exception: " + t.message, t.stack, e)
        }, D.readyException = function (t) {
            x.setTimeout(function () {
                throw t
            })
        };
        var F = D.Deferred();

        function j() {
            k.removeEventListener("DOMContentLoaded", j), x.removeEventListener("load", j), D.ready()
        }
        D.fn.ready = function (t) {
            return F.then(t).catch(function (t) {
                D.readyException(t)
            }), this
        }, D.extend({
            isReady: !1,
            readyWait: 1,
            ready: function (t) {
                (!0 === t ? --D.readyWait : D.isReady) || (D.isReady = !0) !== t && 0 < --D.readyWait || F.resolveWith(k, [D])
            }
        }), D.ready.then = F.then, "complete" === k.readyState || "loading" !== k.readyState && !k.documentElement.doScroll ? x.setTimeout(D.ready) : (k.addEventListener("DOMContentLoaded", j), x.addEventListener("load", j));
        var z = function (t, e, i, n, s, o, r) {
            var a = 0,
                l = t.length,
                h = null == i;
            if ("object" === w(i))
                for (a in s = !0, i) z(t, e, a, i[a], !0, o, r);
            else if (void 0 !== n && (s = !0, b(n) || (r = !0), h && (e = r ? (e.call(t, n), null) : (h = e, function (t, e, i) {
                return h.call(D(t), i)
            })), e))
                for (; a < l; a++) e(t[a], i, r ? n : n.call(t[a], a, e(t[a], i)));
            return s ? t : h ? e.call(t) : l ? e(t[0], i) : o
        },
            q = /^-ms-/,
            B = /-([a-z])/g;

        function U(t, e) {
            return e.toUpperCase()
        }

        function Y(t) {
            return t.replace(q, "ms-").replace(B, U)
        }

        function K(t) {
            return 1 === t.nodeType || 9 === t.nodeType || !+t.nodeType
        }

        function V() {
            this.expando = D.expando + V.uid++
        }
        V.uid = 1, V.prototype = {
            cache: function (t) {
                var e = t[this.expando];
                return e || (e = {}, K(t) && (t.nodeType ? t[this.expando] = e : Object.defineProperty(t, this.expando, {
                    value: e,
                    configurable: !0
                }))), e
            },
            set: function (t, e, i) {
                var n, s = this.cache(t);
                if ("string" == typeof e) s[Y(e)] = i;
                else
                    for (n in e) s[Y(n)] = e[n];
                return s
            },
            get: function (t, e) {
                return void 0 === e ? this.cache(t) : t[this.expando] && t[this.expando][Y(e)]
            },
            access: function (t, e, i) {
                return void 0 === e || e && "string" == typeof e && void 0 === i ? this.get(t, e) : (this.set(t, e, i), void 0 !== i ? i : e)
            },
            remove: function (t, e) {
                var i, n = t[this.expando];
                if (void 0 !== n) {
                    if (void 0 !== e) {
                        i = (e = Array.isArray(e) ? e.map(Y) : (e = Y(e)) in n ? [e] : e.match($) || []).length;
                        for (; i--;) delete n[e[i]]
                    }
                    void 0 !== e && !D.isEmptyObject(n) || (t.nodeType ? t[this.expando] = void 0 : delete t[this.expando])
                }
            },
            hasData: function (t) {
                var e = t[this.expando];
                return void 0 !== e && !D.isEmptyObject(e)
            }
        };
        var X = new V,
            Q = new V,
            G = /^(?:\{[\w\W]*\}|\[[\w\W]*\])$/,
            J = /[A-Z]/g;

        function Z(t, e, i) {
            var n, s;
            if (void 0 === i && 1 === t.nodeType)
                if (n = "data-" + e.replace(J, "-$&").toLowerCase(), "string" == typeof (i = t.getAttribute(n))) {
                    try {
                        i = "true" === (s = i) || "false" !== s && ("null" === s ? null : s === +s + "" ? +s : G.test(s) ? JSON.parse(s) : s)
                    } catch (t) { }
                    Q.set(t, e, i)
                } else i = void 0;
            return i
        }
        D.extend({
            hasData: function (t) {
                return Q.hasData(t) || X.hasData(t)
            },
            data: function (t, e, i) {
                return Q.access(t, e, i)
            },
            removeData: function (t, e) {
                Q.remove(t, e)
            },
            _data: function (t, e, i) {
                return X.access(t, e, i)
            },
            _removeData: function (t, e) {
                X.remove(t, e)
            }
        }), D.fn.extend({
            data: function (i, t) {
                var e, n, s, o = this[0],
                    r = o && o.attributes;
                if (void 0 !== i) return "object" == typeof i ? this.each(function () {
                    Q.set(this, i)
                }) : z(this, function (t) {
                    var e;
                    if (o && void 0 === t) return void 0 !== (e = Q.get(o, i)) || void 0 !== (e = Z(o, i)) ? e : void 0;
                    this.each(function () {
                        Q.set(this, i, t)
                    })
                }, null, t, 1 < arguments.length, null, !0);
                if (this.length && (s = Q.get(o), 1 === o.nodeType && !X.get(o, "hasDataAttrs"))) {
                    for (e = r.length; e--;) r[e] && 0 === (n = r[e].name).indexOf("data-") && (n = Y(n.slice(5)), Z(o, n, s[n]));
                    X.set(o, "hasDataAttrs", !0)
                }
                return s
            },
            removeData: function (t) {
                return this.each(function () {
                    Q.remove(this, t)
                })
            }
        }), D.extend({
            queue: function (t, e, i) {
                var n;
                if (t) return e = (e || "fx") + "queue", n = X.get(t, e), i && (!n || Array.isArray(i) ? n = X.access(t, e, D.makeArray(i)) : n.push(i)), n || []
            },
            dequeue: function (t, e) {
                e = e || "fx";
                var i = D.queue(t, e),
                    n = i.length,
                    s = i.shift(),
                    o = D._queueHooks(t, e);
                "inprogress" === s && (s = i.shift(), n--), s && ("fx" === e && i.unshift("inprogress"), delete o.stop, s.call(t, function () {
                    D.dequeue(t, e)
                }, o)), !n && o && o.empty.fire()
            },
            _queueHooks: function (t, e) {
                var i = e + "queueHooks";
                return X.get(t, i) || X.access(t, i, {
                    empty: D.Callbacks("once memory").add(function () {
                        X.remove(t, [e + "queue", i])
                    })
                })
            }
        }), D.fn.extend({
            queue: function (e, i) {
                var t = 2;
                return "string" != typeof e && (i = e, e = "fx", t--), arguments.length < t ? D.queue(this[0], e) : void 0 === i ? this : this.each(function () {
                    var t = D.queue(this, e, i);
                    D._queueHooks(this, e), "fx" === e && "inprogress" !== t[0] && D.dequeue(this, e)
                })
            },
            dequeue: function (t) {
                return this.each(function () {
                    D.dequeue(this, t)
                })
            },
            clearQueue: function (t) {
                return this.queue(t || "fx", [])
            },
            promise: function (t, e) {
                function i() {
                    --s || o.resolveWith(r, [r])
                }
                var n, s = 1,
                    o = D.Deferred(),
                    r = this,
                    a = this.length;
                for ("string" != typeof t && (e = t, t = void 0), t = t || "fx"; a--;)(n = X.get(r[a], t + "queueHooks")) && n.empty && (s++ , n.empty.add(i));
                return i(), o.promise(e)
            }
        });
        var tt = /[+-]?(?:\d*\.|)\d+(?:[eE][+-]?\d+|)/.source,
            et = new RegExp("^(?:([+-])=|)(" + tt + ")([a-z%]*)$", "i"),
            it = ["Top", "Right", "Bottom", "Left"],
            nt = k.documentElement,
            st = function (t) {
                return D.contains(t.ownerDocument, t)
            },
            ot = {
                composed: !0
            };
        nt.getRootNode && (st = function (t) {
            return D.contains(t.ownerDocument, t) || t.getRootNode(ot) === t.ownerDocument
        });

        function rt(t, e) {
            return "none" === (t = e || t).style.display || "" === t.style.display && st(t) && "none" === D.css(t, "display")
        }

        function at(t, e, i, n) {
            var s, o, r = {};
            for (o in e) r[o] = t.style[o], t.style[o] = e[o];
            for (o in s = i.apply(t, n || []), e) t.style[o] = r[o];
            return s
        }

        function lt(t, e, i, n) {
            var s, o, r = 20,
                a = n ? function () {
                    return n.cur()
                } : function () {
                    return D.css(t, e, "")
                },
                l = a(),
                h = i && i[3] || (D.cssNumber[e] ? "" : "px"),
                c = t.nodeType && (D.cssNumber[e] || "px" !== h && +l) && et.exec(D.css(t, e));
            if (c && c[3] !== h) {
                for (l /= 2, h = h || c[3], c = +l || 1; r--;) D.style(t, e, c + h), (1 - o) * (1 - (o = a() / l || .5)) <= 0 && (r = 0), c /= o;
                c *= 2, D.style(t, e, c + h), i = i || []
            }
            return i && (c = +c || +l || 0, s = i[1] ? c + (i[1] + 1) * i[2] : +i[2], n && (n.unit = h, n.start = c, n.end = s)), s
        }
        var ht = {};

        function ct(t, e) {
            for (var i, n, s, o, r, a, l = [], h = 0, c = t.length; h < c; h++)(n = t[h]).style && (i = n.style.display, e ? ("none" === i && (l[h] = X.get(n, "display") || null, l[h] || (n.style.display = "")), "" === n.style.display && rt(n) && (l[h] = (a = o = s = void 0, o = n.ownerDocument, r = n.nodeName, (a = ht[r]) || (s = o.body.appendChild(o.createElement(r)), a = D.css(s, "display"), s.parentNode.removeChild(s), "none" === a && (a = "block"), ht[r] = a)))) : "none" !== i && (l[h] = "none", X.set(n, "display", i)));
            for (h = 0; h < c; h++) null != l[h] && (t[h].style.display = l[h]);
            return t
        }
        D.fn.extend({
            show: function () {
                return ct(this, !0)
            },
            hide: function () {
                return ct(this)
            },
            toggle: function (t) {
                return "boolean" == typeof t ? t ? this.show() : this.hide() : this.each(function () {
                    rt(this) ? D(this).show() : D(this).hide()
                })
            }
        });
        var ut = /^(?:checkbox|radio)$/i,
            dt = /<([a-z][^\/\0>\x20\t\r\n\f]*)/i,
            pt = /^$|^module$|\/(?:java|ecma)script/i,
            ft = {
                option: [1, "<select multiple='multiple'>", "</select>"],
                thead: [1, "<table>", "</table>"],
                col: [2, "<table><colgroup>", "</colgroup></table>"],
                tr: [2, "<table><tbody>", "</tbody></table>"],
                td: [3, "<table><tbody><tr>", "</tr></tbody></table>"],
                _default: [0, "", ""]
            };

        function gt(t, e) {
            var i;
            return i = void 0 !== t.getElementsByTagName ? t.getElementsByTagName(e || "*") : void 0 !== t.querySelectorAll ? t.querySelectorAll(e || "*") : [], void 0 === e || e && S(t, e) ? D.merge([t], i) : i
        }

        function mt(t, e) {
            for (var i = 0, n = t.length; i < n; i++) X.set(t[i], "globalEval", !e || X.get(e[i], "globalEval"))
        }
        ft.optgroup = ft.option, ft.tbody = ft.tfoot = ft.colgroup = ft.caption = ft.thead, ft.th = ft.td;
        var vt, _t, bt = /<|&#?\w+;/;

        function yt(t, e, i, n, s) {
            for (var o, r, a, l, h, c, u = e.createDocumentFragment(), d = [], p = 0, f = t.length; p < f; p++)
                if ((o = t[p]) || 0 === o)
                    if ("object" === w(o)) D.merge(d, o.nodeType ? [o] : o);
                    else if (bt.test(o)) {
                        for (r = r || u.appendChild(e.createElement("div")), a = (dt.exec(o) || ["", ""])[1].toLowerCase(), l = ft[a] || ft._default, r.innerHTML = l[1] + D.htmlPrefilter(o) + l[2], c = l[0]; c--;) r = r.lastChild;
                        D.merge(d, r.childNodes), (r = u.firstChild).textContent = ""
                    } else d.push(e.createTextNode(o));
            for (u.textContent = "", p = 0; o = d[p++];)
                if (n && -1 < D.inArray(o, n)) s && s.push(o);
                else if (h = st(o), r = gt(u.appendChild(o), "script"), h && mt(r), i)
                    for (c = 0; o = r[c++];) pt.test(o.type || "") && i.push(o);
            return u
        }
        vt = k.createDocumentFragment().appendChild(k.createElement("div")), (_t = k.createElement("input")).setAttribute("type", "radio"), _t.setAttribute("checked", "checked"), _t.setAttribute("name", "t"), vt.appendChild(_t), _.checkClone = vt.cloneNode(!0).cloneNode(!0).lastChild.checked, vt.innerHTML = "<textarea>x</textarea>", _.noCloneChecked = !!vt.cloneNode(!0).lastChild.defaultValue;
        var wt = /^key/,
            Ct = /^(?:mouse|pointer|contextmenu|drag|drop)|click/,
            xt = /^([^.]*)(?:\.(.+)|)/;

        function kt() {
            return !0
        }

        function Dt() {
            return !1
        }

        function Tt(t, e) {
            return t === function () {
                try {
                    return k.activeElement
                } catch (t) { }
            }() == ("focus" === e)
        }

        function St(t, e, i, n, s, o) {
            var r, a;
            if ("object" == typeof e) {
                for (a in "string" != typeof i && (n = n || i, i = void 0), e) St(t, a, i, n, e[a], o);
                return t
            }
            if (null == n && null == s ? (s = i, n = i = void 0) : null == s && ("string" == typeof i ? (s = n, n = void 0) : (s = n, n = i, i = void 0)), !1 === s) s = Dt;
            else if (!s) return t;
            return 1 === o && (r = s, (s = function (t) {
                return D().off(t), r.apply(this, arguments)
            }).guid = r.guid || (r.guid = D.guid++)), t.each(function () {
                D.event.add(this, e, s, n, i)
            })
        }

        function Et(t, s, o) {
            o ? (X.set(t, s, !1), D.event.add(t, s, {
                namespace: !1,
                handler: function (t) {
                    var e, i, n = X.get(this, s);
                    if (1 & t.isTrigger && this[s]) {
                        if (n.length) (D.event.special[s] || {}).delegateType && t.stopPropagation();
                        else if (n = a.call(arguments), X.set(this, s, n), e = o(this, s), this[s](), n !== (i = X.get(this, s)) || e ? X.set(this, s, !1) : i = {}, n !== i) return t.stopImmediatePropagation(), t.preventDefault(), i.value
                    } else n.length && (X.set(this, s, {
                        value: D.event.trigger(D.extend(n[0], D.Event.prototype), n.slice(1), this)
                    }), t.stopImmediatePropagation())
                }
            })) : void 0 === X.get(t, s) && D.event.add(t, s, kt)
        }
        D.event = {
            global: {},
            add: function (e, t, i, n, s) {
                var o, r, a, l, h, c, u, d, p, f, g, m = X.get(e);
                if (m)
                    for (i.handler && (i = (o = i).handler, s = o.selector), s && D.find.matchesSelector(nt, s), i.guid || (i.guid = D.guid++), (l = m.events) || (l = m.events = {}), (r = m.handle) || (r = m.handle = function (t) {
                        return void 0 !== D && D.event.triggered !== t.type ? D.event.dispatch.apply(e, arguments) : void 0
                    }), h = (t = (t || "").match($) || [""]).length; h--;) p = g = (a = xt.exec(t[h]) || [])[1], f = (a[2] || "").split(".").sort(), p && (u = D.event.special[p] || {}, p = (s ? u.delegateType : u.bindType) || p, u = D.event.special[p] || {}, c = D.extend({
                        type: p,
                        origType: g,
                        data: n,
                        handler: i,
                        guid: i.guid,
                        selector: s,
                        needsContext: s && D.expr.match.needsContext.test(s),
                        namespace: f.join(".")
                    }, o), (d = l[p]) || ((d = l[p] = []).delegateCount = 0, u.setup && !1 !== u.setup.call(e, n, f, r) || e.addEventListener && e.addEventListener(p, r)), u.add && (u.add.call(e, c), c.handler.guid || (c.handler.guid = i.guid)), s ? d.splice(d.delegateCount++, 0, c) : d.push(c), D.event.global[p] = !0)
            },
            remove: function (t, e, i, n, s) {
                var o, r, a, l, h, c, u, d, p, f, g, m = X.hasData(t) && X.get(t);
                if (m && (l = m.events)) {
                    for (h = (e = (e || "").match($) || [""]).length; h--;)
                        if (p = g = (a = xt.exec(e[h]) || [])[1], f = (a[2] || "").split(".").sort(), p) {
                            for (u = D.event.special[p] || {}, d = l[p = (n ? u.delegateType : u.bindType) || p] || [], a = a[2] && new RegExp("(^|\\.)" + f.join("\\.(?:.*\\.|)") + "(\\.|$)"), r = o = d.length; o--;) c = d[o], !s && g !== c.origType || i && i.guid !== c.guid || a && !a.test(c.namespace) || n && n !== c.selector && ("**" !== n || !c.selector) || (d.splice(o, 1), c.selector && d.delegateCount-- , u.remove && u.remove.call(t, c));
                            r && !d.length && (u.teardown && !1 !== u.teardown.call(t, f, m.handle) || D.removeEvent(t, p, m.handle), delete l[p])
                        } else
                            for (p in l) D.event.remove(t, p + e[h], i, n, !0);
                    D.isEmptyObject(l) && X.remove(t, "handle events")
                }
            },
            dispatch: function (t) {
                var e, i, n, s, o, r, a = D.event.fix(t),
                    l = new Array(arguments.length),
                    h = (X.get(this, "events") || {})[a.type] || [],
                    c = D.event.special[a.type] || {};
                for (l[0] = a, e = 1; e < arguments.length; e++) l[e] = arguments[e];
                if (a.delegateTarget = this, !c.preDispatch || !1 !== c.preDispatch.call(this, a)) {
                    for (r = D.event.handlers.call(this, a, h), e = 0;
                        (s = r[e++]) && !a.isPropagationStopped();)
                        for (a.currentTarget = s.elem, i = 0;
                            (o = s.handlers[i++]) && !a.isImmediatePropagationStopped();) a.rnamespace && !1 !== o.namespace && !a.rnamespace.test(o.namespace) || (a.handleObj = o, a.data = o.data, void 0 !== (n = ((D.event.special[o.origType] || {}).handle || o.handler).apply(s.elem, l)) && !1 === (a.result = n) && (a.preventDefault(), a.stopPropagation()));
                    return c.postDispatch && c.postDispatch.call(this, a), a.result
                }
            },
            handlers: function (t, e) {
                var i, n, s, o, r, a = [],
                    l = e.delegateCount,
                    h = t.target;
                if (l && h.nodeType && !("click" === t.type && 1 <= t.button))
                    for (; h !== this; h = h.parentNode || this)
                        if (1 === h.nodeType && ("click" !== t.type || !0 !== h.disabled)) {
                            for (o = [], r = {}, i = 0; i < l; i++) void 0 === r[s = (n = e[i]).selector + " "] && (r[s] = n.needsContext ? -1 < D(s, this).index(h) : D.find(s, this, null, [h]).length), r[s] && o.push(n);
                            o.length && a.push({
                                elem: h,
                                handlers: o
                            })
                        }
                return h = this, l < e.length && a.push({
                    elem: h,
                    handlers: e.slice(l)
                }), a
            },
            addProp: function (e, t) {
                Object.defineProperty(D.Event.prototype, e, {
                    enumerable: !0,
                    configurable: !0,
                    get: b(t) ? function () {
                        if (this.originalEvent) return t(this.originalEvent)
                    } : function () {
                        if (this.originalEvent) return this.originalEvent[e]
                    },
                    set: function (t) {
                        Object.defineProperty(this, e, {
                            enumerable: !0,
                            configurable: !0,
                            writable: !0,
                            value: t
                        })
                    }
                })
            },
            fix: function (t) {
                return t[D.expando] ? t : new D.Event(t)
            },
            special: {
                load: {
                    noBubble: !0
                },
                click: {
                    setup: function (t) {
                        var e = this || t;
                        return ut.test(e.type) && e.click && S(e, "input") && Et(e, "click", kt), !1
                    },
                    trigger: function (t) {
                        var e = this || t;
                        return ut.test(e.type) && e.click && S(e, "input") && Et(e, "click"), !0
                    },
                    _default: function (t) {
                        var e = t.target;
                        return ut.test(e.type) && e.click && S(e, "input") && X.get(e, "click") || S(e, "a")
                    }
                },
                beforeunload: {
                    postDispatch: function (t) {
                        void 0 !== t.result && t.originalEvent && (t.originalEvent.returnValue = t.result)
                    }
                }
            }
        }, D.removeEvent = function (t, e, i) {
            t.removeEventListener && t.removeEventListener(e, i)
        }, D.Event = function (t, e) {
            if (!(this instanceof D.Event)) return new D.Event(t, e);
            t && t.type ? (this.originalEvent = t, this.type = t.type, this.isDefaultPrevented = t.defaultPrevented || void 0 === t.defaultPrevented && !1 === t.returnValue ? kt : Dt, this.target = t.target && 3 === t.target.nodeType ? t.target.parentNode : t.target, this.currentTarget = t.currentTarget, this.relatedTarget = t.relatedTarget) : this.type = t, e && D.extend(this, e), this.timeStamp = t && t.timeStamp || Date.now(), this[D.expando] = !0
        }, D.Event.prototype = {
            constructor: D.Event,
            isDefaultPrevented: Dt,
            isPropagationStopped: Dt,
            isImmediatePropagationStopped: Dt,
            isSimulated: !1,
            preventDefault: function () {
                var t = this.originalEvent;
                this.isDefaultPrevented = kt, t && !this.isSimulated && t.preventDefault()
            },
            stopPropagation: function () {
                var t = this.originalEvent;
                this.isPropagationStopped = kt, t && !this.isSimulated && t.stopPropagation()
            },
            stopImmediatePropagation: function () {
                var t = this.originalEvent;
                this.isImmediatePropagationStopped = kt, t && !this.isSimulated && t.stopImmediatePropagation(), this.stopPropagation()
            }
        }, D.each({
            altKey: !0,
            bubbles: !0,
            cancelable: !0,
            changedTouches: !0,
            ctrlKey: !0,
            detail: !0,
            eventPhase: !0,
            metaKey: !0,
            pageX: !0,
            pageY: !0,
            shiftKey: !0,
            view: !0,
            char: !0,
            code: !0,
            charCode: !0,
            key: !0,
            keyCode: !0,
            button: !0,
            buttons: !0,
            clientX: !0,
            clientY: !0,
            offsetX: !0,
            offsetY: !0,
            pointerId: !0,
            pointerType: !0,
            screenX: !0,
            screenY: !0,
            targetTouches: !0,
            toElement: !0,
            touches: !0,
            which: function (t) {
                var e = t.button;
                return null == t.which && wt.test(t.type) ? null != t.charCode ? t.charCode : t.keyCode : !t.which && void 0 !== e && Ct.test(t.type) ? 1 & e ? 1 : 2 & e ? 3 : 4 & e ? 2 : 0 : t.which
            }
        }, D.event.addProp), D.each({
            focus: "focusin",
            blur: "focusout"
        }, function (t, e) {
            D.event.special[t] = {
                setup: function () {
                    return Et(this, t, Tt), !1
                },
                trigger: function () {
                    return Et(this, t), !0
                },
                delegateType: e
            }
        }), D.each({
            mouseenter: "mouseover",
            mouseleave: "mouseout",
            pointerenter: "pointerover",
            pointerleave: "pointerout"
        }, function (t, s) {
            D.event.special[t] = {
                delegateType: s,
                bindType: s,
                handle: function (t) {
                    var e, i = t.relatedTarget,
                        n = t.handleObj;
                    return i && (i === this || D.contains(this, i)) || (t.type = n.origType, e = n.handler.apply(this, arguments), t.type = s), e
                }
            }
        }), D.fn.extend({
            on: function (t, e, i, n) {
                return St(this, t, e, i, n)
            },
            one: function (t, e, i, n) {
                return St(this, t, e, i, n, 1)
            },
            off: function (t, e, i) {
                var n, s;
                if (t && t.preventDefault && t.handleObj) return n = t.handleObj, D(t.delegateTarget).off(n.namespace ? n.origType + "." + n.namespace : n.origType, n.selector, n.handler), this;
                if ("object" != typeof t) return !1 !== e && "function" != typeof e || (i = e, e = void 0), !1 === i && (i = Dt), this.each(function () {
                    D.event.remove(this, t, i, e)
                });
                for (s in t) this.off(s, e, t[s]);
                return this
            }
        });
        var It = /<(?!area|br|col|embed|hr|img|input|link|meta|param)(([a-z][^\/\0>\x20\t\r\n\f]*)[^>]*)\/>/gi,
            At = /<script|<style|<link/i,
            Pt = /checked\s*(?:[^=]|=\s*.checked.)/i,
            Nt = /^\s*<!(?:\[CDATA\[|--)|(?:\]\]|--)>\s*$/g;

        function Ot(t, e) {
            return S(t, "table") && S(11 !== e.nodeType ? e : e.firstChild, "tr") && D(t).children("tbody")[0] || t
        }

        function Mt(t) {
            return t.type = (null !== t.getAttribute("type")) + "/" + t.type, t
        }

        function $t(t) {
            return "true/" === (t.type || "").slice(0, 5) ? t.type = t.type.slice(5) : t.removeAttribute("type"), t
        }

        function Ht(t, e) {
            var i, n, s, o, r, a, l, h;
            if (1 === e.nodeType) {
                if (X.hasData(t) && (o = X.access(t), r = X.set(e, o), h = o.events))
                    for (s in delete r.handle, r.events = {}, h)
                        for (i = 0, n = h[s].length; i < n; i++) D.event.add(e, s, h[s][i]);
                Q.hasData(t) && (a = Q.access(t), l = D.extend({}, a), Q.set(e, l))
            }
        }

        function Lt(i, n, s, o) {
            n = m.apply([], n);
            var t, e, r, a, l, h, c = 0,
                u = i.length,
                d = u - 1,
                p = n[0],
                f = b(p);
            if (f || 1 < u && "string" == typeof p && !_.checkClone && Pt.test(p)) return i.each(function (t) {
                var e = i.eq(t);
                f && (n[0] = p.call(this, t, e.html())), Lt(e, n, s, o)
            });
            if (u && (e = (t = yt(n, i[0].ownerDocument, !1, i, o)).firstChild, 1 === t.childNodes.length && (t = e), e || o)) {
                for (a = (r = D.map(gt(t, "script"), Mt)).length; c < u; c++) l = t, c !== d && (l = D.clone(l, !0, !0), a && D.merge(r, gt(l, "script"))), s.call(i[c], l, c);
                if (a)
                    for (h = r[r.length - 1].ownerDocument, D.map(r, $t), c = 0; c < a; c++) l = r[c], pt.test(l.type || "") && !X.access(l, "globalEval") && D.contains(h, l) && (l.src && "module" !== (l.type || "").toLowerCase() ? D._evalUrl && !l.noModule && D._evalUrl(l.src, {
                        nonce: l.nonce || l.getAttribute("nonce")
                    }) : y(l.textContent.replace(Nt, ""), l, h))
            }
            return i
        }

        function Rt(t, e, i) {
            for (var n, s = e ? D.filter(e, t) : t, o = 0; null != (n = s[o]); o++) i || 1 !== n.nodeType || D.cleanData(gt(n)), n.parentNode && (i && st(n) && mt(gt(n, "script")), n.parentNode.removeChild(n));
            return t
        }
        D.extend({
            htmlPrefilter: function (t) {
                return t.replace(It, "<$1></$2>")
            },
            clone: function (t, e, i) {
                var n, s, o, r, a, l, h, c = t.cloneNode(!0),
                    u = st(t);
                if (!(_.noCloneChecked || 1 !== t.nodeType && 11 !== t.nodeType || D.isXMLDoc(t)))
                    for (r = gt(c), n = 0, s = (o = gt(t)).length; n < s; n++) a = o[n], "input" === (h = (l = r[n]).nodeName.toLowerCase()) && ut.test(a.type) ? l.checked = a.checked : "input" !== h && "textarea" !== h || (l.defaultValue = a.defaultValue);
                if (e)
                    if (i)
                        for (o = o || gt(t), r = r || gt(c), n = 0, s = o.length; n < s; n++) Ht(o[n], r[n]);
                    else Ht(t, c);
                return 0 < (r = gt(c, "script")).length && mt(r, !u && gt(t, "script")), c
            },
            cleanData: function (t) {
                for (var e, i, n, s = D.event.special, o = 0; void 0 !== (i = t[o]); o++)
                    if (K(i)) {
                        if (e = i[X.expando]) {
                            if (e.events)
                                for (n in e.events) s[n] ? D.event.remove(i, n) : D.removeEvent(i, n, e.handle);
                            i[X.expando] = void 0
                        }
                        i[Q.expando] && (i[Q.expando] = void 0)
                    }
            }
        }), D.fn.extend({
            detach: function (t) {
                return Rt(this, t, !0)
            },
            remove: function (t) {
                return Rt(this, t)
            },
            text: function (t) {
                return z(this, function (t) {
                    return void 0 === t ? D.text(this) : this.empty().each(function () {
                        1 !== this.nodeType && 11 !== this.nodeType && 9 !== this.nodeType || (this.textContent = t)
                    })
                }, null, t, arguments.length)
            },
            append: function () {
                return Lt(this, arguments, function (t) {
                    1 !== this.nodeType && 11 !== this.nodeType && 9 !== this.nodeType || Ot(this, t).appendChild(t)
                })
            },
            prepend: function () {
                return Lt(this, arguments, function (t) {
                    if (1 === this.nodeType || 11 === this.nodeType || 9 === this.nodeType) {
                        var e = Ot(this, t);
                        e.insertBefore(t, e.firstChild)
                    }
                })
            },
            before: function () {
                return Lt(this, arguments, function (t) {
                    this.parentNode && this.parentNode.insertBefore(t, this)
                })
            },
            after: function () {
                return Lt(this, arguments, function (t) {
                    this.parentNode && this.parentNode.insertBefore(t, this.nextSibling)
                })
            },
            empty: function () {
                for (var t, e = 0; null != (t = this[e]); e++) 1 === t.nodeType && (D.cleanData(gt(t, !1)), t.textContent = "");
                return this
            },
            clone: function (t, e) {
                return t = null != t && t, e = null == e ? t : e, this.map(function () {
                    return D.clone(this, t, e)
                })
            },
            html: function (t) {
                return z(this, function (t) {
                    var e = this[0] || {},
                        i = 0,
                        n = this.length;
                    if (void 0 === t && 1 === e.nodeType) return e.innerHTML;
                    if ("string" == typeof t && !At.test(t) && !ft[(dt.exec(t) || ["", ""])[1].toLowerCase()]) {
                        t = D.htmlPrefilter(t);
                        try {
                            for (; i < n; i++) 1 === (e = this[i] || {}).nodeType && (D.cleanData(gt(e, !1)), e.innerHTML = t);
                            e = 0
                        } catch (t) { }
                    }
                    e && this.empty().append(t)
                }, null, t, arguments.length)
            },
            replaceWith: function () {
                var i = [];
                return Lt(this, arguments, function (t) {
                    var e = this.parentNode;
                    D.inArray(this, i) < 0 && (D.cleanData(gt(this)), e && e.replaceChild(t, this))
                }, i)
            }
        }), D.each({
            appendTo: "append",
            prependTo: "prepend",
            insertBefore: "before",
            insertAfter: "after",
            replaceAll: "replaceWith"
        }, function (t, r) {
            D.fn[t] = function (t) {
                for (var e, i = [], n = D(t), s = n.length - 1, o = 0; o <= s; o++) e = o === s ? this : this.clone(!0), D(n[o])[r](e), l.apply(i, e.get());
                return this.pushStack(i)
            }
        });
        var Wt, Ft, jt, zt, qt, Bt, Ut, Yt = new RegExp("^(" + tt + ")(?!px)[a-z%]+$", "i"),
            Kt = function (t) {
                var e = t.ownerDocument.defaultView;
                return e && e.opener || (e = x), e.getComputedStyle(t)
            },
            Vt = new RegExp(it.join("|"), "i");

        function Xt(t, e, i) {
            var n, s, o, r, a = t.style;
            return (i = i || Kt(t)) && ("" !== (r = i.getPropertyValue(e) || i[e]) || st(t) || (r = D.style(t, e)), !_.pixelBoxStyles() && Yt.test(r) && Vt.test(e) && (n = a.width, s = a.minWidth, o = a.maxWidth, a.minWidth = a.maxWidth = a.width = r, r = i.width, a.width = n, a.minWidth = s, a.maxWidth = o)), void 0 !== r ? r + "" : r
        }

        function Qt(t, e) {
            return {
                get: function () {
                    if (!t()) return (this.get = e).apply(this, arguments);
                    delete this.get
                }
            }
        }

        function Gt() {
            if (Ut) {
                Bt.style.cssText = "position:absolute;left:-11111px;width:60px;margin-top:1px;padding:0;border:0", Ut.style.cssText = "position:relative;display:block;box-sizing:border-box;overflow:scroll;margin:auto;border:1px;padding:1px;width:60%;top:1%", nt.appendChild(Bt).appendChild(Ut);
                var t = x.getComputedStyle(Ut);
                Wt = "1%" !== t.top, qt = 12 === Jt(t.marginLeft), Ut.style.right = "60%", zt = 36 === Jt(t.right), Ft = 36 === Jt(t.width), Ut.style.position = "absolute", jt = 12 === Jt(Ut.offsetWidth / 3), nt.removeChild(Bt), Ut = null
            }
        }

        function Jt(t) {
            return Math.round(parseFloat(t))
        }
        Bt = k.createElement("div"), (Ut = k.createElement("div")).style && (Ut.style.backgroundClip = "content-box", Ut.cloneNode(!0).style.backgroundClip = "", _.clearCloneStyle = "content-box" === Ut.style.backgroundClip, D.extend(_, {
            boxSizingReliable: function () {
                return Gt(), Ft
            },
            pixelBoxStyles: function () {
                return Gt(), zt
            },
            pixelPosition: function () {
                return Gt(), Wt
            },
            reliableMarginLeft: function () {
                return Gt(), qt
            },
            scrollboxSize: function () {
                return Gt(), jt
            }
        }));
        var Zt = ["Webkit", "Moz", "ms"],
            te = k.createElement("div").style,
            ee = {};

        function ie(t) {
            return D.cssProps[t] || ee[t] || (t in te ? t : ee[t] = function (t) {
                for (var e = t[0].toUpperCase() + t.slice(1), i = Zt.length; i--;)
                    if ((t = Zt[i] + e) in te) return t
            }(t) || t)
        }
        var ne = /^(none|table(?!-c[ea]).+)/,
            se = /^--/,
            oe = {
                position: "absolute",
                visibility: "hidden",
                display: "block"
            },
            re = {
                letterSpacing: "0",
                fontWeight: "400"
            };

        function ae(t, e, i) {
            var n = et.exec(e);
            return n ? Math.max(0, n[2] - (i || 0)) + (n[3] || "px") : e
        }

        function le(t, e, i, n, s, o) {
            var r = "width" === e ? 1 : 0,
                a = 0,
                l = 0;
            if (i === (n ? "border" : "content")) return 0;
            for (; r < 4; r += 2) "margin" === i && (l += D.css(t, i + it[r], !0, s)), n ? ("content" === i && (l -= D.css(t, "padding" + it[r], !0, s)), "margin" !== i && (l -= D.css(t, "border" + it[r] + "Width", !0, s))) : (l += D.css(t, "padding" + it[r], !0, s), "padding" !== i ? l += D.css(t, "border" + it[r] + "Width", !0, s) : a += D.css(t, "border" + it[r] + "Width", !0, s));
            return !n && 0 <= o && (l += Math.max(0, Math.ceil(t["offset" + e[0].toUpperCase() + e.slice(1)] - o - l - a - .5)) || 0), l
        }

        function he(t, e, i) {
            var n = Kt(t),
                s = (!_.boxSizingReliable() || i) && "border-box" === D.css(t, "boxSizing", !1, n),
                o = s,
                r = Xt(t, e, n),
                a = "offset" + e[0].toUpperCase() + e.slice(1);
            if (Yt.test(r)) {
                if (!i) return r;
                r = "auto"
            }
            return (!_.boxSizingReliable() && s || "auto" === r || !parseFloat(r) && "inline" === D.css(t, "display", !1, n)) && t.getClientRects().length && (s = "border-box" === D.css(t, "boxSizing", !1, n), (o = a in t) && (r = t[a])), (r = parseFloat(r) || 0) + le(t, e, i || (s ? "border" : "content"), o, n, r) + "px"
        }

        function ce(t, e, i, n, s) {
            return new ce.prototype.init(t, e, i, n, s)
        }
        D.extend({
            cssHooks: {
                opacity: {
                    get: function (t, e) {
                        if (e) {
                            var i = Xt(t, "opacity");
                            return "" === i ? "1" : i
                        }
                    }
                }
            },
            cssNumber: {
                animationIterationCount: !0,
                columnCount: !0,
                fillOpacity: !0,
                flexGrow: !0,
                flexShrink: !0,
                fontWeight: !0,
                gridArea: !0,
                gridColumn: !0,
                gridColumnEnd: !0,
                gridColumnStart: !0,
                gridRow: !0,
                gridRowEnd: !0,
                gridRowStart: !0,
                lineHeight: !0,
                opacity: !0,
                order: !0,
                orphans: !0,
                widows: !0,
                zIndex: !0,
                zoom: !0
            },
            cssProps: {},
            style: function (t, e, i, n) {
                if (t && 3 !== t.nodeType && 8 !== t.nodeType && t.style) {
                    var s, o, r, a = Y(e),
                        l = se.test(e),
                        h = t.style;
                    if (l || (e = ie(a)), r = D.cssHooks[e] || D.cssHooks[a], void 0 === i) return r && "get" in r && void 0 !== (s = r.get(t, !1, n)) ? s : h[e];
                    "string" == (o = typeof i) && (s = et.exec(i)) && s[1] && (i = lt(t, e, s), o = "number"), null != i && i == i && ("number" !== o || l || (i += s && s[3] || (D.cssNumber[a] ? "" : "px")), _.clearCloneStyle || "" !== i || 0 !== e.indexOf("background") || (h[e] = "inherit"), r && "set" in r && void 0 === (i = r.set(t, i, n)) || (l ? h.setProperty(e, i) : h[e] = i))
                }
            },
            css: function (t, e, i, n) {
                var s, o, r, a = Y(e);
                return se.test(e) || (e = ie(a)), (r = D.cssHooks[e] || D.cssHooks[a]) && "get" in r && (s = r.get(t, !0, i)), void 0 === s && (s = Xt(t, e, n)), "normal" === s && e in re && (s = re[e]), "" === i || i ? (o = parseFloat(s), !0 === i || isFinite(o) ? o || 0 : s) : s
            }
        }), D.each(["height", "width"], function (t, l) {
            D.cssHooks[l] = {
                get: function (t, e, i) {
                    if (e) return !ne.test(D.css(t, "display")) || t.getClientRects().length && t.getBoundingClientRect().width ? he(t, l, i) : at(t, oe, function () {
                        return he(t, l, i)
                    })
                },
                set: function (t, e, i) {
                    var n, s = Kt(t),
                        o = !_.scrollboxSize() && "absolute" === s.position,
                        r = (o || i) && "border-box" === D.css(t, "boxSizing", !1, s),
                        a = i ? le(t, l, i, r, s) : 0;
                    return r && o && (a -= Math.ceil(t["offset" + l[0].toUpperCase() + l.slice(1)] - parseFloat(s[l]) - le(t, l, "border", !1, s) - .5)), a && (n = et.exec(e)) && "px" !== (n[3] || "px") && (t.style[l] = e, e = D.css(t, l)), ae(0, e, a)
                }
            }
        }), D.cssHooks.marginLeft = Qt(_.reliableMarginLeft, function (t, e) {
            if (e) return (parseFloat(Xt(t, "marginLeft")) || t.getBoundingClientRect().left - at(t, {
                marginLeft: 0
            }, function () {
                return t.getBoundingClientRect().left
            })) + "px"
        }), D.each({
            margin: "",
            padding: "",
            border: "Width"
        }, function (s, o) {
            D.cssHooks[s + o] = {
                expand: function (t) {
                    for (var e = 0, i = {}, n = "string" == typeof t ? t.split(" ") : [t]; e < 4; e++) i[s + it[e] + o] = n[e] || n[e - 2] || n[0];
                    return i
                }
            }, "margin" !== s && (D.cssHooks[s + o].set = ae)
        }), D.fn.extend({
            css: function (t, e) {
                return z(this, function (t, e, i) {
                    var n, s, o = {},
                        r = 0;
                    if (Array.isArray(e)) {
                        for (n = Kt(t), s = e.length; r < s; r++) o[e[r]] = D.css(t, e[r], !1, n);
                        return o
                    }
                    return void 0 !== i ? D.style(t, e, i) : D.css(t, e)
                }, t, e, 1 < arguments.length)
            }
        }), ((D.Tween = ce).prototype = {
            constructor: ce,
            init: function (t, e, i, n, s, o) {
                this.elem = t, this.prop = i, this.easing = s || D.easing._default, this.options = e, this.start = this.now = this.cur(), this.end = n, this.unit = o || (D.cssNumber[i] ? "" : "px")
            },
            cur: function () {
                var t = ce.propHooks[this.prop];
                return t && t.get ? t.get(this) : ce.propHooks._default.get(this)
            },
            run: function (t) {
                var e, i = ce.propHooks[this.prop];
                return this.options.duration ? this.pos = e = D.easing[this.easing](t, this.options.duration * t, 0, 1, this.options.duration) : this.pos = e = t, this.now = (this.end - this.start) * e + this.start, this.options.step && this.options.step.call(this.elem, this.now, this), i && i.set ? i.set(this) : ce.propHooks._default.set(this), this
            }
        }).init.prototype = ce.prototype, (ce.propHooks = {
            _default: {
                get: function (t) {
                    var e;
                    return 1 !== t.elem.nodeType || null != t.elem[t.prop] && null == t.elem.style[t.prop] ? t.elem[t.prop] : (e = D.css(t.elem, t.prop, "")) && "auto" !== e ? e : 0
                },
                set: function (t) {
                    D.fx.step[t.prop] ? D.fx.step[t.prop](t) : 1 !== t.elem.nodeType || !D.cssHooks[t.prop] && null == t.elem.style[ie(t.prop)] ? t.elem[t.prop] = t.now : D.style(t.elem, t.prop, t.now + t.unit)
                }
            }
        }).scrollTop = ce.propHooks.scrollLeft = {
            set: function (t) {
                t.elem.nodeType && t.elem.parentNode && (t.elem[t.prop] = t.now)
            }
        }, D.easing = {
            linear: function (t) {
                return t
            },
            swing: function (t) {
                return .5 - Math.cos(t * Math.PI) / 2
            },
            _default: "swing"
        }, D.fx = ce.prototype.init, D.fx.step = {};
        var ue, de, pe, fe, ge = /^(?:toggle|show|hide)$/,
            me = /queueHooks$/;

        function ve() {
            de && (!1 === k.hidden && x.requestAnimationFrame ? x.requestAnimationFrame(ve) : x.setTimeout(ve, D.fx.interval), D.fx.tick())
        }

        function _e() {
            return x.setTimeout(function () {
                ue = void 0
            }), ue = Date.now()
        }

        function be(t, e) {
            var i, n = 0,
                s = {
                    height: t
                };
            for (e = e ? 1 : 0; n < 4; n += 2 - e) s["margin" + (i = it[n])] = s["padding" + i] = t;
            return e && (s.opacity = s.width = t), s
        }

        function ye(t, e, i) {
            for (var n, s = (we.tweeners[e] || []).concat(we.tweeners["*"]), o = 0, r = s.length; o < r; o++)
                if (n = s[o].call(i, e, t)) return n
        }

        function we(o, t, e) {
            var i, r, n = 0,
                s = we.prefilters.length,
                a = D.Deferred().always(function () {
                    delete l.elem
                }),
                l = function () {
                    if (r) return !1;
                    for (var t = ue || _e(), e = Math.max(0, h.startTime + h.duration - t), i = 1 - (e / h.duration || 0), n = 0, s = h.tweens.length; n < s; n++) h.tweens[n].run(i);
                    return a.notifyWith(o, [h, i, e]), i < 1 && s ? e : (s || a.notifyWith(o, [h, 1, 0]), a.resolveWith(o, [h]), !1)
                },
                h = a.promise({
                    elem: o,
                    props: D.extend({}, t),
                    opts: D.extend(!0, {
                        specialEasing: {},
                        easing: D.easing._default
                    }, e),
                    originalProperties: t,
                    originalOptions: e,
                    startTime: ue || _e(),
                    duration: e.duration,
                    tweens: [],
                    createTween: function (t, e) {
                        var i = D.Tween(o, h.opts, t, e, h.opts.specialEasing[t] || h.opts.easing);
                        return h.tweens.push(i), i
                    },
                    stop: function (t) {
                        var e = 0,
                            i = t ? h.tweens.length : 0;
                        if (r) return this;
                        for (r = !0; e < i; e++) h.tweens[e].run(1);
                        return t ? (a.notifyWith(o, [h, 1, 0]), a.resolveWith(o, [h, t])) : a.rejectWith(o, [h, t]), this
                    }
                }),
                c = h.props;
            for (function (t, e) {
                var i, n, s, o, r;
                for (i in t)
                    if (s = e[n = Y(i)], o = t[i], Array.isArray(o) && (s = o[1], o = t[i] = o[0]), i !== n && (t[n] = o, delete t[i]), (r = D.cssHooks[n]) && "expand" in r)
                        for (i in o = r.expand(o), delete t[n], o) i in t || (t[i] = o[i], e[i] = s);
                    else e[n] = s
            }(c, h.opts.specialEasing); n < s; n++)
                if (i = we.prefilters[n].call(h, o, c, h.opts)) return b(i.stop) && (D._queueHooks(h.elem, h.opts.queue).stop = i.stop.bind(i)), i;
            return D.map(c, ye, h), b(h.opts.start) && h.opts.start.call(o, h), h.progress(h.opts.progress).done(h.opts.done, h.opts.complete).fail(h.opts.fail).always(h.opts.always), D.fx.timer(D.extend(l, {
                elem: o,
                anim: h,
                queue: h.opts.queue
            })), h
        }
        D.Animation = D.extend(we, {
            tweeners: {
                "*": [function (t, e) {
                    var i = this.createTween(t, e);
                    return lt(i.elem, t, et.exec(e), i), i
                }]
            },
            tweener: function (t, e) {
                for (var i, n = 0, s = (t = b(t) ? (e = t, ["*"]) : t.match($)).length; n < s; n++) i = t[n], we.tweeners[i] = we.tweeners[i] || [], we.tweeners[i].unshift(e)
            },
            prefilters: [function (t, e, i) {
                var n, s, o, r, a, l, h, c, u = "width" in e || "height" in e,
                    d = this,
                    p = {},
                    f = t.style,
                    g = t.nodeType && rt(t),
                    m = X.get(t, "fxshow");
                for (n in i.queue || (null == (r = D._queueHooks(t, "fx")).unqueued && (r.unqueued = 0, a = r.empty.fire, r.empty.fire = function () {
                    r.unqueued || a()
                }), r.unqueued++ , d.always(function () {
                    d.always(function () {
                        r.unqueued-- , D.queue(t, "fx").length || r.empty.fire()
                    })
                })), e)
                    if (s = e[n], ge.test(s)) {
                        if (delete e[n], o = o || "toggle" === s, s === (g ? "hide" : "show")) {
                            if ("show" !== s || !m || void 0 === m[n]) continue;
                            g = !0
                        }
                        p[n] = m && m[n] || D.style(t, n)
                    }
                if ((l = !D.isEmptyObject(e)) || !D.isEmptyObject(p))
                    for (n in u && 1 === t.nodeType && (i.overflow = [f.overflow, f.overflowX, f.overflowY], null == (h = m && m.display) && (h = X.get(t, "display")), "none" === (c = D.css(t, "display")) && (h ? c = h : (ct([t], !0), h = t.style.display || h, c = D.css(t, "display"), ct([t]))), ("inline" === c || "inline-block" === c && null != h) && "none" === D.css(t, "float") && (l || (d.done(function () {
                        f.display = h
                    }), null == h && (c = f.display, h = "none" === c ? "" : c)), f.display = "inline-block")), i.overflow && (f.overflow = "hidden", d.always(function () {
                        f.overflow = i.overflow[0], f.overflowX = i.overflow[1], f.overflowY = i.overflow[2]
                    })), l = !1, p) l || (m ? "hidden" in m && (g = m.hidden) : m = X.access(t, "fxshow", {
                        display: h
                    }), o && (m.hidden = !g), g && ct([t], !0), d.done(function () {
                        for (n in g || ct([t]), X.remove(t, "fxshow"), p) D.style(t, n, p[n])
                    })), l = ye(g ? m[n] : 0, n, d), n in m || (m[n] = l.start, g && (l.end = l.start, l.start = 0))
            }],
            prefilter: function (t, e) {
                e ? we.prefilters.unshift(t) : we.prefilters.push(t)
            }
        }), D.speed = function (t, e, i) {
            var n = t && "object" == typeof t ? D.extend({}, t) : {
                complete: i || !i && e || b(t) && t,
                duration: t,
                easing: i && e || e && !b(e) && e
            };
            return D.fx.off ? n.duration = 0 : "number" != typeof n.duration && (n.duration in D.fx.speeds ? n.duration = D.fx.speeds[n.duration] : n.duration = D.fx.speeds._default), null != n.queue && !0 !== n.queue || (n.queue = "fx"), n.old = n.complete, n.complete = function () {
                b(n.old) && n.old.call(this), n.queue && D.dequeue(this, n.queue)
            }, n
        }, D.fn.extend({
            fadeTo: function (t, e, i, n) {
                return this.filter(rt).css("opacity", 0).show().end().animate({
                    opacity: e
                }, t, i, n)
            },
            animate: function (e, t, i, n) {
                function s() {
                    var t = we(this, D.extend({}, e), r);
                    (o || X.get(this, "finish")) && t.stop(!0)
                }
                var o = D.isEmptyObject(e),
                    r = D.speed(t, i, n);
                return s.finish = s, o || !1 === r.queue ? this.each(s) : this.queue(r.queue, s)
            },
            stop: function (s, t, o) {
                function r(t) {
                    var e = t.stop;
                    delete t.stop, e(o)
                }
                return "string" != typeof s && (o = t, t = s, s = void 0), t && !1 !== s && this.queue(s || "fx", []), this.each(function () {
                    var t = !0,
                        e = null != s && s + "queueHooks",
                        i = D.timers,
                        n = X.get(this);
                    if (e) n[e] && n[e].stop && r(n[e]);
                    else
                        for (e in n) n[e] && n[e].stop && me.test(e) && r(n[e]);
                    for (e = i.length; e--;) i[e].elem !== this || null != s && i[e].queue !== s || (i[e].anim.stop(o), t = !1, i.splice(e, 1));
                    !t && o || D.dequeue(this, s)
                })
            },
            finish: function (r) {
                return !1 !== r && (r = r || "fx"), this.each(function () {
                    var t, e = X.get(this),
                        i = e[r + "queue"],
                        n = e[r + "queueHooks"],
                        s = D.timers,
                        o = i ? i.length : 0;
                    for (e.finish = !0, D.queue(this, r, []), n && n.stop && n.stop.call(this, !0), t = s.length; t--;) s[t].elem === this && s[t].queue === r && (s[t].anim.stop(!0), s.splice(t, 1));
                    for (t = 0; t < o; t++) i[t] && i[t].finish && i[t].finish.call(this);
                    delete e.finish
                })
            }
        }), D.each(["toggle", "show", "hide"], function (t, n) {
            var s = D.fn[n];
            D.fn[n] = function (t, e, i) {
                return null == t || "boolean" == typeof t ? s.apply(this, arguments) : this.animate(be(n, !0), t, e, i)
            }
        }), D.each({
            slideDown: be("show"),
            slideUp: be("hide"),
            slideToggle: be("toggle"),
            fadeIn: {
                opacity: "show"
            },
            fadeOut: {
                opacity: "hide"
            },
            fadeToggle: {
                opacity: "toggle"
            }
        }, function (t, n) {
            D.fn[t] = function (t, e, i) {
                return this.animate(n, t, e, i)
            }
        }), D.timers = [], D.fx.tick = function () {
            var t, e = 0,
                i = D.timers;
            for (ue = Date.now(); e < i.length; e++)(t = i[e])() || i[e] !== t || i.splice(e--, 1);
            i.length || D.fx.stop(), ue = void 0
        }, D.fx.timer = function (t) {
            D.timers.push(t), D.fx.start()
        }, D.fx.interval = 13, D.fx.start = function () {
            de || (de = !0, ve())
        }, D.fx.stop = function () {
            de = null
        }, D.fx.speeds = {
            slow: 600,
            fast: 200,
            _default: 400
        }, D.fn.delay = function (n, t) {
            return n = D.fx && D.fx.speeds[n] || n, t = t || "fx", this.queue(t, function (t, e) {
                var i = x.setTimeout(t, n);
                e.stop = function () {
                    x.clearTimeout(i)
                }
            })
        }, pe = k.createElement("input"), fe = k.createElement("select").appendChild(k.createElement("option")), pe.type = "checkbox", _.checkOn = "" !== pe.value, _.optSelected = fe.selected, (pe = k.createElement("input")).value = "t", pe.type = "radio", _.radioValue = "t" === pe.value;
        var Ce, xe = D.expr.attrHandle;
        D.fn.extend({
            attr: function (t, e) {
                return z(this, D.attr, t, e, 1 < arguments.length)
            },
            removeAttr: function (t) {
                return this.each(function () {
                    D.removeAttr(this, t)
                })
            }
        }), D.extend({
            attr: function (t, e, i) {
                var n, s, o = t.nodeType;
                if (3 !== o && 8 !== o && 2 !== o) return void 0 === t.getAttribute ? D.prop(t, e, i) : (1 === o && D.isXMLDoc(t) || (s = D.attrHooks[e.toLowerCase()] || (D.expr.match.bool.test(e) ? Ce : void 0)), void 0 !== i ? null === i ? void D.removeAttr(t, e) : s && "set" in s && void 0 !== (n = s.set(t, i, e)) ? n : (t.setAttribute(e, i + ""), i) : s && "get" in s && null !== (n = s.get(t, e)) ? n : null == (n = D.find.attr(t, e)) ? void 0 : n)
            },
            attrHooks: {
                type: {
                    set: function (t, e) {
                        if (!_.radioValue && "radio" === e && S(t, "input")) {
                            var i = t.value;
                            return t.setAttribute("type", e), i && (t.value = i), e
                        }
                    }
                }
            },
            removeAttr: function (t, e) {
                var i, n = 0,
                    s = e && e.match($);
                if (s && 1 === t.nodeType)
                    for (; i = s[n++];) t.removeAttribute(i)
            }
        }), Ce = {
            set: function (t, e, i) {
                return !1 === e ? D.removeAttr(t, i) : t.setAttribute(i, i), i
            }
        }, D.each(D.expr.match.bool.source.match(/\w+/g), function (t, e) {
            var r = xe[e] || D.find.attr;
            xe[e] = function (t, e, i) {
                var n, s, o = e.toLowerCase();
                return i || (s = xe[o], xe[o] = n, n = null != r(t, e, i) ? o : null, xe[o] = s), n
            }
        });
        var ke = /^(?:input|select|textarea|button)$/i,
            De = /^(?:a|area)$/i;

        function Te(t) {
            return (t.match($) || []).join(" ")
        }

        function Se(t) {
            return t.getAttribute && t.getAttribute("class") || ""
        }

        function Ee(t) {
            return Array.isArray(t) ? t : "string" == typeof t && t.match($) || []
        }
        D.fn.extend({
            prop: function (t, e) {
                return z(this, D.prop, t, e, 1 < arguments.length)
            },
            removeProp: function (t) {
                return this.each(function () {
                    delete this[D.propFix[t] || t]
                })
            }
        }), D.extend({
            prop: function (t, e, i) {
                var n, s, o = t.nodeType;
                if (3 !== o && 8 !== o && 2 !== o) return 1 === o && D.isXMLDoc(t) || (e = D.propFix[e] || e, s = D.propHooks[e]), void 0 !== i ? s && "set" in s && void 0 !== (n = s.set(t, i, e)) ? n : t[e] = i : s && "get" in s && null !== (n = s.get(t, e)) ? n : t[e]
            },
            propHooks: {
                tabIndex: {
                    get: function (t) {
                        var e = D.find.attr(t, "tabindex");
                        return e ? parseInt(e, 10) : ke.test(t.nodeName) || De.test(t.nodeName) && t.href ? 0 : -1
                    }
                }
            },
            propFix: {
                for: "htmlFor",
                class: "className"
            }
        }), _.optSelected || (D.propHooks.selected = {
            get: function (t) {
                var e = t.parentNode;
                return e && e.parentNode && e.parentNode.selectedIndex, null
            },
            set: function (t) {
                var e = t.parentNode;
                e && (e.selectedIndex, e.parentNode && e.parentNode.selectedIndex)
            }
        }), D.each(["tabIndex", "readOnly", "maxLength", "cellSpacing", "cellPadding", "rowSpan", "colSpan", "useMap", "frameBorder", "contentEditable"], function () {
            D.propFix[this.toLowerCase()] = this
        }), D.fn.extend({
            addClass: function (e) {
                var t, i, n, s, o, r, a, l = 0;
                if (b(e)) return this.each(function (t) {
                    D(this).addClass(e.call(this, t, Se(this)))
                });
                if ((t = Ee(e)).length)
                    for (; i = this[l++];)
                        if (s = Se(i), n = 1 === i.nodeType && " " + Te(s) + " ") {
                            for (r = 0; o = t[r++];) n.indexOf(" " + o + " ") < 0 && (n += o + " ");
                            s !== (a = Te(n)) && i.setAttribute("class", a)
                        }
                return this
            },
            removeClass: function (e) {
                var t, i, n, s, o, r, a, l = 0;
                if (b(e)) return this.each(function (t) {
                    D(this).removeClass(e.call(this, t, Se(this)))
                });
                if (!arguments.length) return this.attr("class", "");
                if ((t = Ee(e)).length)
                    for (; i = this[l++];)
                        if (s = Se(i), n = 1 === i.nodeType && " " + Te(s) + " ") {
                            for (r = 0; o = t[r++];)
                                for (; - 1 < n.indexOf(" " + o + " ");) n = n.replace(" " + o + " ", " ");
                            s !== (a = Te(n)) && i.setAttribute("class", a)
                        }
                return this
            },
            toggleClass: function (s, e) {
                var o = typeof s,
                    r = "string" == o || Array.isArray(s);
                return "boolean" == typeof e && r ? e ? this.addClass(s) : this.removeClass(s) : b(s) ? this.each(function (t) {
                    D(this).toggleClass(s.call(this, t, Se(this), e), e)
                }) : this.each(function () {
                    var t, e, i, n;
                    if (r)
                        for (e = 0, i = D(this), n = Ee(s); t = n[e++];) i.hasClass(t) ? i.removeClass(t) : i.addClass(t);
                    else void 0 !== s && "boolean" != o || ((t = Se(this)) && X.set(this, "__className__", t), this.setAttribute && this.setAttribute("class", t || !1 === s ? "" : X.get(this, "__className__") || ""))
                })
            },
            hasClass: function (t) {
                var e, i, n = 0;
                for (e = " " + t + " "; i = this[n++];)
                    if (1 === i.nodeType && -1 < (" " + Te(Se(i)) + " ").indexOf(e)) return !0;
                return !1
            }
        });
        var Ie = /\r/g;
        D.fn.extend({
            val: function (i) {
                var n, t, s, e = this[0];
                return arguments.length ? (s = b(i), this.each(function (t) {
                    var e;
                    1 === this.nodeType && (null == (e = s ? i.call(this, t, D(this).val()) : i) ? e = "" : "number" == typeof e ? e += "" : Array.isArray(e) && (e = D.map(e, function (t) {
                        return null == t ? "" : t + ""
                    })), (n = D.valHooks[this.type] || D.valHooks[this.nodeName.toLowerCase()]) && "set" in n && void 0 !== n.set(this, e, "value") || (this.value = e))
                })) : e ? (n = D.valHooks[e.type] || D.valHooks[e.nodeName.toLowerCase()]) && "get" in n && void 0 !== (t = n.get(e, "value")) ? t : "string" == typeof (t = e.value) ? t.replace(Ie, "") : null == t ? "" : t : void 0
            }
        }), D.extend({
            valHooks: {
                option: {
                    get: function (t) {
                        var e = D.find.attr(t, "value");
                        return null != e ? e : Te(D.text(t))
                    }
                },
                select: {
                    get: function (t) {
                        var e, i, n, s = t.options,
                            o = t.selectedIndex,
                            r = "select-one" === t.type,
                            a = r ? null : [],
                            l = r ? o + 1 : s.length;
                        for (n = o < 0 ? l : r ? o : 0; n < l; n++)
                            if (((i = s[n]).selected || n === o) && !i.disabled && (!i.parentNode.disabled || !S(i.parentNode, "optgroup"))) {
                                if (e = D(i).val(), r) return e;
                                a.push(e)
                            }
                        return a
                    },
                    set: function (t, e) {
                        for (var i, n, s = t.options, o = D.makeArray(e), r = s.length; r--;)((n = s[r]).selected = -1 < D.inArray(D.valHooks.option.get(n), o)) && (i = !0);
                        return i || (t.selectedIndex = -1), o
                    }
                }
            }
        }), D.each(["radio", "checkbox"], function () {
            D.valHooks[this] = {
                set: function (t, e) {
                    if (Array.isArray(e)) return t.checked = -1 < D.inArray(D(t).val(), e)
                }
            }, _.checkOn || (D.valHooks[this].get = function (t) {
                return null === t.getAttribute("value") ? "on" : t.value
            })
        }), _.focusin = "onfocusin" in x;

        function Ae(t) {
            t.stopPropagation()
        }
        var Pe = /^(?:focusinfocus|focusoutblur)$/;
        D.extend(D.event, {
            trigger: function (t, e, i, n) {
                var s, o, r, a, l, h, c, u, d = [i || k],
                    p = v.call(t, "type") ? t.type : t,
                    f = v.call(t, "namespace") ? t.namespace.split(".") : [];
                if (o = u = r = i = i || k, 3 !== i.nodeType && 8 !== i.nodeType && !Pe.test(p + D.event.triggered) && (-1 < p.indexOf(".") && (p = (f = p.split(".")).shift(), f.sort()), l = p.indexOf(":") < 0 && "on" + p, (t = t[D.expando] ? t : new D.Event(p, "object" == typeof t && t)).isTrigger = n ? 2 : 3, t.namespace = f.join("."), t.rnamespace = t.namespace ? new RegExp("(^|\\.)" + f.join("\\.(?:.*\\.|)") + "(\\.|$)") : null, t.result = void 0, t.target || (t.target = i), e = null == e ? [t] : D.makeArray(e, [t]), c = D.event.special[p] || {}, n || !c.trigger || !1 !== c.trigger.apply(i, e))) {
                    if (!n && !c.noBubble && !g(i)) {
                        for (a = c.delegateType || p, Pe.test(a + p) || (o = o.parentNode); o; o = o.parentNode) d.push(o), r = o;
                        r === (i.ownerDocument || k) && d.push(r.defaultView || r.parentWindow || x)
                    }
                    for (s = 0;
                        (o = d[s++]) && !t.isPropagationStopped();) u = o, t.type = 1 < s ? a : c.bindType || p, (h = (X.get(o, "events") || {})[t.type] && X.get(o, "handle")) && h.apply(o, e), (h = l && o[l]) && h.apply && K(o) && (t.result = h.apply(o, e), !1 === t.result && t.preventDefault());
                    return t.type = p, n || t.isDefaultPrevented() || c._default && !1 !== c._default.apply(d.pop(), e) || !K(i) || l && b(i[p]) && !g(i) && ((r = i[l]) && (i[l] = null), D.event.triggered = p, t.isPropagationStopped() && u.addEventListener(p, Ae), i[p](), t.isPropagationStopped() && u.removeEventListener(p, Ae), D.event.triggered = void 0, r && (i[l] = r)), t.result
                }
            },
            simulate: function (t, e, i) {
                var n = D.extend(new D.Event, i, {
                    type: t,
                    isSimulated: !0
                });
                D.event.trigger(n, null, e)
            }
        }), D.fn.extend({
            trigger: function (t, e) {
                return this.each(function () {
                    D.event.trigger(t, e, this)
                })
            },
            triggerHandler: function (t, e) {
                var i = this[0];
                if (i) return D.event.trigger(t, e, i, !0)
            }
        }), _.focusin || D.each({
            focus: "focusin",
            blur: "focusout"
        }, function (i, n) {
            function s(t) {
                D.event.simulate(n, t.target, D.event.fix(t))
            }
            D.event.special[n] = {
                setup: function () {
                    var t = this.ownerDocument || this,
                        e = X.access(t, n);
                    e || t.addEventListener(i, s, !0), X.access(t, n, (e || 0) + 1)
                },
                teardown: function () {
                    var t = this.ownerDocument || this,
                        e = X.access(t, n) - 1;
                    e ? X.access(t, n, e) : (t.removeEventListener(i, s, !0), X.remove(t, n))
                }
            }
        });
        var Ne = x.location,
            Oe = Date.now(),
            Me = /\?/;
        D.parseXML = function (t) {
            var e;
            if (!t || "string" != typeof t) return null;
            try {
                e = (new x.DOMParser).parseFromString(t, "text/xml")
            } catch (t) {
                e = void 0
            }
            return e && !e.getElementsByTagName("parsererror").length || D.error("Invalid XML: " + t), e
        };
        var $e = /\[\]$/,
            He = /\r?\n/g,
            Le = /^(?:submit|button|image|reset|file)$/i,
            Re = /^(?:input|select|textarea|keygen)/i;

        function We(i, t, n, s) {
            var e;
            if (Array.isArray(t)) D.each(t, function (t, e) {
                n || $e.test(i) ? s(i, e) : We(i + "[" + ("object" == typeof e && null != e ? t : "") + "]", e, n, s)
            });
            else if (n || "object" !== w(t)) s(i, t);
            else
                for (e in t) We(i + "[" + e + "]", t[e], n, s)
        }
        D.param = function (t, e) {
            function i(t, e) {
                var i = b(e) ? e() : e;
                s[s.length] = encodeURIComponent(t) + "=" + encodeURIComponent(null == i ? "" : i)
            }
            var n, s = [];
            if (null == t) return "";
            if (Array.isArray(t) || t.jquery && !D.isPlainObject(t)) D.each(t, function () {
                i(this.name, this.value)
            });
            else
                for (n in t) We(n, t[n], e, i);
            return s.join("&")
        }, D.fn.extend({
            serialize: function () {
                return D.param(this.serializeArray())
            },
            serializeArray: function () {
                return this.map(function () {
                    var t = D.prop(this, "elements");
                    return t ? D.makeArray(t) : this
                }).filter(function () {
                    var t = this.type;
                    return this.name && !D(this).is(":disabled") && Re.test(this.nodeName) && !Le.test(t) && (this.checked || !ut.test(t))
                }).map(function (t, e) {
                    var i = D(this).val();
                    return null == i ? null : Array.isArray(i) ? D.map(i, function (t) {
                        return {
                            name: e.name,
                            value: t.replace(He, "\r\n")
                        }
                    }) : {
                            name: e.name,
                            value: i.replace(He, "\r\n")
                        }
                }).get()
            }
        });
        var Fe = /%20/g,
            je = /#.*$/,
            ze = /([?&])_=[^&]*/,
            qe = /^(.*?):[ \t]*([^\r\n]*)$/gm,
            Be = /^(?:GET|HEAD)$/,
            Ue = /^\/\//,
            Ye = {},
            Ke = {},
            Ve = "*/".concat("*"),
            Xe = k.createElement("a");

        function Qe(o) {
            return function (t, e) {
                "string" != typeof t && (e = t, t = "*");
                var i, n = 0,
                    s = t.toLowerCase().match($) || [];
                if (b(e))
                    for (; i = s[n++];) "+" === i[0] ? (i = i.slice(1) || "*", (o[i] = o[i] || []).unshift(e)) : (o[i] = o[i] || []).push(e)
            }
        }

        function Ge(e, s, o, r) {
            var a = {},
                l = e === Ke;

            function h(t) {
                var n;
                return a[t] = !0, D.each(e[t] || [], function (t, e) {
                    var i = e(s, o, r);
                    return "string" != typeof i || l || a[i] ? l ? !(n = i) : void 0 : (s.dataTypes.unshift(i), h(i), !1)
                }), n
            }
            return h(s.dataTypes[0]) || !a["*"] && h("*")
        }

        function Je(t, e) {
            var i, n, s = D.ajaxSettings.flatOptions || {};
            for (i in e) void 0 !== e[i] && ((s[i] ? t : n = n || {})[i] = e[i]);
            return n && D.extend(!0, t, n), t
        }
        Xe.href = Ne.href, D.extend({
            active: 0,
            lastModified: {},
            etag: {},
            ajaxSettings: {
                url: Ne.href,
                type: "GET",
                isLocal: /^(?:about|app|app-storage|.+-extension|file|res|widget):$/.test(Ne.protocol),
                global: !0,
                processData: !0,
                async: !0,
                contentType: "application/x-www-form-urlencoded; charset=UTF-8",
                accepts: {
                    "*": Ve,
                    text: "text/plain",
                    html: "text/html",
                    xml: "application/xml, text/xml",
                    json: "application/json, text/javascript"
                },
                contents: {
                    xml: /\bxml\b/,
                    html: /\bhtml/,
                    json: /\bjson\b/
                },
                responseFields: {
                    xml: "responseXML",
                    text: "responseText",
                    json: "responseJSON"
                },
                converters: {
                    "* text": String,
                    "text html": !0,
                    "text json": JSON.parse,
                    "text xml": D.parseXML
                },
                flatOptions: {
                    url: !0,
                    context: !0
                }
            },
            ajaxSetup: function (t, e) {
                return e ? Je(Je(t, D.ajaxSettings), e) : Je(D.ajaxSettings, t)
            },
            ajaxPrefilter: Qe(Ye),
            ajaxTransport: Qe(Ke),
            ajax: function (t, e) {
                "object" == typeof t && (e = t, t = void 0), e = e || {};
                var c, u, d, i, p, n, f, g, s, o, m = D.ajaxSetup({}, e),
                    v = m.context || m,
                    _ = m.context && (v.nodeType || v.jquery) ? D(v) : D.event,
                    b = D.Deferred(),
                    y = D.Callbacks("once memory"),
                    w = m.statusCode || {},
                    r = {},
                    a = {},
                    l = "canceled",
                    C = {
                        readyState: 0,
                        getResponseHeader: function (t) {
                            var e;
                            if (f) {
                                if (!i)
                                    for (i = {}; e = qe.exec(d);) i[e[1].toLowerCase() + " "] = (i[e[1].toLowerCase() + " "] || []).concat(e[2]);
                                e = i[t.toLowerCase() + " "]
                            }
                            return null == e ? null : e.join(", ")
                        },
                        getAllResponseHeaders: function () {
                            return f ? d : null
                        },
                        setRequestHeader: function (t, e) {
                            return null == f && (t = a[t.toLowerCase()] = a[t.toLowerCase()] || t, r[t] = e), this
                        },
                        overrideMimeType: function (t) {
                            return null == f && (m.mimeType = t), this
                        },
                        statusCode: function (t) {
                            var e;
                            if (t)
                                if (f) C.always(t[C.status]);
                                else
                                    for (e in t) w[e] = [w[e], t[e]];
                            return this
                        },
                        abort: function (t) {
                            var e = t || l;
                            return c && c.abort(e), h(0, e), this
                        }
                    };
                if (b.promise(C), m.url = ((t || m.url || Ne.href) + "").replace(Ue, Ne.protocol + "//"), m.type = e.method || e.type || m.method || m.type, m.dataTypes = (m.dataType || "*").toLowerCase().match($) || [""], null == m.crossDomain) {
                    n = k.createElement("a");
                    try {
                        n.href = m.url, n.href = n.href, m.crossDomain = Xe.protocol + "//" + Xe.host != n.protocol + "//" + n.host
                    } catch (t) {
                        m.crossDomain = !0
                    }
                }
                if (m.data && m.processData && "string" != typeof m.data && (m.data = D.param(m.data, m.traditional)), Ge(Ye, m, e, C), f) return C;
                for (s in (g = D.event && m.global) && 0 == D.active++ && D.event.trigger("ajaxStart"), m.type = m.type.toUpperCase(), m.hasContent = !Be.test(m.type), u = m.url.replace(je, ""), m.hasContent ? m.data && m.processData && 0 === (m.contentType || "").indexOf("application/x-www-form-urlencoded") && (m.data = m.data.replace(Fe, "+")) : (o = m.url.slice(u.length), m.data && (m.processData || "string" == typeof m.data) && (u += (Me.test(u) ? "&" : "?") + m.data, delete m.data), !1 === m.cache && (u = u.replace(ze, "$1"), o = (Me.test(u) ? "&" : "?") + "_=" + Oe++ + o), m.url = u + o), m.ifModified && (D.lastModified[u] && C.setRequestHeader("If-Modified-Since", D.lastModified[u]), D.etag[u] && C.setRequestHeader("If-None-Match", D.etag[u])), (m.data && m.hasContent && !1 !== m.contentType || e.contentType) && C.setRequestHeader("Content-Type", m.contentType), C.setRequestHeader("Accept", m.dataTypes[0] && m.accepts[m.dataTypes[0]] ? m.accepts[m.dataTypes[0]] + ("*" !== m.dataTypes[0] ? ", " + Ve + "; q=0.01" : "") : m.accepts["*"]), m.headers) C.setRequestHeader(s, m.headers[s]);
                if (m.beforeSend && (!1 === m.beforeSend.call(v, C, m) || f)) return C.abort();
                if (l = "abort", y.add(m.complete), C.done(m.success), C.fail(m.error), c = Ge(Ke, m, e, C)) {
                    if (C.readyState = 1, g && _.trigger("ajaxSend", [C, m]), f) return C;
                    m.async && 0 < m.timeout && (p = x.setTimeout(function () {
                        C.abort("timeout")
                    }, m.timeout));
                    try {
                        f = !1, c.send(r, h)
                    } catch (t) {
                        if (f) throw t;
                        h(-1, t)
                    }
                } else h(-1, "No Transport");

                function h(t, e, i, n) {
                    var s, o, r, a, l, h = e;
                    f || (f = !0, p && x.clearTimeout(p), c = void 0, d = n || "", C.readyState = 0 < t ? 4 : 0, s = 200 <= t && t < 300 || 304 === t, i && (a = function (t, e, i) {
                        for (var n, s, o, r, a = t.contents, l = t.dataTypes;
                            "*" === l[0];) l.shift(), void 0 === n && (n = t.mimeType || e.getResponseHeader("Content-Type"));
                        if (n)
                            for (s in a)
                                if (a[s] && a[s].test(n)) {
                                    l.unshift(s);
                                    break
                                }
                        if (l[0] in i) o = l[0];
                        else {
                            for (s in i) {
                                if (!l[0] || t.converters[s + " " + l[0]]) {
                                    o = s;
                                    break
                                }
                                r = r || s
                            }
                            o = o || r
                        }
                        if (o) return o !== l[0] && l.unshift(o), i[o]
                    }(m, C, i)), a = function (t, e, i, n) {
                        var s, o, r, a, l, h = {},
                            c = t.dataTypes.slice();
                        if (c[1])
                            for (r in t.converters) h[r.toLowerCase()] = t.converters[r];
                        for (o = c.shift(); o;)
                            if (t.responseFields[o] && (i[t.responseFields[o]] = e), !l && n && t.dataFilter && (e = t.dataFilter(e, t.dataType)), l = o, o = c.shift())
                                if ("*" === o) o = l;
                                else if ("*" !== l && l !== o) {
                                    if (!(r = h[l + " " + o] || h["* " + o]))
                                        for (s in h)
                                            if ((a = s.split(" "))[1] === o && (r = h[l + " " + a[0]] || h["* " + a[0]])) {
                                                !0 === r ? r = h[s] : !0 !== h[s] && (o = a[0], c.unshift(a[1]));
                                                break
                                            }
                                    if (!0 !== r)
                                        if (r && t.throws) e = r(e);
                                        else try {
                                            e = r(e)
                                        } catch (t) {
                                            return {
                                                state: "parsererror",
                                                error: r ? t : "No conversion from " + l + " to " + o
                                            }
                                        }
                                }
                        return {
                            state: "success",
                            data: e
                        }
                    }(m, a, C, s), s ? (m.ifModified && ((l = C.getResponseHeader("Last-Modified")) && (D.lastModified[u] = l), (l = C.getResponseHeader("etag")) && (D.etag[u] = l)), 204 === t || "HEAD" === m.type ? h = "nocontent" : 304 === t ? h = "notmodified" : (h = a.state, o = a.data, s = !(r = a.error))) : (r = h, !t && h || (h = "error", t < 0 && (t = 0))), C.status = t, C.statusText = (e || h) + "", s ? b.resolveWith(v, [o, h, C]) : b.rejectWith(v, [C, h, r]), C.statusCode(w), w = void 0, g && _.trigger(s ? "ajaxSuccess" : "ajaxError", [C, m, s ? o : r]), y.fireWith(v, [C, h]), g && (_.trigger("ajaxComplete", [C, m]), --D.active || D.event.trigger("ajaxStop")))
                }
                return C
            },
            getJSON: function (t, e, i) {
                return D.get(t, e, i, "json")
            },
            getScript: function (t, e) {
                return D.get(t, void 0, e, "script")
            }
        }), D.each(["get", "post"], function (t, s) {
            D[s] = function (t, e, i, n) {
                return b(e) && (n = n || i, i = e, e = void 0), D.ajax(D.extend({
                    url: t,
                    type: s,
                    dataType: n,
                    data: e,
                    success: i
                }, D.isPlainObject(t) && t))
            }
        }), D._evalUrl = function (t, e) {
            return D.ajax({
                url: t,
                type: "GET",
                dataType: "script",
                cache: !0,
                async: !1,
                global: !1,
                converters: {
                    "text script": function () { }
                },
                dataFilter: function (t) {
                    D.globalEval(t, e)
                }
            })
        }, D.fn.extend({
            wrapAll: function (t) {
                var e;
                return this[0] && (b(t) && (t = t.call(this[0])), e = D(t, this[0].ownerDocument).eq(0).clone(!0), this[0].parentNode && e.insertBefore(this[0]), e.map(function () {
                    for (var t = this; t.firstElementChild;) t = t.firstElementChild;
                    return t
                }).append(this)), this
            },
            wrapInner: function (i) {
                return b(i) ? this.each(function (t) {
                    D(this).wrapInner(i.call(this, t))
                }) : this.each(function () {
                    var t = D(this),
                        e = t.contents();
                    e.length ? e.wrapAll(i) : t.append(i)
                })
            },
            wrap: function (e) {
                var i = b(e);
                return this.each(function (t) {
                    D(this).wrapAll(i ? e.call(this, t) : e)
                })
            },
            unwrap: function (t) {
                return this.parent(t).not("body").each(function () {
                    D(this).replaceWith(this.childNodes)
                }), this
            }
        }), D.expr.pseudos.hidden = function (t) {
            return !D.expr.pseudos.visible(t)
        }, D.expr.pseudos.visible = function (t) {
            return !!(t.offsetWidth || t.offsetHeight || t.getClientRects().length)
        }, D.ajaxSettings.xhr = function () {
            try {
                return new x.XMLHttpRequest
            } catch (t) { }
        };
        var Ze = {
            0: 200,
            1223: 204
        },
            ti = D.ajaxSettings.xhr();
        _.cors = !!ti && "withCredentials" in ti, _.ajax = ti = !!ti, D.ajaxTransport(function (s) {
            var o, r;
            if (_.cors || ti && !s.crossDomain) return {
                send: function (t, e) {
                    var i, n = s.xhr();
                    if (n.open(s.type, s.url, s.async, s.username, s.password), s.xhrFields)
                        for (i in s.xhrFields) n[i] = s.xhrFields[i];
                    for (i in s.mimeType && n.overrideMimeType && n.overrideMimeType(s.mimeType), s.crossDomain || t["X-Requested-With"] || (t["X-Requested-With"] = "XMLHttpRequest"), t) n.setRequestHeader(i, t[i]);
                    o = function (t) {
                        return function () {
                            o && (o = r = n.onload = n.onerror = n.onabort = n.ontimeout = n.onreadystatechange = null, "abort" === t ? n.abort() : "error" === t ? "number" != typeof n.status ? e(0, "error") : e(n.status, n.statusText) : e(Ze[n.status] || n.status, n.statusText, "text" !== (n.responseType || "text") || "string" != typeof n.responseText ? {
                                binary: n.response
                            } : {
                                    text: n.responseText
                                }, n.getAllResponseHeaders()))
                        }
                    }, n.onload = o(), r = n.onerror = n.ontimeout = o("error"), void 0 !== n.onabort ? n.onabort = r : n.onreadystatechange = function () {
                        4 === n.readyState && x.setTimeout(function () {
                            o && r()
                        })
                    }, o = o("abort");
                    try {
                        n.send(s.hasContent && s.data || null)
                    } catch (t) {
                        if (o) throw t
                    }
                },
                abort: function () {
                    o && o()
                }
            }
        }), D.ajaxPrefilter(function (t) {
            t.crossDomain && (t.contents.script = !1)
        }), D.ajaxSetup({
            accepts: {
                script: "text/javascript, application/javascript, application/ecmascript, application/x-ecmascript"
            },
            contents: {
                script: /\b(?:java|ecma)script\b/
            },
            converters: {
                "text script": function (t) {
                    return D.globalEval(t), t
                }
            }
        }), D.ajaxPrefilter("script", function (t) {
            void 0 === t.cache && (t.cache = !1), t.crossDomain && (t.type = "GET")
        }), D.ajaxTransport("script", function (i) {
            var n, s;
            if (i.crossDomain || i.scriptAttrs) return {
                send: function (t, e) {
                    n = D("<script>").attr(i.scriptAttrs || {}).prop({
                        charset: i.scriptCharset,
                        src: i.url
                    }).on("load error", s = function (t) {
                        n.remove(), s = null, t && e("error" === t.type ? 404 : 200, t.type)
                    }), k.head.appendChild(n[0])
                },
                abort: function () {
                    s && s()
                }
            }
        });
        var ei, ii = [],
            ni = /(=)\?(?=&|$)|\?\?/;
        D.ajaxSetup({
            jsonp: "callback",
            jsonpCallback: function () {
                var t = ii.pop() || D.expando + "_" + Oe++;
                return this[t] = !0, t
            }
        }), D.ajaxPrefilter("json jsonp", function (t, e, i) {
            var n, s, o, r = !1 !== t.jsonp && (ni.test(t.url) ? "url" : "string" == typeof t.data && 0 === (t.contentType || "").indexOf("application/x-www-form-urlencoded") && ni.test(t.data) && "data");
            if (r || "jsonp" === t.dataTypes[0]) return n = t.jsonpCallback = b(t.jsonpCallback) ? t.jsonpCallback() : t.jsonpCallback, r ? t[r] = t[r].replace(ni, "$1" + n) : !1 !== t.jsonp && (t.url += (Me.test(t.url) ? "&" : "?") + t.jsonp + "=" + n), t.converters["script json"] = function () {
                return o || D.error(n + " was not called"), o[0]
            }, t.dataTypes[0] = "json", s = x[n], x[n] = function () {
                o = arguments
            }, i.always(function () {
                void 0 === s ? D(x).removeProp(n) : x[n] = s, t[n] && (t.jsonpCallback = e.jsonpCallback, ii.push(n)), o && b(s) && s(o[0]), o = s = void 0
            }), "script"
        }), _.createHTMLDocument = ((ei = k.implementation.createHTMLDocument("").body).innerHTML = "<form></form><form></form>", 2 === ei.childNodes.length), D.parseHTML = function (t, e, i) {
            return "string" != typeof t ? [] : ("boolean" == typeof e && (i = e, e = !1), e || (_.createHTMLDocument ? ((n = (e = k.implementation.createHTMLDocument("")).createElement("base")).href = k.location.href, e.head.appendChild(n)) : e = k), o = !i && [], (s = E.exec(t)) ? [e.createElement(s[1])] : (s = yt([t], e, o), o && o.length && D(o).remove(), D.merge([], s.childNodes)));
            var n, s, o
        }, D.fn.load = function (t, e, i) {
            var n, s, o, r = this,
                a = t.indexOf(" ");
            return -1 < a && (n = Te(t.slice(a)), t = t.slice(0, a)), b(e) ? (i = e, e = void 0) : e && "object" == typeof e && (s = "POST"), 0 < r.length && D.ajax({
                url: t,
                type: s || "GET",
                dataType: "html",
                data: e
            }).done(function (t) {
                o = arguments, r.html(n ? D("<div>").append(D.parseHTML(t)).find(n) : t)
            }).always(i && function (t, e) {
                r.each(function () {
                    i.apply(this, o || [t.responseText, e, t])
                })
            }), this
        }, D.each(["ajaxStart", "ajaxStop", "ajaxComplete", "ajaxError", "ajaxSuccess", "ajaxSend"], function (t, e) {
            D.fn[e] = function (t) {
                return this.on(e, t)
            }
        }), D.expr.pseudos.animated = function (e) {
            return D.grep(D.timers, function (t) {
                return e === t.elem
            }).length
        }, D.offset = {
            setOffset: function (t, e, i) {
                var n, s, o, r, a, l, h = D.css(t, "position"),
                    c = D(t),
                    u = {};
                "static" === h && (t.style.position = "relative"), a = c.offset(), o = D.css(t, "top"), l = D.css(t, "left"), s = ("absolute" === h || "fixed" === h) && -1 < (o + l).indexOf("auto") ? (r = (n = c.position()).top, n.left) : (r = parseFloat(o) || 0, parseFloat(l) || 0), b(e) && (e = e.call(t, i, D.extend({}, a))), null != e.top && (u.top = e.top - a.top + r), null != e.left && (u.left = e.left - a.left + s), "using" in e ? e.using.call(t, u) : c.css(u)
            }
        }, D.fn.extend({
            offset: function (e) {
                if (arguments.length) return void 0 === e ? this : this.each(function (t) {
                    D.offset.setOffset(this, e, t)
                });
                var t, i, n = this[0];
                return n ? n.getClientRects().length ? (t = n.getBoundingClientRect(), i = n.ownerDocument.defaultView, {
                    top: t.top + i.pageYOffset,
                    left: t.left + i.pageXOffset
                }) : {
                        top: 0,
                        left: 0
                    } : void 0
            },
            position: function () {
                if (this[0]) {
                    var t, e, i, n = this[0],
                        s = {
                            top: 0,
                            left: 0
                        };
                    if ("fixed" === D.css(n, "position")) e = n.getBoundingClientRect();
                    else {
                        for (e = this.offset(), i = n.ownerDocument, t = n.offsetParent || i.documentElement; t && (t === i.body || t === i.documentElement) && "static" === D.css(t, "position");) t = t.parentNode;
                        t && t !== n && 1 === t.nodeType && ((s = D(t).offset()).top += D.css(t, "borderTopWidth", !0), s.left += D.css(t, "borderLeftWidth", !0))
                    }
                    return {
                        top: e.top - s.top - D.css(n, "marginTop", !0),
                        left: e.left - s.left - D.css(n, "marginLeft", !0)
                    }
                }
            },
            offsetParent: function () {
                return this.map(function () {
                    for (var t = this.offsetParent; t && "static" === D.css(t, "position");) t = t.offsetParent;
                    return t || nt
                })
            }
        }), D.each({
            scrollLeft: "pageXOffset",
            scrollTop: "pageYOffset"
        }, function (e, s) {
            var o = "pageYOffset" === s;
            D.fn[e] = function (t) {
                return z(this, function (t, e, i) {
                    var n;
                    if (g(t) ? n = t : 9 === t.nodeType && (n = t.defaultView), void 0 === i) return n ? n[s] : t[e];
                    n ? n.scrollTo(o ? n.pageXOffset : i, o ? i : n.pageYOffset) : t[e] = i
                }, e, t, arguments.length)
            }
        }), D.each(["top", "left"], function (t, i) {
            D.cssHooks[i] = Qt(_.pixelPosition, function (t, e) {
                if (e) return e = Xt(t, i), Yt.test(e) ? D(t).position()[i] + "px" : e
            })
        }), D.each({
            Height: "height",
            Width: "width"
        }, function (r, a) {
            D.each({
                padding: "inner" + r,
                content: a,
                "": "outer" + r
            }, function (n, o) {
                D.fn[o] = function (t, e) {
                    var i = arguments.length && (n || "boolean" != typeof t),
                        s = n || (!0 === t || !0 === e ? "margin" : "border");
                    return z(this, function (t, e, i) {
                        var n;
                        return g(t) ? 0 === o.indexOf("outer") ? t["inner" + r] : t.document.documentElement["client" + r] : 9 === t.nodeType ? (n = t.documentElement, Math.max(t.body["scroll" + r], n["scroll" + r], t.body["offset" + r], n["offset" + r], n["client" + r])) : void 0 === i ? D.css(t, e, s) : D.style(t, e, i, s)
                    }, a, i ? t : void 0, i)
                }
            })
        }), D.each("blur focus focusin focusout resize scroll click dblclick mousedown mouseup mousemove mouseover mouseout mouseenter mouseleave change select submit keydown keypress keyup contextmenu".split(" "), function (t, i) {
            D.fn[i] = function (t, e) {
                return 0 < arguments.length ? this.on(i, null, t, e) : this.trigger(i)
            }
        }), D.fn.extend({
            hover: function (t, e) {
                return this.mouseenter(t).mouseleave(e || t)
            }
        }), D.fn.extend({
            bind: function (t, e, i) {
                return this.on(t, null, e, i)
            },
            unbind: function (t, e) {
                return this.off(t, null, e)
            },
            delegate: function (t, e, i, n) {
                return this.on(e, t, i, n)
            },
            undelegate: function (t, e, i) {
                return 1 === arguments.length ? this.off(t, "**") : this.off(e, t || "**", i)
            }
        }), D.proxy = function (t, e) {
            var i, n, s;
            if ("string" == typeof e && (i = t[e], e = t, t = i), b(t)) return n = a.call(arguments, 2), (s = function () {
                return t.apply(e || this, n.concat(a.call(arguments)))
            }).guid = t.guid = t.guid || D.guid++ , s
        }, D.holdReady = function (t) {
            t ? D.readyWait++ : D.ready(!0)
        }, D.isArray = Array.isArray, D.parseJSON = JSON.parse, D.nodeName = S, D.isFunction = b, D.isWindow = g, D.camelCase = Y, D.type = w, D.now = Date.now, D.isNumeric = function (t) {
            var e = D.type(t);
            return ("number" === e || "string" === e) && !isNaN(t - parseFloat(t))
        }, "function" == typeof define && define.amd && define("jquery", [], function () {
            return D
        });
        var si = x.jQuery,
            oi = x.$;
        return D.noConflict = function (t) {
            return x.$ === D && (x.$ = oi), t && x.jQuery === D && (x.jQuery = si), D
        }, t || (x.jQuery = x.$ = D), D
    }),
    function (t) {
        "function" == typeof define && define.amd ? define(["jquery"], t) : t(jQuery)
    }(function (x) {
        function t() {
            this._curInst = null, this._keyEvent = !1, this._disabledInputs = [], this._datepickerShowing = !1, this._inDialog = !1, this._mainDivId = "ui-datepicker-div", this._inlineClass = "ui-datepicker-inline", this._appendClass = "ui-datepicker-append", this._triggerClass = "ui-datepicker-trigger", this._dialogClass = "ui-datepicker-dialog", this._disableClass = "ui-datepicker-disabled", this._unselectableClass = "ui-datepicker-unselectable", this._currentClass = "ui-datepicker-current-day", this._dayOverClass = "ui-datepicker-days-cell-over", this.regional = [], this.regional[""] = {
                closeText: "Done",
                prevText: "Prev",
                nextText: "Next",
                currentText: "Today",
                monthNames: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"],
                monthNamesShort: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
                dayNames: ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"],
                dayNamesShort: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"],
                dayNamesMin: ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"],
                weekHeader: "Wk",
                dateFormat: "mm/dd/yy",
                firstDay: 0,
                isRTL: !1,
                showMonthAfterYear: !1,
                yearSuffix: ""
            }, this._defaults = {
                showOn: "focus",
                showAnim: "fadeIn",
                showOptions: {},
                defaultDate: null,
                appendText: "",
                buttonText: "...",
                buttonImage: "",
                buttonImageOnly: !1,
                hideIfNoPrevNext: !1,
                navigationAsDateFormat: !1,
                gotoCurrent: !1,
                changeMonth: !1,
                changeYear: !1,
                yearRange: "c-10:c+10",
                showOtherMonths: !1,
                selectOtherMonths: !1,
                showWeek: !1,
                calculateWeek: this.iso8601Week,
                shortYearCutoff: "+10",
                minDate: null,
                maxDate: null,
                duration: "fast",
                beforeShowDay: null,
                beforeShow: null,
                onSelect: null,
                onChangeMonthYear: null,
                onClose: null,
                numberOfMonths: 1,
                showCurrentAtPos: 0,
                stepMonths: 1,
                stepBigMonths: 12,
                altField: "",
                altFormat: "",
                constrainInput: !0,
                showButtonPanel: !1,
                autoSize: !1,
                disabled: !1
            }, x.extend(this._defaults, this.regional[""]), this.regional.en = x.extend(!0, {}, this.regional[""]), this.regional["en-US"] = x.extend(!0, {}, this.regional.en), this.dpDiv = i(x("<div id='" + this._mainDivId + "' class='ui-datepicker ui-widget ui-widget-content ui-helper-clearfix ui-corner-all'></div>"))
        }

        function i(t) {
            var e = "button, .ui-datepicker-prev, .ui-datepicker-next, .ui-datepicker-calendar td a";
            return t.on("mouseout", e, function () {
                x(this).removeClass("ui-state-hover"), -1 !== this.className.indexOf("ui-datepicker-prev") && x(this).removeClass("ui-datepicker-prev-hover"), -1 !== this.className.indexOf("ui-datepicker-next") && x(this).removeClass("ui-datepicker-next-hover")
            }).on("mouseover", e, o)
        }

        function o() {
            x.datepicker._isDisabledDatepicker(it.inline ? it.dpDiv.parent()[0] : it.input[0]) || (x(this).parents(".ui-datepicker-calendar").find("a").removeClass("ui-state-hover"), x(this).addClass("ui-state-hover"), -1 !== this.className.indexOf("ui-datepicker-prev") && x(this).addClass("ui-datepicker-prev-hover"), -1 !== this.className.indexOf("ui-datepicker-next") && x(this).addClass("ui-datepicker-next-hover"))
        }

        function u(t, e) {
            for (var i in x.extend(t, e), e) null == e[i] && (t[i] = e[i]);
            return t
        }

        function e(e) {
            return function () {
                var t = this.element.val();
                e.apply(this, arguments), this._refresh(), t !== this.element.val() && this._trigger("change")
            }
        }
        x.ui = x.ui || {}, x.ui.version = "1.12.1";
        var n, s, C, k, r, a, l, h, c, D, d, p = 0,
            f = Array.prototype.slice;

        function T(t, e, i) {
            return [parseFloat(t[0]) * (c.test(t[0]) ? e / 100 : 1), parseFloat(t[1]) * (c.test(t[1]) ? i / 100 : 1)]
        }

        function S(t, e) {
            return parseInt(x.css(t, e), 10) || 0
        }
        x.cleanData = (d = x.cleanData, function (t) {
            var e, i, n;
            for (n = 0; null != (i = t[n]); n++) try {
                (e = x._data(i, "events")) && e.remove && x(i).triggerHandler("remove")
            } catch (t) { }
            d(t)
        }), x.widget = function (t, i, e) {
            var n, s, o, r = {},
                a = t.split(".")[0],
                l = a + "-" + (t = t.split(".")[1]);
            return e || (e = i, i = x.Widget), x.isArray(e) && (e = x.extend.apply(null, [{}].concat(e))), x.expr[":"][l.toLowerCase()] = function (t) {
                return !!x.data(t, l)
            }, x[a] = x[a] || {}, n = x[a][t], s = x[a][t] = function (t, e) {
                return this._createWidget ? void (arguments.length && this._createWidget(t, e)) : new s(t, e)
            }, x.extend(s, n, {
                version: e.version,
                _proto: x.extend({}, e),
                _childConstructors: []
            }), (o = new i).options = x.widget.extend({}, o.options), x.each(e, function (e, n) {
                return x.isFunction(n) ? void (r[e] = function () {
                    var t, e = this._super,
                        i = this._superApply;
                    return this._super = s, this._superApply = o, t = n.apply(this, arguments), this._super = e, this._superApply = i, t
                }) : void (r[e] = n);

                function s() {
                    return i.prototype[e].apply(this, arguments)
                }

                function o(t) {
                    return i.prototype[e].apply(this, t)
                }
            }), s.prototype = x.widget.extend(o, {
                widgetEventPrefix: n && o.widgetEventPrefix || t
            }, r, {
                constructor: s,
                namespace: a,
                widgetName: t,
                widgetFullName: l
            }), n ? (x.each(n._childConstructors, function (t, e) {
                var i = e.prototype;
                x.widget(i.namespace + "." + i.widgetName, s, e._proto)
            }), delete n._childConstructors) : i._childConstructors.push(s), x.widget.bridge(t, s), s
        }, x.widget.extend = function (t) {
            for (var e, i, n = f.call(arguments, 1), s = 0, o = n.length; s < o; s++)
                for (e in n[s]) i = n[s][e], n[s].hasOwnProperty(e) && void 0 !== i && (t[e] = x.isPlainObject(i) ? x.isPlainObject(t[e]) ? x.widget.extend({}, t[e], i) : x.widget.extend({}, i) : i);
            return t
        }, x.widget.bridge = function (o, e) {
            var r = e.prototype.widgetFullName || o;
            x.fn[o] = function (i) {
                var t = "string" == typeof i,
                    n = f.call(arguments, 1),
                    s = this;
                return t ? this.length || "instance" !== i ? this.each(function () {
                    var t, e = x.data(this, r);
                    return "instance" === i ? (s = e, !1) : e ? x.isFunction(e[i]) && "_" !== i.charAt(0) ? (t = e[i].apply(e, n)) !== e && void 0 !== t ? (s = t && t.jquery ? s.pushStack(t.get()) : t, !1) : void 0 : x.error("no such method '" + i + "' for " + o + " widget instance") : x.error("cannot call methods on " + o + " prior to initialization; attempted to call method '" + i + "'")
                }) : s = void 0 : (n.length && (i = x.widget.extend.apply(null, [i].concat(n))), this.each(function () {
                    var t = x.data(this, r);
                    t ? (t.option(i || {}), t._init && t._init()) : x.data(this, r, new e(i, this))
                })), s
            }
        }, x.Widget = function () { }, x.Widget._childConstructors = [], x.Widget.prototype = {
            widgetName: "widget",
            widgetEventPrefix: "",
            defaultElement: "<div>",
            options: {
                classes: {},
                disabled: !1,
                create: null
            },
            _createWidget: function (t, e) {
                e = x(e || this.defaultElement || this)[0], this.element = x(e), this.uuid = p++ , this.eventNamespace = "." + this.widgetName + this.uuid, this.bindings = x(), this.hoverable = x(), this.focusable = x(), this.classesElementLookup = {}, e !== this && (x.data(e, this.widgetFullName, this), this._on(!0, this.element, {
                    remove: function (t) {
                        t.target === e && this.destroy()
                    }
                }), this.document = x(e.style ? e.ownerDocument : e.document || e), this.window = x(this.document[0].defaultView || this.document[0].parentWindow)), this.options = x.widget.extend({}, this.options, this._getCreateOptions(), t), this._create(), this.options.disabled && this._setOptionDisabled(this.options.disabled), this._trigger("create", null, this._getCreateEventData()), this._init()
            },
            _getCreateOptions: function () {
                return {}
            },
            _getCreateEventData: x.noop,
            _create: x.noop,
            _init: x.noop,
            destroy: function () {
                var i = this;
                this._destroy(), x.each(this.classesElementLookup, function (t, e) {
                    i._removeClass(e, t)
                }), this.element.off(this.eventNamespace).removeData(this.widgetFullName), this.widget().off(this.eventNamespace).removeAttr("aria-disabled"), this.bindings.off(this.eventNamespace)
            },
            _destroy: x.noop,
            widget: function () {
                return this.element
            },
            option: function (t, e) {
                var i, n, s, o = t;
                if (0 === arguments.length) return x.widget.extend({}, this.options);
                if ("string" == typeof t)
                    if (o = {}, t = (i = t.split(".")).shift(), i.length) {
                        for (n = o[t] = x.widget.extend({}, this.options[t]), s = 0; i.length - 1 > s; s++) n[i[s]] = n[i[s]] || {}, n = n[i[s]];
                        if (t = i.pop(), 1 === arguments.length) return void 0 === n[t] ? null : n[t];
                        n[t] = e
                    } else {
                        if (1 === arguments.length) return void 0 === this.options[t] ? null : this.options[t];
                        o[t] = e
                    }
                return this._setOptions(o), this
            },
            _setOptions: function (t) {
                var e;
                for (e in t) this._setOption(e, t[e]);
                return this
            },
            _setOption: function (t, e) {
                return "classes" === t && this._setOptionClasses(e), this.options[t] = e, "disabled" === t && this._setOptionDisabled(e), this
            },
            _setOptionClasses: function (t) {
                var e, i, n;
                for (e in t) n = this.classesElementLookup[e], t[e] !== this.options.classes[e] && n && n.length && (i = x(n.get()), this._removeClass(n, e), i.addClass(this._classes({
                    element: i,
                    keys: e,
                    classes: t,
                    add: !0
                })))
            },
            _setOptionDisabled: function (t) {
                this._toggleClass(this.widget(), this.widgetFullName + "-disabled", null, !!t), t && (this._removeClass(this.hoverable, null, "ui-state-hover"), this._removeClass(this.focusable, null, "ui-state-focus"))
            },
            enable: function () {
                return this._setOptions({
                    disabled: !1
                })
            },
            disable: function () {
                return this._setOptions({
                    disabled: !0
                })
            },
            _classes: function (s) {
                function t(t, e) {
                    var i, n;
                    for (n = 0; t.length > n; n++) i = r.classesElementLookup[t[n]] || x(), i = s.add ? x(x.unique(i.get().concat(s.element.get()))) : x(i.not(s.element).get()), r.classesElementLookup[t[n]] = i, o.push(t[n]), e && s.classes[t[n]] && o.push(s.classes[t[n]])
                }
                var o = [],
                    r = this;
                return s = x.extend({
                    element: this.element,
                    classes: this.options.classes || {}
                }, s), this._on(s.element, {
                    remove: "_untrackClassesElement"
                }), s.keys && t(s.keys.match(/\S+/g) || [], !0), s.extra && t(s.extra.match(/\S+/g) || []), o.join(" ")
            },
            _untrackClassesElement: function (i) {
                var n = this;
                x.each(n.classesElementLookup, function (t, e) {
                    -1 !== x.inArray(i.target, e) && (n.classesElementLookup[t] = x(e.not(i.target).get()))
                })
            },
            _removeClass: function (t, e, i) {
                return this._toggleClass(t, e, i, !1)
            },
            _addClass: function (t, e, i) {
                return this._toggleClass(t, e, i, !0)
            },
            _toggleClass: function (t, e, i, n) {
                n = "boolean" == typeof n ? n : i;
                var s = "string" == typeof t || null === t,
                    o = {
                        extra: s ? e : i,
                        keys: s ? t : e,
                        element: s ? this.element : t,
                        add: n
                    };
                return o.element.toggleClass(this._classes(o), n), this
            },
            _on: function (r, a, t) {
                var l, h = this;
                "boolean" != typeof r && (t = a, a = r, r = !1), t ? (a = l = x(a), this.bindings = this.bindings.add(a)) : (t = a, a = this.element, l = this.widget()), x.each(t, function (t, e) {
                    function i() {
                        return r || !0 !== h.options.disabled && !x(this).hasClass("ui-state-disabled") ? ("string" == typeof e ? h[e] : e).apply(h, arguments) : void 0
                    }
                    "string" != typeof e && (i.guid = e.guid = e.guid || i.guid || x.guid++);
                    var n = t.match(/^([\w:-]*)\s*(.*)$/),
                        s = n[1] + h.eventNamespace,
                        o = n[2];
                    o ? l.on(s, o, i) : a.on(s, i)
                })
            },
            _off: function (t, e) {
                e = (e || "").split(" ").join(this.eventNamespace + " ") + this.eventNamespace, t.off(e).off(e), this.bindings = x(this.bindings.not(t).get()), this.focusable = x(this.focusable.not(t).get()), this.hoverable = x(this.hoverable.not(t).get())
            },
            _delay: function (t, e) {
                var i = this;
                return setTimeout(function () {
                    return ("string" == typeof t ? i[t] : t).apply(i, arguments)
                }, e || 0)
            },
            _hoverable: function (t) {
                this.hoverable = this.hoverable.add(t), this._on(t, {
                    mouseenter: function (t) {
                        this._addClass(x(t.currentTarget), null, "ui-state-hover")
                    },
                    mouseleave: function (t) {
                        this._removeClass(x(t.currentTarget), null, "ui-state-hover")
                    }
                })
            },
            _focusable: function (t) {
                this.focusable = this.focusable.add(t), this._on(t, {
                    focusin: function (t) {
                        this._addClass(x(t.currentTarget), null, "ui-state-focus")
                    },
                    focusout: function (t) {
                        this._removeClass(x(t.currentTarget), null, "ui-state-focus")
                    }
                })
            },
            _trigger: function (t, e, i) {
                var n, s, o = this.options[t];
                if (i = i || {}, (e = x.Event(e)).type = (t === this.widgetEventPrefix ? t : this.widgetEventPrefix + t).toLowerCase(), e.target = this.element[0], s = e.originalEvent)
                    for (n in s) n in e || (e[n] = s[n]);
                return this.element.trigger(e, i), !(x.isFunction(o) && !1 === o.apply(this.element[0], [e].concat(i)) || e.isDefaultPrevented())
            }
        }, x.each({
            show: "fadeIn",
            hide: "fadeOut"
        }, function (o, r) {
            x.Widget.prototype["_" + o] = function (e, t, i) {
                "string" == typeof t && (t = {
                    effect: t
                });
                var n, s = t ? !0 === t || "number" == typeof t ? r : t.effect || r : o;
                "number" == typeof (t = t || {}) && (t = {
                    duration: t
                }), n = !x.isEmptyObject(t), t.complete = i, t.delay && e.delay(t.delay), n && x.effects && x.effects.effect[s] ? e[o](t) : s !== o && e[s] ? e[s](t.duration, t.easing, i) : e.queue(function (t) {
                    x(this)[o](), i && i.call(e[0]), t()
                })
            }
        }), x.widget, C = Math.max, k = Math.abs, r = /left|center|right/, a = /top|center|bottom/, l = /[\+\-]\d+(\.[\d]+)?%?/, h = /^\w+/, c = /%$/, D = x.fn.position, x.position = {
            scrollbarWidth: function () {
                if (void 0 !== s) return s;
                var t, e, i = x("<div style='display:block;position:absolute;width:50px;height:50px;overflow:hidden;'><div style='height:100px;width:auto;'></div></div>"),
                    n = i.children()[0];
                return x("body").append(i), t = n.offsetWidth, i.css("overflow", "scroll"), t === (e = n.offsetWidth) && (e = i[0].clientWidth), i.remove(), s = t - e
            },
            getScrollInfo: function (t) {
                var e = t.isWindow || t.isDocument ? "" : t.element.css("overflow-x"),
                    i = t.isWindow || t.isDocument ? "" : t.element.css("overflow-y"),
                    n = "scroll" === e || "auto" === e && t.width < t.element[0].scrollWidth;
                return {
                    width: "scroll" === i || "auto" === i && t.height < t.element[0].scrollHeight ? x.position.scrollbarWidth() : 0,
                    height: n ? x.position.scrollbarWidth() : 0
                }
            },
            getWithinInfo: function (t) {
                var e = x(t || window),
                    i = x.isWindow(e[0]),
                    n = !!e[0] && 9 === e[0].nodeType;
                return {
                    element: e,
                    isWindow: i,
                    isDocument: n,
                    offset: !i && !n ? x(t).offset() : {
                        left: 0,
                        top: 0
                    },
                    scrollLeft: e.scrollLeft(),
                    scrollTop: e.scrollTop(),
                    width: e.outerWidth(),
                    height: e.outerHeight()
                }
            }
        }, x.fn.position = function (u) {
            if (!u || !u.of) return D.apply(this, arguments);
            u = x.extend({}, u);
            var d, p, f, g, m, t, e, i, v = x(u.of),
                _ = x.position.getWithinInfo(u.within),
                b = x.position.getScrollInfo(_),
                y = (u.collision || "flip").split(" "),
                w = {};
            return t = 9 === (i = (e = v)[0]).nodeType ? {
                width: e.width(),
                height: e.height(),
                offset: {
                    top: 0,
                    left: 0
                }
            } : x.isWindow(i) ? {
                width: e.width(),
                height: e.height(),
                offset: {
                    top: e.scrollTop(),
                    left: e.scrollLeft()
                }
            } : i.preventDefault ? {
                width: 0,
                height: 0,
                offset: {
                    top: i.pageY,
                    left: i.pageX
                }
            } : {
                            width: e.outerWidth(),
                            height: e.outerHeight(),
                            offset: e.offset()
                        }, v[0].preventDefault && (u.at = "left top"), p = t.width, f = t.height, g = t.offset, m = x.extend({}, g), x.each(["my", "at"], function () {
                            var t, e, i = (u[this] || "").split(" ");
                            1 === i.length && (i = r.test(i[0]) ? i.concat(["center"]) : a.test(i[0]) ? ["center"].concat(i) : ["center", "center"]), i[0] = r.test(i[0]) ? i[0] : "center", i[1] = a.test(i[1]) ? i[1] : "center", t = l.exec(i[0]), e = l.exec(i[1]), w[this] = [t ? t[0] : 0, e ? e[0] : 0], u[this] = [h.exec(i[0])[0], h.exec(i[1])[0]]
                        }), 1 === y.length && (y[1] = y[0]), "right" === u.at[0] ? m.left += p : "center" === u.at[0] && (m.left += p / 2), "bottom" === u.at[1] ? m.top += f : "center" === u.at[1] && (m.top += f / 2), d = T(w.at, p, f), m.left += d[0], m.top += d[1], this.each(function () {
                            var i, t, r = x(this),
                                a = r.outerWidth(),
                                l = r.outerHeight(),
                                e = S(this, "marginLeft"),
                                n = S(this, "marginTop"),
                                s = a + e + S(this, "marginRight") + b.width,
                                o = l + n + S(this, "marginBottom") + b.height,
                                h = x.extend({}, m),
                                c = T(w.my, r.outerWidth(), r.outerHeight());
                            "right" === u.my[0] ? h.left -= a : "center" === u.my[0] && (h.left -= a / 2), "bottom" === u.my[1] ? h.top -= l : "center" === u.my[1] && (h.top -= l / 2), h.left += c[0], h.top += c[1], i = {
                                marginLeft: e,
                                marginTop: n
                            }, x.each(["left", "top"], function (t, e) {
                                x.ui.position[y[t]] && x.ui.position[y[t]][e](h, {
                                    targetWidth: p,
                                    targetHeight: f,
                                    elemWidth: a,
                                    elemHeight: l,
                                    collisionPosition: i,
                                    collisionWidth: s,
                                    collisionHeight: o,
                                    offset: [d[0] + c[0], d[1] + c[1]],
                                    my: u.my,
                                    at: u.at,
                                    within: _,
                                    elem: r
                                })
                            }), u.using && (t = function (t) {
                                var e = g.left - h.left,
                                    i = e + p - a,
                                    n = g.top - h.top,
                                    s = n + f - l,
                                    o = {
                                        target: {
                                            element: v,
                                            left: g.left,
                                            top: g.top,
                                            width: p,
                                            height: f
                                        },
                                        element: {
                                            element: r,
                                            left: h.left,
                                            top: h.top,
                                            width: a,
                                            height: l
                                        },
                                        horizontal: i < 0 ? "left" : 0 < e ? "right" : "center",
                                        vertical: s < 0 ? "top" : 0 < n ? "bottom" : "middle"
                                    };
                                p < a && p > k(e + i) && (o.horizontal = "center"), f < l && f > k(n + s) && (o.vertical = "middle"), o.important = C(k(e), k(i)) > C(k(n), k(s)) ? "horizontal" : "vertical", u.using.call(this, t, o)
                            }), r.offset(x.extend(h, {
                                using: t
                            }))
                        })
        }, x.ui.position = {
            fit: {
                left: function (t, e) {
                    var i, n = e.within,
                        s = n.isWindow ? n.scrollLeft : n.offset.left,
                        o = n.width,
                        r = t.left - e.collisionPosition.marginLeft,
                        a = s - r,
                        l = r + e.collisionWidth - o - s;
                    e.collisionWidth > o ? 0 < a && l <= 0 ? (i = t.left + a + e.collisionWidth - o - s, t.left += a - i) : t.left = 0 < l && a <= 0 ? s : l < a ? s + o - e.collisionWidth : s : 0 < a ? t.left += a : 0 < l ? t.left -= l : t.left = C(t.left - r, t.left)
                },
                top: function (t, e) {
                    var i, n = e.within,
                        s = n.isWindow ? n.scrollTop : n.offset.top,
                        o = e.within.height,
                        r = t.top - e.collisionPosition.marginTop,
                        a = s - r,
                        l = r + e.collisionHeight - o - s;
                    e.collisionHeight > o ? 0 < a && l <= 0 ? (i = t.top + a + e.collisionHeight - o - s, t.top += a - i) : t.top = 0 < l && a <= 0 ? s : l < a ? s + o - e.collisionHeight : s : 0 < a ? t.top += a : 0 < l ? t.top -= l : t.top = C(t.top - r, t.top)
                }
            },
            flip: {
                left: function (t, e) {
                    var i, n, s = e.within,
                        o = s.offset.left + s.scrollLeft,
                        r = s.width,
                        a = s.isWindow ? s.scrollLeft : s.offset.left,
                        l = t.left - e.collisionPosition.marginLeft,
                        h = l - a,
                        c = l + e.collisionWidth - r - a,
                        u = "left" === e.my[0] ? -e.elemWidth : "right" === e.my[0] ? e.elemWidth : 0,
                        d = "left" === e.at[0] ? e.targetWidth : "right" === e.at[0] ? -e.targetWidth : 0,
                        p = -2 * e.offset[0];
                    h < 0 ? ((i = t.left + u + d + p + e.collisionWidth - r - o) < 0 || k(h) > i) && (t.left += u + d + p) : 0 < c && ((0 < (n = t.left - e.collisionPosition.marginLeft + u + d + p - a) || c > k(n)) && (t.left += u + d + p))
                },
                top: function (t, e) {
                    var i, n, s = e.within,
                        o = s.offset.top + s.scrollTop,
                        r = s.height,
                        a = s.isWindow ? s.scrollTop : s.offset.top,
                        l = t.top - e.collisionPosition.marginTop,
                        h = l - a,
                        c = l + e.collisionHeight - r - a,
                        u = "top" === e.my[1] ? -e.elemHeight : "bottom" === e.my[1] ? e.elemHeight : 0,
                        d = "top" === e.at[1] ? e.targetHeight : "bottom" === e.at[1] ? -e.targetHeight : 0,
                        p = -2 * e.offset[1];
                    h < 0 ? ((n = t.top + u + d + p + e.collisionHeight - r - o) < 0 || k(h) > n) && (t.top += u + d + p) : 0 < c && ((0 < (i = t.top - e.collisionPosition.marginTop + u + d + p - a) || c > k(i)) && (t.top += u + d + p))
                }
            },
            flipfit: {
                left: function () {
                    x.ui.position.flip.left.apply(this, arguments), x.ui.position.fit.left.apply(this, arguments)
                },
                top: function () {
                    x.ui.position.flip.top.apply(this, arguments), x.ui.position.fit.top.apply(this, arguments)
                }
            }
        }, x.ui.position, x.extend(x.expr[":"], {
            data: x.expr.createPseudo ? x.expr.createPseudo(function (e) {
                return function (t) {
                    return !!x.data(t, e)
                }
            }) : function (t, e, i) {
                return !!x.data(t, i[3])
            }
        }), x.fn.extend({
            disableSelection: (n = "onselectstart" in document.createElement("div") ? "selectstart" : "mousedown", function () {
                return this.on(n + ".ui-disableSelection", function (t) {
                    t.preventDefault()
                })
            }),
            enableSelection: function () {
                return this.off(".ui-disableSelection")
            }
        });
        var g, m, v, _, b, y, w, E, I, A, P, N, O, M, $, H, L, R, W, F, j, z = "ui-effects-",
            q = "ui-effects-style",
            B = "ui-effects-animated",
            U = x;

        function Y(t, e, i, n) {
            return x.isPlainObject(t) && (t = (e = t).effect), t = {
                effect: t
            }, null == e && (e = {}), x.isFunction(e) && (n = e, i = null, e = {}), "number" != typeof e && !x.fx.speeds[e] || (n = i, i = e, e = {}), x.isFunction(i) && (n = i, i = null), e && x.extend(t, e), i = i || e.duration, t.duration = x.fx.off ? 0 : "number" == typeof i ? i : i in x.fx.speeds ? x.fx.speeds[i] : x.fx.speeds._default, t.complete = n || e.complete, t
        }

        function K(t) {
            return !t || "number" == typeof t || x.fx.speeds[t] || ("string" == typeof t && !x.effects.effect[t] || (x.isFunction(t) || "object" == typeof t && !t.effect))
        }

        function V(t, e) {
            var i = e.outerWidth(),
                n = e.outerHeight(),
                s = /^rect\((-?\d*\.?\d*px|-?\d+%|auto),?\s*(-?\d*\.?\d*px|-?\d+%|auto),?\s*(-?\d*\.?\d*px|-?\d+%|auto),?\s*(-?\d*\.?\d*px|-?\d+%|auto)\)$/.exec(t) || ["", 0, i, n, 0];
            return {
                top: parseFloat(s[1]) || 0,
                right: "auto" === s[2] ? i : parseFloat(s[2]),
                bottom: "auto" === s[3] ? n : parseFloat(s[3]),
                left: parseFloat(s[4]) || 0
            }
        }

        function X(t) {
            var e, i, n = t.ownerDocument.defaultView ? t.ownerDocument.defaultView.getComputedStyle(t, null) : t.currentStyle,
                s = {};
            if (n && n.length && n[0] && n[n[0]])
                for (i = n.length; i--;) "string" == typeof n[e = n[i]] && (s[x.camelCase(e)] = n[e]);
            else
                for (e in n) "string" == typeof n[e] && (s[e] = n[e]);
            return s
        }

        function Q(t, e, i) {
            var n = R[e.type] || {};
            return null == t ? i || !e.def ? null : e.def : (t = n.floor ? ~~t : parseFloat(t), isNaN(t) ? e.def : n.mod ? (t + n.mod) % n.mod : t < 0 ? 0 : n.max < t ? n.max : t)
        }

        function G(r) {
            var a = H(),
                l = a._rgba = [];
            return r = r.toLowerCase(), j($, function (t, e) {
                var i, n = e.re.exec(r),
                    s = n && e.parse(n),
                    o = e.space || "rgba";
                return s ? (i = a[o](s), a[L[o].cache] = i[L[o].cache], l = a._rgba = i._rgba, !1) : N
            }), l.length ? ("0,0,0,0" === l.join() && P.extend(l, O.transparent), a) : O[r]
        }

        function J(t, e, i) {
            return 6 * (i = (i + 1) % 1) < 1 ? t + 6 * (e - t) * i : 2 * i < 1 ? e : 3 * i < 2 ? t + 6 * (e - t) * (2 / 3 - i) : t
        }
        x.effects = {
            effect: {}
        }, M = /^([\-+])=\s*(\d+\.?\d*)/, $ = [{
            re: /rgba?\(\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})\s*(?:,\s*(\d?(?:\.\d+)?)\s*)?\)/,
            parse: function (t) {
                return [t[1], t[2], t[3], t[4]]
            }
        }, {
            re: /rgba?\(\s*(\d+(?:\.\d+)?)\%\s*,\s*(\d+(?:\.\d+)?)\%\s*,\s*(\d+(?:\.\d+)?)\%\s*(?:,\s*(\d?(?:\.\d+)?)\s*)?\)/,
            parse: function (t) {
                return [2.55 * t[1], 2.55 * t[2], 2.55 * t[3], t[4]]
            }
        }, {
            re: /#([a-f0-9]{2})([a-f0-9]{2})([a-f0-9]{2})/,
            parse: function (t) {
                return [parseInt(t[1], 16), parseInt(t[2], 16), parseInt(t[3], 16)]
            }
        }, {
            re: /#([a-f0-9])([a-f0-9])([a-f0-9])/,
            parse: function (t) {
                return [parseInt(t[1] + t[1], 16), parseInt(t[2] + t[2], 16), parseInt(t[3] + t[3], 16)]
            }
        }, {
            re: /hsla?\(\s*(\d+(?:\.\d+)?)\s*,\s*(\d+(?:\.\d+)?)\%\s*,\s*(\d+(?:\.\d+)?)\%\s*(?:,\s*(\d?(?:\.\d+)?)\s*)?\)/,
            space: "hsla",
            parse: function (t) {
                return [t[1], t[2] / 100, t[3] / 100, t[4]]
            }
        }], H = (P = U).Color = function (t, e, i, n) {
            return new P.Color.fn.parse(t, e, i, n)
        }, L = {
            rgba: {
                props: {
                    red: {
                        idx: 0,
                        type: "byte"
                    },
                    green: {
                        idx: 1,
                        type: "byte"
                    },
                    blue: {
                        idx: 2,
                        type: "byte"
                    }
                }
            },
            hsla: {
                props: {
                    hue: {
                        idx: 0,
                        type: "degrees"
                    },
                    saturation: {
                        idx: 1,
                        type: "percent"
                    },
                    lightness: {
                        idx: 2,
                        type: "percent"
                    }
                }
            }
        }, R = {
            byte: {
                floor: !0,
                max: 255
            },
            percent: {
                max: 1
            },
            degrees: {
                mod: 360,
                floor: !0
            }
        }, W = H.support = {}, F = P("<p>")[0], j = P.each, F.style.cssText = "background-color:rgba(1,1,1,.5)", W.rgba = -1 < F.style.backgroundColor.indexOf("rgba"), j(L, function (t, e) {
            e.cache = "_" + t, e.props.alpha = {
                idx: 3,
                type: "percent",
                def: 1
            }
        }), H.fn = P.extend(H.prototype, {
            parse: function (s, t, e, i) {
                if (s === N) return this._rgba = [null, null, null, null], this;
                (s.jquery || s.nodeType) && (s = P(s).css(t), t = N);
                var o = this,
                    n = P.type(s),
                    r = this._rgba = [];
                return t !== N && (s = [s, t, e, i], n = "array"), "string" === n ? this.parse(G(s) || O._default) : "array" === n ? (j(L.rgba.props, function (t, e) {
                    r[e.idx] = Q(s[e.idx], e)
                }), this) : "object" === n ? (j(L, s instanceof H ? function (t, e) {
                    s[e.cache] && (o[e.cache] = s[e.cache].slice())
                } : function (t, i) {
                    var n = i.cache;
                    j(i.props, function (t, e) {
                        if (!o[n] && i.to) {
                            if ("alpha" === t || null == s[t]) return;
                            o[n] = i.to(o._rgba)
                        }
                        o[n][e.idx] = Q(s[t], e, !0)
                    }), o[n] && P.inArray(null, o[n].slice(0, 3)) < 0 && (o[n][3] = 1, i.from && (o._rgba = i.from(o[n])))
                }), this) : N
            },
            is: function (t) {
                var s = H(t),
                    o = !0,
                    r = this;
                return j(L, function (t, e) {
                    var i, n = s[e.cache];
                    return n && (i = r[e.cache] || e.to && e.to(r._rgba) || [], j(e.props, function (t, e) {
                        return null != n[e.idx] ? o = n[e.idx] === i[e.idx] : N
                    })), o
                }), o
            },
            _space: function () {
                var i = [],
                    n = this;
                return j(L, function (t, e) {
                    n[e.cache] && i.push(t)
                }), i.pop()
            },
            transition: function (t, r) {
                var a = H(t),
                    e = a._space(),
                    i = L[e],
                    n = 0 === this.alpha() ? H("transparent") : this,
                    l = n[i.cache] || i.to(n._rgba),
                    h = l.slice();
                return a = a[i.cache], j(i.props, function (t, e) {
                    var i = e.idx,
                        n = l[i],
                        s = a[i],
                        o = R[e.type] || {};
                    null !== s && (null === n ? h[i] = s : (o.mod && (o.mod / 2 < s - n ? n += o.mod : o.mod / 2 < n - s && (n -= o.mod)), h[i] = Q((s - n) * r + n, e)))
                }), this[e](h)
            },
            blend: function (t) {
                if (1 === this._rgba[3]) return this;
                var e = this._rgba.slice(),
                    i = e.pop(),
                    n = H(t)._rgba;
                return H(P.map(e, function (t, e) {
                    return (1 - i) * n[e] + i * t
                }))
            },
            toRgbaString: function () {
                var t = "rgba(",
                    e = P.map(this._rgba, function (t, e) {
                        return null == t ? 2 < e ? 1 : 0 : t
                    });
                return 1 === e[3] && (e.pop(), t = "rgb("), t + e.join() + ")"
            },
            toHslaString: function () {
                var t = "hsla(",
                    e = P.map(this.hsla(), function (t, e) {
                        return null == t && (t = 2 < e ? 1 : 0), e && e < 3 && (t = Math.round(100 * t) + "%"), t
                    });
                return 1 === e[3] && (e.pop(), t = "hsl("), t + e.join() + ")"
            },
            toHexString: function (t) {
                var e = this._rgba.slice(),
                    i = e.pop();
                return t && e.push(~~(255 * i)), "#" + P.map(e, function (t) {
                    return 1 === (t = (t || 0).toString(16)).length ? "0" + t : t
                }).join("")
            },
            toString: function () {
                return 0 === this._rgba[3] ? "transparent" : this.toRgbaString()
            }
        }), H.fn.parse.prototype = H.fn, L.hsla.to = function (t) {
            if (null == t[0] || null == t[1] || null == t[2]) return [null, null, null, t[3]];
            var e, i, n = t[0] / 255,
                s = t[1] / 255,
                o = t[2] / 255,
                r = t[3],
                a = Math.max(n, s, o),
                l = Math.min(n, s, o),
                h = a - l,
                c = a + l,
                u = .5 * c;
            return e = l === a ? 0 : n === a ? 60 * (s - o) / h + 360 : s === a ? 60 * (o - n) / h + 120 : 60 * (n - s) / h + 240, i = 0 == h ? 0 : u <= .5 ? h / c : h / (2 - c), [Math.round(e) % 360, i, u, null == r ? 1 : r]
        }, L.hsla.from = function (t) {
            if (null == t[0] || null == t[1] || null == t[2]) return [null, null, null, t[3]];
            var e = t[0] / 360,
                i = t[1],
                n = t[2],
                s = t[3],
                o = n <= .5 ? n * (1 + i) : n + i - n * i,
                r = 2 * n - o;
            return [Math.round(255 * J(r, o, e + 1 / 3)), Math.round(255 * J(r, o, e)), Math.round(255 * J(r, o, e - 1 / 3)), s]
        }, j(L, function (l, t) {
            var i = t.props,
                r = t.cache,
                a = t.to,
                h = t.from;
            H.fn[l] = function (t) {
                if (a && !this[r] && (this[r] = a(this._rgba)), t === N) return this[r].slice();
                var e, n = P.type(t),
                    s = "array" === n || "object" === n ? t : arguments,
                    o = this[r].slice();
                return j(i, function (t, e) {
                    var i = s["object" === n ? t : e.idx];
                    null == i && (i = o[e.idx]), o[e.idx] = Q(i, e)
                }), h ? ((e = H(h(o)))[r] = o, e) : H(o)
            }, j(i, function (r, a) {
                H.fn[r] || (H.fn[r] = function (t) {
                    var e, i = P.type(t),
                        n = "alpha" === r ? this._hsla ? "hsla" : "rgba" : l,
                        s = this[n](),
                        o = s[a.idx];
                    return "undefined" === i ? o : ("function" === i && (t = t.call(this, o), i = P.type(t)), null == t && a.empty ? this : ("string" === i && ((e = M.exec(t)) && (t = o + parseFloat(e[2]) * ("+" === e[1] ? 1 : -1))), s[a.idx] = t, this[n](s)))
                })
            })
        }), H.hook = function (t) {
            var e = t.split(" ");
            j(e, function (t, o) {
                P.cssHooks[o] = {
                    set: function (t, e) {
                        var i, n, s = "";
                        if ("transparent" !== e && ("string" !== P.type(e) || (i = G(e)))) {
                            if (e = H(i || e), !W.rgba && 1 !== e._rgba[3]) {
                                for (n = "backgroundColor" === o ? t.parentNode : t;
                                    ("" === s || "transparent" === s) && n && n.style;) try {
                                        s = P.css(n, "backgroundColor"), n = n.parentNode
                                    } catch (t) { }
                                e = e.blend(s && "transparent" !== s ? s : "_default")
                            }
                            e = e.toRgbaString()
                        }
                        try {
                            t.style[o] = e
                        } catch (t) { }
                    }
                }, P.fx.step[o] = function (t) {
                    t.colorInit || (t.start = H(t.elem, o), t.end = H(t.end), t.colorInit = !0), P.cssHooks[o].set(t.elem, t.start.transition(t.end, t.pos))
                }
            })
        }, H.hook("backgroundColor borderBottomColor borderLeftColor borderRightColor borderTopColor color columnRuleColor outlineColor textDecorationColor textEmphasisColor"), P.cssHooks.borderColor = {
            expand: function (i) {
                var n = {};
                return j(["Top", "Right", "Bottom", "Left"], function (t, e) {
                    n["border" + e + "Color"] = i
                }), n
            }
        }, O = P.Color.names = {
            aqua: "#00ffff",
            black: "#000000",
            blue: "#0000ff",
            fuchsia: "#ff00ff",
            gray: "#808080",
            green: "#008000",
            lime: "#00ff00",
            maroon: "#800000",
            navy: "#000080",
            olive: "#808000",
            purple: "#800080",
            red: "#ff0000",
            silver: "#c0c0c0",
            teal: "#008080",
            white: "#ffffff",
            yellow: "#ffff00",
            transparent: [null, null, null, 0],
            _default: "#ffffff"
        }, I = ["add", "remove", "toggle"], A = {
            border: 1,
            borderBottom: 1,
            borderColor: 1,
            borderLeft: 1,
            borderRight: 1,
            borderTop: 1,
            borderWidth: 1,
            margin: 1,
            padding: 1
        }, x.each(["borderLeftStyle", "borderRightStyle", "borderBottomStyle", "borderTopStyle"], function (t, e) {
            x.fx.step[e] = function (t) {
                ("none" !== t.end && !t.setAttr || 1 === t.pos && !t.setAttr) && (U.style(t.elem, e, t.end), t.setAttr = !0)
            }
        }), x.fn.addBack || (x.fn.addBack = function (t) {
            return this.add(null == t ? this.prevObject : this.prevObject.filter(t))
        }), x.effects.animateClass = function (s, t, e, i) {
            var o = x.speed(t, e, i);
            return this.queue(function () {
                var t, i = x(this),
                    e = i.attr("class") || "",
                    n = o.children ? i.find("*").addBack() : i;
                n = n.map(function () {
                    return {
                        el: x(this),
                        start: X(this)
                    }
                }), (t = function () {
                    x.each(I, function (t, e) {
                        s[e] && i[e + "Class"](s[e])
                    })
                })(), n = n.map(function () {
                    return this.end = X(this.el[0]), this.diff = function (t, e) {
                        var i, n, s = {};
                        for (i in e) n = e[i], t[i] !== n && (A[i] || !x.fx.step[i] && isNaN(parseFloat(n)) || (s[i] = n));
                        return s
                    }(this.start, this.end), this
                }), i.attr("class", e), n = n.map(function () {
                    var t = this,
                        e = x.Deferred(),
                        i = x.extend({}, o, {
                            queue: !1,
                            complete: function () {
                                e.resolve(t)
                            }
                        });
                    return this.el.animate(this.diff, i), e.promise()
                }), x.when.apply(x, n.get()).done(function () {
                    t(), x.each(arguments, function () {
                        var e = this.el;
                        x.each(this.diff, function (t) {
                            e.css(t, "")
                        })
                    }), o.complete.call(i[0])
                })
            })
        }, x.fn.extend({
            addClass: (E = x.fn.addClass, function (t, e, i, n) {
                return e ? x.effects.animateClass.call(this, {
                    add: t
                }, e, i, n) : E.apply(this, arguments)
            }),
            removeClass: (w = x.fn.removeClass, function (t, e, i, n) {
                return 1 < arguments.length ? x.effects.animateClass.call(this, {
                    remove: t
                }, e, i, n) : w.apply(this, arguments)
            }),
            toggleClass: (y = x.fn.toggleClass, function (t, e, i, n, s) {
                return "boolean" == typeof e || void 0 === e ? i ? x.effects.animateClass.call(this, e ? {
                    add: t
                } : {
                        remove: t
                    }, i, n, s) : y.apply(this, arguments) : x.effects.animateClass.call(this, {
                        toggle: t
                    }, e, i, n)
            }),
            switchClass: function (t, e, i, n, s) {
                return x.effects.animateClass.call(this, {
                    add: e,
                    remove: t
                }, i, n, s)
            }
        }), x.expr && x.expr.filters && x.expr.filters.animated && (x.expr.filters.animated = (b = x.expr.filters.animated, function (t) {
            return !!x(t).data(B) || b(t)
        })), !1 !== x.uiBackCompat && x.extend(x.effects, {
            save: function (t, e) {
                for (var i = 0, n = e.length; i < n; i++) null !== e[i] && t.data(z + e[i], t[0].style[e[i]])
            },
            restore: function (t, e) {
                for (var i, n = 0, s = e.length; n < s; n++) null !== e[n] && (i = t.data(z + e[n]), t.css(e[n], i))
            },
            setMode: function (t, e) {
                return "toggle" === e && (e = t.is(":hidden") ? "show" : "hide"), e
            },
            createWrapper: function (i) {
                if (i.parent().is(".ui-effects-wrapper")) return i.parent();
                var n = {
                    width: i.outerWidth(!0),
                    height: i.outerHeight(!0),
                    float: i.css("float")
                },
                    t = x("<div></div>").addClass("ui-effects-wrapper").css({
                        fontSize: "100%",
                        background: "transparent",
                        border: "none",
                        margin: 0,
                        padding: 0
                    }),
                    e = {
                        width: i.width(),
                        height: i.height()
                    },
                    s = document.activeElement;
                try {
                    s.id
                } catch (t) {
                    s = document.body
                }
                return i.wrap(t), i[0] !== s && !x.contains(i[0], s) || x(s).trigger("focus"), t = i.parent(), "static" === i.css("position") ? (t.css({
                    position: "relative"
                }), i.css({
                    position: "relative"
                })) : (x.extend(n, {
                    position: i.css("position"),
                    zIndex: i.css("z-index")
                }), x.each(["top", "left", "bottom", "right"], function (t, e) {
                    n[e] = i.css(e), isNaN(parseInt(n[e], 10)) && (n[e] = "auto")
                }), i.css({
                    position: "relative",
                    top: 0,
                    left: 0,
                    right: "auto",
                    bottom: "auto"
                })), i.css(e), t.css(n).show()
            },
            removeWrapper: function (t) {
                var e = document.activeElement;
                return t.parent().is(".ui-effects-wrapper") && (t.parent().replaceWith(t), t[0] !== e && !x.contains(t[0], e) || x(e).trigger("focus")), t
            }
        }), x.extend(x.effects, {
            version: "1.12.1",
            define: function (t, e, i) {
                return i || (i = e, e = "effect"), x.effects.effect[t] = i, x.effects.effect[t].mode = e, i
            },
            scaledDimensions: function (t, e, i) {
                if (0 === e) return {
                    height: 0,
                    width: 0,
                    outerHeight: 0,
                    outerWidth: 0
                };
                var n = "horizontal" !== i ? (e || 100) / 100 : 1,
                    s = "vertical" !== i ? (e || 100) / 100 : 1;
                return {
                    height: t.height() * s,
                    width: t.width() * n,
                    outerHeight: t.outerHeight() * s,
                    outerWidth: t.outerWidth() * n
                }
            },
            clipToBox: function (t) {
                return {
                    width: t.clip.right - t.clip.left,
                    height: t.clip.bottom - t.clip.top,
                    left: t.clip.left,
                    top: t.clip.top
                }
            },
            unshift: function (t, e, i) {
                var n = t.queue();
                1 < e && n.splice.apply(n, [1, 0].concat(n.splice(e, i))), t.dequeue()
            },
            saveStyle: function (t) {
                t.data(q, t[0].style.cssText)
            },
            restoreStyle: function (t) {
                t[0].style.cssText = t.data(q) || "", t.removeData(q)
            },
            mode: function (t, e) {
                var i = t.is(":hidden");
                return "toggle" === e && (e = i ? "show" : "hide"), (i ? "hide" === e : "show" === e) && (e = "none"), e
            },
            getBaseline: function (t, e) {
                var i, n;
                switch (t[0]) {
                    case "top":
                        i = 0;
                        break;
                    case "middle":
                        i = .5;
                        break;
                    case "bottom":
                        i = 1;
                        break;
                    default:
                        i = t[0] / e.height
                }
                switch (t[1]) {
                    case "left":
                        n = 0;
                        break;
                    case "center":
                        n = .5;
                        break;
                    case "right":
                        n = 1;
                        break;
                    default:
                        n = t[1] / e.width
                }
                return {
                    x: n,
                    y: i
                }
            },
            createPlaceholder: function (t) {
                var e, i = t.css("position"),
                    n = t.position();
                return t.css({
                    marginTop: t.css("marginTop"),
                    marginBottom: t.css("marginBottom"),
                    marginLeft: t.css("marginLeft"),
                    marginRight: t.css("marginRight")
                }).outerWidth(t.outerWidth()).outerHeight(t.outerHeight()), /^(static|relative)/.test(i) && (i = "absolute", e = x("<" + t[0].nodeName + ">").insertAfter(t).css({
                    display: /^(inline|ruby)/.test(t.css("display")) ? "inline-block" : "block",
                    visibility: "hidden",
                    marginTop: t.css("marginTop"),
                    marginBottom: t.css("marginBottom"),
                    marginLeft: t.css("marginLeft"),
                    marginRight: t.css("marginRight"),
                    float: t.css("float")
                }).outerWidth(t.outerWidth()).outerHeight(t.outerHeight()).addClass("ui-effects-placeholder"), t.data(z + "placeholder", e)), t.css({
                    position: i,
                    left: n.left,
                    top: n.top
                }), e
            },
            removePlaceholder: function (t) {
                var e = z + "placeholder",
                    i = t.data(e);
                i && (i.remove(), t.removeData(e))
            },
            cleanUp: function (t) {
                x.effects.restoreStyle(t), x.effects.removePlaceholder(t)
            },
            setTransition: function (n, t, s, o) {
                return o = o || {}, x.each(t, function (t, e) {
                    var i = n.cssUnit(e);
                    0 < i[0] && (o[e] = i[0] * s + i[1])
                }), o
            }
        }), x.fn.extend({
            effect: function () {
                function t(t) {
                    function e() {
                        x.isFunction(a) && a.call(i[0]), x.isFunction(t) && t()
                    }
                    var i = x(this);
                    n.mode = h.shift(), !1 === x.uiBackCompat || o ? "none" === n.mode ? (i[l](), e()) : s.call(i[0], n, function () {
                        i.removeData(B), x.effects.cleanUp(i), "hide" === n.mode && i.hide(), e()
                    }) : (i.is(":hidden") ? "hide" === l : "show" === l) ? (i[l](), e()) : s.call(i[0], n, e)
                }

                function e(t) {
                    var e = x(this),
                        i = x.effects.mode(e, l) || o;
                    e.data(B, !0), h.push(i), o && ("show" === i || i === o && "hide" === i) && e.show(), o && "none" === i || x.effects.saveStyle(e), x.isFunction(t) && t()
                }
                var n = Y.apply(this, arguments),
                    s = x.effects.effect[n.effect],
                    o = s.mode,
                    i = n.queue,
                    r = i || "fx",
                    a = n.complete,
                    l = n.mode,
                    h = [];
                return x.fx.off || !s ? l ? this[l](n.duration, a) : this.each(function () {
                    a && a.call(this)
                }) : !1 === i ? this.each(e).each(t) : this.queue(r, e).queue(r, t)
            },
            show: (_ = x.fn.show, function (t) {
                if (K(t)) return _.apply(this, arguments);
                var e = Y.apply(this, arguments);
                return e.mode = "show", this.effect.call(this, e)
            }),
            hide: (v = x.fn.hide, function (t) {
                if (K(t)) return v.apply(this, arguments);
                var e = Y.apply(this, arguments);
                return e.mode = "hide", this.effect.call(this, e)
            }),
            toggle: (m = x.fn.toggle, function (t) {
                if (K(t) || "boolean" == typeof t) return m.apply(this, arguments);
                var e = Y.apply(this, arguments);
                return e.mode = "toggle", this.effect.call(this, e)
            }),
            cssUnit: function (t) {
                var i = this.css(t),
                    n = [];
                return x.each(["em", "px", "%", "pt"], function (t, e) {
                    0 < i.indexOf(e) && (n = [parseFloat(i), e])
                }), n
            },
            cssClip: function (t) {
                return t ? this.css("clip", "rect(" + t.top + "px " + t.right + "px " + t.bottom + "px " + t.left + "px)") : V(this.css("clip"), this)
            },
            transfer: function (t, e) {
                var i = x(this),
                    n = x(t.to),
                    s = "fixed" === n.css("position"),
                    o = x("body"),
                    r = s ? o.scrollTop() : 0,
                    a = s ? o.scrollLeft() : 0,
                    l = n.offset(),
                    h = {
                        top: l.top - r,
                        left: l.left - a,
                        height: n.innerHeight(),
                        width: n.innerWidth()
                    },
                    c = i.offset(),
                    u = x("<div class='ui-effects-transfer'></div>").appendTo("body").addClass(t.className).css({
                        top: c.top - r,
                        left: c.left - a,
                        height: i.innerHeight(),
                        width: i.innerWidth(),
                        position: s ? "fixed" : "absolute"
                    }).animate(h, t.duration, t.easing, function () {
                        u.remove(), x.isFunction(e) && e()
                    })
            }
        }), x.fx.step.clip = function (t) {
            t.clipInit || (t.start = x(t.elem).cssClip(), "string" == typeof t.end && (t.end = V(t.end, t.elem)), t.clipInit = !0), x(t.elem).cssClip({
                top: t.pos * (t.end.top - t.start.top) + t.start.top,
                right: t.pos * (t.end.right - t.start.right) + t.start.right,
                bottom: t.pos * (t.end.bottom - t.start.bottom) + t.start.bottom,
                left: t.pos * (t.end.left - t.start.left) + t.start.left
            })
        }, g = {}, x.each(["Quad", "Cubic", "Quart", "Quint", "Expo"], function (e, t) {
            g[t] = function (t) {
                return Math.pow(t, e + 2)
            }
        }), x.extend(g, {
            Sine: function (t) {
                return 1 - Math.cos(t * Math.PI / 2)
            },
            Circ: function (t) {
                return 1 - Math.sqrt(1 - t * t)
            },
            Elastic: function (t) {
                return 0 === t || 1 === t ? t : -Math.pow(2, 8 * (t - 1)) * Math.sin((80 * (t - 1) - 7.5) * Math.PI / 15)
            },
            Back: function (t) {
                return t * t * (3 * t - 2)
            },
            Bounce: function (t) {
                for (var e, i = 4;
                    ((e = Math.pow(2, --i)) - 1) / 11 > t;);
                return 1 / Math.pow(4, 3 - i) - 7.5625 * Math.pow((3 * e - 2) / 22 - t, 2)
            }
        }), x.each(g, function (t, e) {
            x.easing["easeIn" + t] = e, x.easing["easeOut" + t] = function (t) {
                return 1 - e(1 - t)
            }, x.easing["easeInOut" + t] = function (t) {
                return t < .5 ? e(2 * t) / 2 : 1 - e(-2 * t + 2) / 2
            }
        });
        var Z, tt;
        x.effects;
        x.effects.define("blind", "hide", function (t, e) {
            var i = {
                up: ["bottom", "top"],
                vertical: ["bottom", "top"],
                down: ["top", "bottom"],
                left: ["right", "left"],
                horizontal: ["right", "left"],
                right: ["left", "right"]
            },
                n = x(this),
                s = t.direction || "up",
                o = n.cssClip(),
                r = {
                    clip: x.extend({}, o)
                },
                a = x.effects.createPlaceholder(n);
            r.clip[i[s][0]] = r.clip[i[s][1]], "show" === t.mode && (n.cssClip(r.clip), a && a.css(x.effects.clipToBox(r)), r.clip = o), a && a.animate(x.effects.clipToBox(r), t.duration, t.easing), n.animate(r, {
                queue: !1,
                duration: t.duration,
                easing: t.easing,
                complete: e
            })
        }), x.effects.define("bounce", function (t, e) {
            var i, n, s, o = x(this),
                r = t.mode,
                a = "hide" === r,
                l = "show" === r,
                h = t.direction || "up",
                c = t.distance,
                u = t.times || 5,
                d = 2 * u + (l || a ? 1 : 0),
                p = t.duration / d,
                f = t.easing,
                g = "up" === h || "down" === h ? "top" : "left",
                m = "up" === h || "left" === h,
                v = 0,
                _ = o.queue().length;
            for (x.effects.createPlaceholder(o), s = o.css(g), c = c || o["top" == g ? "outerHeight" : "outerWidth"]() / 3, l && ((n = {
                opacity: 1
            })[g] = s, o.css("opacity", 0).css(g, m ? 2 * -c : 2 * c).animate(n, p, f)), a && (c /= Math.pow(2, u - 1)), (n = {})[g] = s; v < u; v++)(i = {})[g] = (m ? "-=" : "+=") + c, o.animate(i, p, f).animate(n, p, f), c = a ? 2 * c : c / 2;
            a && ((i = {
                opacity: 0
            })[g] = (m ? "-=" : "+=") + c, o.animate(i, p, f)), o.queue(e), x.effects.unshift(o, _, 1 + d)
        }), x.effects.define("clip", "hide", function (t, e) {
            var i, n = {},
                s = x(this),
                o = t.direction || "vertical",
                r = "both" === o,
                a = r || "horizontal" === o,
                l = r || "vertical" === o;
            i = s.cssClip(), n.clip = {
                top: l ? (i.bottom - i.top) / 2 : i.top,
                right: a ? (i.right - i.left) / 2 : i.right,
                bottom: l ? (i.bottom - i.top) / 2 : i.bottom,
                left: a ? (i.right - i.left) / 2 : i.left
            }, x.effects.createPlaceholder(s), "show" === t.mode && (s.cssClip(n.clip), n.clip = i), s.animate(n, {
                queue: !1,
                duration: t.duration,
                easing: t.easing,
                complete: e
            })
        }), x.effects.define("drop", "hide", function (t, e) {
            var i, n = x(this),
                s = "show" === t.mode,
                o = t.direction || "left",
                r = "up" === o || "down" === o ? "top" : "left",
                a = "up" === o || "left" === o ? "-=" : "+=",
                l = "+=" == a ? "-=" : "+=",
                h = {
                    opacity: 0
                };
            x.effects.createPlaceholder(n), i = t.distance || n["top" == r ? "outerHeight" : "outerWidth"](!0) / 2, h[r] = a + i, s && (n.css(h), h[r] = l + i, h.opacity = 1), n.animate(h, {
                queue: !1,
                duration: t.duration,
                easing: t.easing,
                complete: e
            })
        }), x.effects.define("explode", "hide", function (t, e) {
            function i() {
                m.push(this), m.length === h * c && (u.css({
                    visibility: "visible"
                }), x(m).remove(), e())
            }
            var n, s, o, r, a, l, h = t.pieces ? Math.round(Math.sqrt(t.pieces)) : 3,
                c = h,
                u = x(this),
                d = "show" === t.mode,
                p = u.show().css("visibility", "hidden").offset(),
                f = Math.ceil(u.outerWidth() / c),
                g = Math.ceil(u.outerHeight() / h),
                m = [];
            for (n = 0; n < h; n++)
                for (r = p.top + n * g, l = n - (h - 1) / 2, s = 0; s < c; s++) o = p.left + s * f, a = s - (c - 1) / 2, u.clone().appendTo("body").wrap("<div></div>").css({
                    position: "absolute",
                    visibility: "visible",
                    left: -s * f,
                    top: -n * g
                }).parent().addClass("ui-effects-explode").css({
                    position: "absolute",
                    overflow: "hidden",
                    width: f,
                    height: g,
                    left: o + (d ? a * f : 0),
                    top: r + (d ? l * g : 0),
                    opacity: d ? 0 : 1
                }).animate({
                    left: o + (d ? 0 : a * f),
                    top: r + (d ? 0 : l * g),
                    opacity: d ? 1 : 0
                }, t.duration || 500, t.easing, i)
        }), x.effects.define("fade", "toggle", function (t, e) {
            var i = "show" === t.mode;
            x(this).css("opacity", i ? 0 : 1).animate({
                opacity: i ? 1 : 0
            }, {
                queue: !1,
                duration: t.duration,
                easing: t.easing,
                complete: e
            })
        }), x.effects.define("fold", "hide", function (e, t) {
            var i = x(this),
                n = e.mode,
                s = "show" === n,
                o = "hide" === n,
                r = e.size || 15,
                a = /([0-9]+)%/.exec(r),
                l = !!e.horizFirst ? ["right", "bottom"] : ["bottom", "right"],
                h = e.duration / 2,
                c = x.effects.createPlaceholder(i),
                u = i.cssClip(),
                d = {
                    clip: x.extend({}, u)
                },
                p = {
                    clip: x.extend({}, u)
                },
                f = [u[l[0]], u[l[1]]],
                g = i.queue().length;
            a && (r = parseInt(a[1], 10) / 100 * f[o ? 0 : 1]), d.clip[l[0]] = r, p.clip[l[0]] = r, p.clip[l[1]] = 0, s && (i.cssClip(p.clip), c && c.css(x.effects.clipToBox(p)), p.clip = u), i.queue(function (t) {
                c && c.animate(x.effects.clipToBox(d), h, e.easing).animate(x.effects.clipToBox(p), h, e.easing), t()
            }).animate(d, h, e.easing).animate(p, h, e.easing).queue(t), x.effects.unshift(i, g, 4)
        }), x.effects.define("highlight", "show", function (t, e) {
            var i = x(this),
                n = {
                    backgroundColor: i.css("backgroundColor")
                };
            "hide" === t.mode && (n.opacity = 0), x.effects.saveStyle(i), i.css({
                backgroundImage: "none",
                backgroundColor: t.color || "#ffff99"
            }).animate(n, {
                queue: !1,
                duration: t.duration,
                easing: t.easing,
                complete: e
            })
        }), x.effects.define("size", function (s, e) {
            var t, o, i, n = x(this),
                r = ["fontSize"],
                a = ["borderTopWidth", "borderBottomWidth", "paddingTop", "paddingBottom"],
                l = ["borderLeftWidth", "borderRightWidth", "paddingLeft", "paddingRight"],
                h = s.mode,
                c = "effect" !== h,
                u = s.scale || "both",
                d = s.origin || ["middle", "center"],
                p = n.css("position"),
                f = n.position(),
                g = x.effects.scaledDimensions(n),
                m = s.from || g,
                v = s.to || x.effects.scaledDimensions(n, 0);
            x.effects.createPlaceholder(n), "show" === h && (i = m, m = v, v = i), o = {
                from: {
                    y: m.height / g.height,
                    x: m.width / g.width
                },
                to: {
                    y: v.height / g.height,
                    x: v.width / g.width
                }
            }, "box" !== u && "both" !== u || (o.from.y !== o.to.y && (m = x.effects.setTransition(n, a, o.from.y, m), v = x.effects.setTransition(n, a, o.to.y, v)), o.from.x !== o.to.x && (m = x.effects.setTransition(n, l, o.from.x, m), v = x.effects.setTransition(n, l, o.to.x, v))), "content" !== u && "both" !== u || o.from.y === o.to.y || (m = x.effects.setTransition(n, r, o.from.y, m), v = x.effects.setTransition(n, r, o.to.y, v)), d && (t = x.effects.getBaseline(d, g), m.top = (g.outerHeight - m.outerHeight) * t.y + f.top, m.left = (g.outerWidth - m.outerWidth) * t.x + f.left, v.top = (g.outerHeight - v.outerHeight) * t.y + f.top, v.left = (g.outerWidth - v.outerWidth) * t.x + f.left), n.css(m), "content" !== u && "both" !== u || (a = a.concat(["marginTop", "marginBottom"]).concat(r), l = l.concat(["marginLeft", "marginRight"]), n.find("*[width]").each(function () {
                var t = x(this),
                    e = x.effects.scaledDimensions(t),
                    i = {
                        height: e.height * o.from.y,
                        width: e.width * o.from.x,
                        outerHeight: e.outerHeight * o.from.y,
                        outerWidth: e.outerWidth * o.from.x
                    },
                    n = {
                        height: e.height * o.to.y,
                        width: e.width * o.to.x,
                        outerHeight: e.height * o.to.y,
                        outerWidth: e.width * o.to.x
                    };
                o.from.y !== o.to.y && (i = x.effects.setTransition(t, a, o.from.y, i), n = x.effects.setTransition(t, a, o.to.y, n)), o.from.x !== o.to.x && (i = x.effects.setTransition(t, l, o.from.x, i), n = x.effects.setTransition(t, l, o.to.x, n)), c && x.effects.saveStyle(t), t.css(i), t.animate(n, s.duration, s.easing, function () {
                    c && x.effects.restoreStyle(t)
                })
            })), n.animate(v, {
                queue: !1,
                duration: s.duration,
                easing: s.easing,
                complete: function () {
                    var t = n.offset();
                    0 === v.opacity && n.css("opacity", m.opacity), c || (n.css("position", "static" === p ? "relative" : p).offset(t), x.effects.saveStyle(n)), e()
                }
            })
        }), x.effects.define("scale", function (t, e) {
            var i = x(this),
                n = t.mode,
                s = parseInt(t.percent, 10) || (0 === parseInt(t.percent, 10) || "effect" !== n ? 0 : 100),
                o = x.extend(!0, {
                    from: x.effects.scaledDimensions(i),
                    to: x.effects.scaledDimensions(i, s, t.direction || "both"),
                    origin: t.origin || ["middle", "center"]
                }, t);
            t.fade && (o.from.opacity = 1, o.to.opacity = 0), x.effects.effect.size.call(this, o, e)
        }), x.effects.define("puff", "hide", function (t, e) {
            var i = x.extend(!0, {}, t, {
                fade: !0,
                percent: parseInt(t.percent, 10) || 150
            });
            x.effects.effect.scale.call(this, i, e)
        }), x.effects.define("pulsate", "show", function (t, e) {
            var i = x(this),
                n = t.mode,
                s = "show" === n,
                o = s || "hide" === n,
                r = 2 * (t.times || 5) + (o ? 1 : 0),
                a = t.duration / r,
                l = 0,
                h = 1,
                c = i.queue().length;
            for (!s && i.is(":visible") || (i.css("opacity", 0).show(), l = 1); h < r; h++) i.animate({
                opacity: l
            }, a, t.easing), l = 1 - l;
            i.animate({
                opacity: l
            }, a, t.easing), i.queue(e), x.effects.unshift(i, c, 1 + r)
        }), x.effects.define("shake", function (t, e) {
            var i = 1,
                n = x(this),
                s = t.direction || "left",
                o = t.distance || 20,
                r = t.times || 3,
                a = 2 * r + 1,
                l = Math.round(t.duration / a),
                h = "up" === s || "down" === s ? "top" : "left",
                c = "up" === s || "left" === s,
                u = {},
                d = {},
                p = {},
                f = n.queue().length;
            for (x.effects.createPlaceholder(n), u[h] = (c ? "-=" : "+=") + o, d[h] = (c ? "+=" : "-=") + 2 * o, p[h] = (c ? "-=" : "+=") + 2 * o, n.animate(u, l, t.easing); i < r; i++) n.animate(d, l, t.easing).animate(p, l, t.easing);
            n.animate(d, l, t.easing).animate(u, l / 2, t.easing).queue(e), x.effects.unshift(n, f, 1 + a)
        }), x.effects.define("slide", "show", function (t, e) {
            var i, n, s = x(this),
                o = {
                    up: ["bottom", "top"],
                    down: ["top", "bottom"],
                    left: ["right", "left"],
                    right: ["left", "right"]
                },
                r = t.mode,
                a = t.direction || "left",
                l = "up" === a || "down" === a ? "top" : "left",
                h = "up" === a || "left" === a,
                c = t.distance || s["top" == l ? "outerHeight" : "outerWidth"](!0),
                u = {};
            x.effects.createPlaceholder(s), i = s.cssClip(), n = s.position()[l], u[l] = (h ? -1 : 1) * c + n, u.clip = s.cssClip(), u.clip[o[a][1]] = u.clip[o[a][0]], "show" === r && (s.cssClip(u.clip), s.css(l, u[l]), u.clip = i, u[l] = n), s.animate(u, {
                queue: !1,
                duration: t.duration,
                easing: t.easing,
                complete: e
            })
        }), !1 !== x.uiBackCompat && x.effects.define("transfer", function (t, e) {
            x(this).transfer(t, e)
        }), x.ui.focusable = function (t, e) {
            var i, n, s, o, r, a = t.nodeName.toLowerCase();
            return "area" === a ? (n = (i = t.parentNode).name, !(!t.href || !n || "map" !== i.nodeName.toLowerCase()) && (0 < (s = x("img[usemap='#" + n + "']")).length && s.is(":visible"))) : (/^(input|select|textarea|button|object)$/.test(a) ? (o = !t.disabled) && ((r = x(t).closest("fieldset")[0]) && (o = !r.disabled)) : o = "a" === a && t.href || e, o && x(t).is(":visible") && function (t) {
                for (var e = t.css("visibility");
                    "inherit" === e;) e = (t = t.parent()).css("visibility");
                return "hidden" !== e
            }(x(t)))
        }, x.extend(x.expr[":"], {
            focusable: function (t) {
                return x.ui.focusable(t, null != x.attr(t, "tabindex"))
            }
        }), x.ui.focusable, x.fn.form = function () {
            return "string" == typeof this[0].form ? this.closest("form") : x(this[0].form)
        }, x.ui.formResetMixin = {
            _formResetHandler: function () {
                var e = x(this);
                setTimeout(function () {
                    var t = e.data("ui-form-reset-instances");
                    x.each(t, function () {
                        this.refresh()
                    })
                })
            },
            _bindFormResetHandler: function () {
                if (this.form = this.element.form(), this.form.length) {
                    var t = this.form.data("ui-form-reset-instances") || [];
                    t.length || this.form.on("reset.ui-form-reset", this._formResetHandler), t.push(this), this.form.data("ui-form-reset-instances", t)
                }
            },
            _unbindFormResetHandler: function () {
                if (this.form.length) {
                    var t = this.form.data("ui-form-reset-instances");
                    t.splice(x.inArray(this, t), 1), t.length ? this.form.data("ui-form-reset-instances", t) : this.form.removeData("ui-form-reset-instances").off("reset.ui-form-reset")
                }
            }
        }, "1.7" === x.fn.jquery.substring(0, 3) && (x.each(["Width", "Height"], function (t, i) {
            function n(t, e, i, n) {
                return x.each(s, function () {
                    e -= parseFloat(x.css(t, "padding" + this)) || 0, i && (e -= parseFloat(x.css(t, "border" + this + "Width")) || 0), n && (e -= parseFloat(x.css(t, "margin" + this)) || 0)
                }), e
            }
            var s = "Width" === i ? ["Left", "Right"] : ["Top", "Bottom"],
                o = i.toLowerCase(),
                r = {
                    innerWidth: x.fn.innerWidth,
                    innerHeight: x.fn.innerHeight,
                    outerWidth: x.fn.outerWidth,
                    outerHeight: x.fn.outerHeight
                };
            x.fn["inner" + i] = function (t) {
                return void 0 === t ? r["inner" + i].call(this) : this.each(function () {
                    x(this).css(o, n(this, t) + "px")
                })
            }, x.fn["outer" + i] = function (t, e) {
                return "number" != typeof t ? r["outer" + i].call(this, t) : this.each(function () {
                    x(this).css(o, n(this, t, !0, e) + "px")
                })
            }
        }), x.fn.addBack = function (t) {
            return this.add(null == t ? this.prevObject : this.prevObject.filter(t))
        }), x.ui.keyCode = {
            BACKSPACE: 8,
            COMMA: 188,
            DELETE: 46,
            DOWN: 40,
            END: 35,
            ENTER: 13,
            ESCAPE: 27,
            HOME: 36,
            LEFT: 37,
            PAGE_DOWN: 34,
            PAGE_UP: 33,
            PERIOD: 190,
            RIGHT: 39,
            SPACE: 32,
            TAB: 9,
            UP: 38
        }, x.ui.escapeSelector = (tt = /([!"#$%&'()*+,.\/:;<=>?@[\]^`{|}~])/g, function (t) {
            return t.replace(tt, "\\$1")
        }), x.fn.labels = function () {
            var t, e, i, n, s;
            return this[0].labels && this[0].labels.length ? this.pushStack(this[0].labels) : (n = this.eq(0).parents("label"), (i = this.attr("id")) && (s = (t = this.eq(0).parents().last()).add(t.length ? t.siblings() : this.siblings()), e = "label[for='" + x.ui.escapeSelector(i) + "']", n = n.add(s.find(e).addBack(e))), this.pushStack(n))
        }, x.fn.scrollParent = function (t) {
            var e = this.css("position"),
                i = "absolute" === e,
                n = t ? /(auto|scroll|hidden)/ : /(auto|scroll)/,
                s = this.parents().filter(function () {
                    var t = x(this);
                    return (!i || "static" !== t.css("position")) && n.test(t.css("overflow") + t.css("overflow-y") + t.css("overflow-x"))
                }).eq(0);
            return "fixed" !== e && s.length ? s : x(this[0].ownerDocument || document)
        }, x.extend(x.expr[":"], {
            tabbable: function (t) {
                var e = x.attr(t, "tabindex"),
                    i = null != e;
                return (!i || 0 <= e) && x.ui.focusable(t, i)
            }
        }), x.fn.extend({
            uniqueId: (Z = 0, function () {
                return this.each(function () {
                    this.id || (this.id = "ui-id-" + ++Z)
                })
            }),
            removeUniqueId: function () {
                return this.each(function () {
                    /^ui-id-\d+$/.test(this.id) && x(this).removeAttr("id")
                })
            }
        }), x.widget("ui.accordion", {
            version: "1.12.1",
            options: {
                active: 0,
                animate: {},
                classes: {
                    "ui-accordion-header": "ui-corner-top",
                    "ui-accordion-header-collapsed": "ui-corner-all",
                    "ui-accordion-content": "ui-corner-bottom"
                },
                collapsible: !1,
                event: "click",
                header: "> li > :first-child, > :not(li):even",
                heightStyle: "auto",
                icons: {
                    activeHeader: "ui-icon-triangle-1-s",
                    header: "ui-icon-triangle-1-e"
                },
                activate: null,
                beforeActivate: null
            },
            hideProps: {
                borderTopWidth: "hide",
                borderBottomWidth: "hide",
                paddingTop: "hide",
                paddingBottom: "hide",
                height: "hide"
            },
            showProps: {
                borderTopWidth: "show",
                borderBottomWidth: "show",
                paddingTop: "show",
                paddingBottom: "show",
                height: "show"
            },
            _create: function () {
                var t = this.options;
                this.prevShow = this.prevHide = x(), this._addClass("ui-accordion", "ui-widget ui-helper-reset"), this.element.attr("role", "tablist"), t.collapsible || !1 !== t.active && null != t.active || (t.active = 0), this._processPanels(), t.active < 0 && (t.active += this.headers.length), this._refresh()
            },
            _getCreateEventData: function () {
                return {
                    header: this.active,
                    panel: this.active.length ? this.active.next() : x()
                }
            },
            _createIcons: function () {
                var t, e, i = this.options.icons;
                i && (t = x("<span>"), this._addClass(t, "ui-accordion-header-icon", "ui-icon " + i.header), t.prependTo(this.headers), e = this.active.children(".ui-accordion-header-icon"), this._removeClass(e, i.header)._addClass(e, null, i.activeHeader)._addClass(this.headers, "ui-accordion-icons"))
            },
            _destroyIcons: function () {
                this._removeClass(this.headers, "ui-accordion-icons"), this.headers.children(".ui-accordion-header-icon").remove()
            },
            _destroy: function () {
                var t;
                this.element.removeAttr("role"), this.headers.removeAttr("role aria-expanded aria-selected aria-controls tabIndex").removeUniqueId(), this._destroyIcons(), t = this.headers.next().css("display", "").removeAttr("role aria-hidden aria-labelledby").removeUniqueId(), "content" !== this.options.heightStyle && t.css("height", "")
            },
            _setOption: function (t, e) {
                return "active" === t ? void this._activate(e) : ("event" === t && (this.options.event && this._off(this.headers, this.options.event), this._setupEvents(e)), this._super(t, e), "collapsible" !== t || e || !1 !== this.options.active || this._activate(0), void ("icons" === t && (this._destroyIcons(), e && this._createIcons())))
            },
            _setOptionDisabled: function (t) {
                this._super(t), this.element.attr("aria-disabled", t), this._toggleClass(null, "ui-state-disabled", !!t), this._toggleClass(this.headers.add(this.headers.next()), null, "ui-state-disabled", !!t)
            },
            _keydown: function (t) {
                if (!t.altKey && !t.ctrlKey) {
                    var e = x.ui.keyCode,
                        i = this.headers.length,
                        n = this.headers.index(t.target),
                        s = !1;
                    switch (t.keyCode) {
                        case e.RIGHT:
                        case e.DOWN:
                            s = this.headers[(n + 1) % i];
                            break;
                        case e.LEFT:
                        case e.UP:
                            s = this.headers[(n - 1 + i) % i];
                            break;
                        case e.SPACE:
                        case e.ENTER:
                            this._eventHandler(t);
                            break;
                        case e.HOME:
                            s = this.headers[0];
                            break;
                        case e.END:
                            s = this.headers[i - 1]
                    }
                    s && (x(t.target).attr("tabIndex", -1), x(s).attr("tabIndex", 0), x(s).trigger("focus"), t.preventDefault())
                }
            },
            _panelKeyDown: function (t) {
                t.keyCode === x.ui.keyCode.UP && t.ctrlKey && x(t.currentTarget).prev().trigger("focus")
            },
            refresh: function () {
                var t = this.options;
                this._processPanels(), !1 === t.active && !0 === t.collapsible || !this.headers.length ? (t.active = !1, this.active = x()) : !1 === t.active ? this._activate(0) : this.active.length && !x.contains(this.element[0], this.active[0]) ? this.headers.length === this.headers.find(".ui-state-disabled").length ? (t.active = !1, this.active = x()) : this._activate(Math.max(0, t.active - 1)) : t.active = this.headers.index(this.active), this._destroyIcons(), this._refresh()
            },
            _processPanels: function () {
                var t = this.headers,
                    e = this.panels;
                this.headers = this.element.find(this.options.header), this._addClass(this.headers, "ui-accordion-header ui-accordion-header-collapsed", "ui-state-default"), this.panels = this.headers.next().filter(":not(.ui-accordion-content-active)").hide(), this._addClass(this.panels, "ui-accordion-content", "ui-helper-reset ui-widget-content"), e && (this._off(t.not(this.headers)), this._off(e.not(this.panels)))
            },
            _refresh: function () {
                var i, t = this.options,
                    e = t.heightStyle,
                    n = this.element.parent();
                this.active = this._findActive(t.active), this._addClass(this.active, "ui-accordion-header-active", "ui-state-active")._removeClass(this.active, "ui-accordion-header-collapsed"), this._addClass(this.active.next(), "ui-accordion-content-active"), this.active.next().show(), this.headers.attr("role", "tab").each(function () {
                    var t = x(this),
                        e = t.uniqueId().attr("id"),
                        i = t.next(),
                        n = i.uniqueId().attr("id");
                    t.attr("aria-controls", n), i.attr("aria-labelledby", e)
                }).next().attr("role", "tabpanel"), this.headers.not(this.active).attr({
                    "aria-selected": "false",
                    "aria-expanded": "false",
                    tabIndex: -1
                }).next().attr({
                    "aria-hidden": "true"
                }).hide(), this.active.length ? this.active.attr({
                    "aria-selected": "true",
                    "aria-expanded": "true",
                    tabIndex: 0
                }).next().attr({
                    "aria-hidden": "false"
                }) : this.headers.eq(0).attr("tabIndex", 0), this._createIcons(), this._setupEvents(t.event), "fill" === e ? (i = n.height(), this.element.siblings(":visible").each(function () {
                    var t = x(this),
                        e = t.css("position");
                    "absolute" !== e && "fixed" !== e && (i -= t.outerHeight(!0))
                }), this.headers.each(function () {
                    i -= x(this).outerHeight(!0)
                }), this.headers.next().each(function () {
                    x(this).height(Math.max(0, i - x(this).innerHeight() + x(this).height()))
                }).css("overflow", "auto")) : "auto" === e && (i = 0, this.headers.next().each(function () {
                    var t = x(this).is(":visible");
                    t || x(this).show(), i = Math.max(i, x(this).css("height", "").height()), t || x(this).hide()
                }).height(i))
            },
            _activate: function (t) {
                var e = this._findActive(t)[0];
                e !== this.active[0] && (e = e || this.active[0], this._eventHandler({
                    target: e,
                    currentTarget: e,
                    preventDefault: x.noop
                }))
            },
            _findActive: function (t) {
                return "number" == typeof t ? this.headers.eq(t) : x()
            },
            _setupEvents: function (t) {
                var i = {
                    keydown: "_keydown"
                };
                t && x.each(t.split(" "), function (t, e) {
                    i[e] = "_eventHandler"
                }), this._off(this.headers.add(this.headers.next())), this._on(this.headers, i), this._on(this.headers.next(), {
                    keydown: "_panelKeyDown"
                }), this._hoverable(this.headers), this._focusable(this.headers)
            },
            _eventHandler: function (t) {
                var e, i, n = this.options,
                    s = this.active,
                    o = x(t.currentTarget),
                    r = o[0] === s[0],
                    a = r && n.collapsible,
                    l = a ? x() : o.next(),
                    h = s.next(),
                    c = {
                        oldHeader: s,
                        oldPanel: h,
                        newHeader: a ? x() : o,
                        newPanel: l
                    };
                t.preventDefault(), r && !n.collapsible || !1 === this._trigger("beforeActivate", t, c) || (n.active = !a && this.headers.index(o), this.active = r ? x() : o, this._toggle(c), this._removeClass(s, "ui-accordion-header-active", "ui-state-active"), n.icons && (e = s.children(".ui-accordion-header-icon"), this._removeClass(e, null, n.icons.activeHeader)._addClass(e, null, n.icons.header)), r || (this._removeClass(o, "ui-accordion-header-collapsed")._addClass(o, "ui-accordion-header-active", "ui-state-active"), n.icons && (i = o.children(".ui-accordion-header-icon"), this._removeClass(i, null, n.icons.header)._addClass(i, null, n.icons.activeHeader)), this._addClass(o.next(), "ui-accordion-content-active")))
            },
            _toggle: function (t) {
                var e = t.newPanel,
                    i = this.prevShow.length ? this.prevShow : t.oldPanel;
                this.prevShow.add(this.prevHide).stop(!0, !0), this.prevShow = e, this.prevHide = i, this.options.animate ? this._animate(e, i, t) : (i.hide(), e.show(), this._toggleComplete(t)), i.attr({
                    "aria-hidden": "true"
                }), i.prev().attr({
                    "aria-selected": "false",
                    "aria-expanded": "false"
                }), e.length && i.length ? i.prev().attr({
                    tabIndex: -1,
                    "aria-expanded": "false"
                }) : e.length && this.headers.filter(function () {
                    return 0 === parseInt(x(this).attr("tabIndex"), 10)
                }).attr("tabIndex", -1), e.attr("aria-hidden", "false").prev().attr({
                    "aria-selected": "true",
                    "aria-expanded": "true",
                    tabIndex: 0
                })
            },
            _animate: function (t, i, e) {
                function n() {
                    a._toggleComplete(e)
                }
                var s, o, r, a = this,
                    l = 0,
                    h = t.css("box-sizing"),
                    c = t.length && (!i.length || t.index() < i.index()),
                    u = this.options.animate || {},
                    d = c && u.down || u;
                return "number" == typeof d && (r = d), "string" == typeof d && (o = d), o = o || d.easing || u.easing, r = r || d.duration || u.duration, i.length ? t.length ? (s = t.show().outerHeight(), i.animate(this.hideProps, {
                    duration: r,
                    easing: o,
                    step: function (t, e) {
                        e.now = Math.round(t)
                    }
                }), void t.hide().animate(this.showProps, {
                    duration: r,
                    easing: o,
                    complete: n,
                    step: function (t, e) {
                        e.now = Math.round(t), "height" !== e.prop ? "content-box" === h && (l += e.now) : "content" !== a.options.heightStyle && (e.now = Math.round(s - i.outerHeight() - l), l = 0)
                    }
                })) : i.animate(this.hideProps, r, o, n) : t.animate(this.showProps, r, o, n)
            },
            _toggleComplete: function (t) {
                var e = t.oldPanel,
                    i = e.prev();
                this._removeClass(e, "ui-accordion-content-active"), this._removeClass(i, "ui-accordion-header-active")._addClass(i, "ui-accordion-header-collapsed"), e.length && (e.parent()[0].className = e.parent()[0].className), this._trigger("activate", null, t)
            }
        }), x.ui.safeActiveElement = function (e) {
            var i;
            try {
                i = e.activeElement
            } catch (t) {
                i = e.body
            }
            return (i = i || e.body).nodeName || (i = e.body), i
        }, x.widget("ui.menu", {
            version: "1.12.1",
            defaultElement: "<ul>",
            delay: 300,
            options: {
                icons: {
                    submenu: "ui-icon-caret-1-e"
                },
                items: "> *",
                menus: "ul",
                position: {
                    my: "left top",
                    at: "right top"
                },
                role: "menu",
                blur: null,
                focus: null,
                select: null
            },
            _create: function () {
                this.activeMenu = this.element, this.mouseHandled = !1, this.element.uniqueId().attr({
                    role: this.options.role,
                    tabIndex: 0
                }), this._addClass("ui-menu", "ui-widget ui-widget-content"), this._on({
                    "mousedown .ui-menu-item": function (t) {
                        t.preventDefault()
                    },
                    "click .ui-menu-item": function (t) {
                        var e = x(t.target),
                            i = x(x.ui.safeActiveElement(this.document[0]));
                        !this.mouseHandled && e.not(".ui-state-disabled").length && (this.select(t), t.isPropagationStopped() || (this.mouseHandled = !0), e.has(".ui-menu").length ? this.expand(t) : !this.element.is(":focus") && i.closest(".ui-menu").length && (this.element.trigger("focus", [!0]), this.active && 1 === this.active.parents(".ui-menu").length && clearTimeout(this.timer)))
                    },
                    "mouseenter .ui-menu-item": function (t) {
                        if (!this.previousFilter) {
                            var e = x(t.target).closest(".ui-menu-item"),
                                i = x(t.currentTarget);
                            e[0] === i[0] && (this._removeClass(i.siblings().children(".ui-state-active"), null, "ui-state-active"), this.focus(t, i))
                        }
                    },
                    mouseleave: "collapseAll",
                    "mouseleave .ui-menu": "collapseAll",
                    focus: function (t, e) {
                        var i = this.active || this.element.find(this.options.items).eq(0);
                        e || this.focus(t, i)
                    },
                    blur: function (t) {
                        this._delay(function () {
                            x.contains(this.element[0], x.ui.safeActiveElement(this.document[0])) || this.collapseAll(t)
                        })
                    },
                    keydown: "_keydown"
                }), this.refresh(), this._on(this.document, {
                    click: function (t) {
                        this._closeOnDocumentClick(t) && this.collapseAll(t), this.mouseHandled = !1
                    }
                })
            },
            _destroy: function () {
                var t = this.element.find(".ui-menu-item").removeAttr("role aria-disabled").children(".ui-menu-item-wrapper").removeUniqueId().removeAttr("tabIndex role aria-haspopup");
                this.element.removeAttr("aria-activedescendant").find(".ui-menu").addBack().removeAttr("role aria-labelledby aria-expanded aria-hidden aria-disabled tabIndex").removeUniqueId().show(), t.children().each(function () {
                    var t = x(this);
                    t.data("ui-menu-submenu-caret") && t.remove()
                })
            },
            _keydown: function (t) {
                var e, i, n, s, o = !0;
                switch (t.keyCode) {
                    case x.ui.keyCode.PAGE_UP:
                        this.previousPage(t);
                        break;
                    case x.ui.keyCode.PAGE_DOWN:
                        this.nextPage(t);
                        break;
                    case x.ui.keyCode.HOME:
                        this._move("first", "first", t);
                        break;
                    case x.ui.keyCode.END:
                        this._move("last", "last", t);
                        break;
                    case x.ui.keyCode.UP:
                        this.previous(t);
                        break;
                    case x.ui.keyCode.DOWN:
                        this.next(t);
                        break;
                    case x.ui.keyCode.LEFT:
                        this.collapse(t);
                        break;
                    case x.ui.keyCode.RIGHT:
                        this.active && !this.active.is(".ui-state-disabled") && this.expand(t);
                        break;
                    case x.ui.keyCode.ENTER:
                    case x.ui.keyCode.SPACE:
                        this._activate(t);
                        break;
                    case x.ui.keyCode.ESCAPE:
                        this.collapse(t);
                        break;
                    default:
                        o = !1, i = this.previousFilter || "", s = !1, n = 96 <= t.keyCode && t.keyCode <= 105 ? "" + (t.keyCode - 96) : String.fromCharCode(t.keyCode), clearTimeout(this.filterTimer), n === i ? s = !0 : n = i + n, e = this._filterMenuItems(n), (e = s && -1 !== e.index(this.active.next()) ? this.active.nextAll(".ui-menu-item") : e).length || (n = String.fromCharCode(t.keyCode), e = this._filterMenuItems(n)), e.length ? (this.focus(t, e), this.previousFilter = n, this.filterTimer = this._delay(function () {
                            delete this.previousFilter
                        }, 1e3)) : delete this.previousFilter
                }
                o && t.preventDefault()
            },
            _activate: function (t) {
                this.active && !this.active.is(".ui-state-disabled") && (this.active.children("[aria-haspopup='true']").length ? this.expand(t) : this.select(t))
            },
            refresh: function () {
                var t, e, i, n, s = this,
                    o = this.options.icons.submenu,
                    r = this.element.find(this.options.menus);
                this._toggleClass("ui-menu-icons", null, !!this.element.find(".ui-icon").length), e = r.filter(":not(.ui-menu)").hide().attr({
                    role: this.options.role,
                    "aria-hidden": "true",
                    "aria-expanded": "false"
                }).each(function () {
                    var t = x(this),
                        e = t.prev(),
                        i = x("<span>").data("ui-menu-submenu-caret", !0);
                    s._addClass(i, "ui-menu-icon", "ui-icon " + o), e.attr("aria-haspopup", "true").prepend(i), t.attr("aria-labelledby", e.attr("id"))
                }), this._addClass(e, "ui-menu", "ui-widget ui-widget-content ui-front"), (t = r.add(this.element).find(this.options.items)).not(".ui-menu-item").each(function () {
                    var t = x(this);
                    s._isDivider(t) && s._addClass(t, "ui-menu-divider", "ui-widget-content")
                }), n = (i = t.not(".ui-menu-item, .ui-menu-divider")).children().not(".ui-menu").uniqueId().attr({
                    tabIndex: -1,
                    role: this._itemRole()
                }), this._addClass(i, "ui-menu-item")._addClass(n, "ui-menu-item-wrapper"), t.filter(".ui-state-disabled").attr("aria-disabled", "true"), this.active && !x.contains(this.element[0], this.active[0]) && this.blur()
            },
            _itemRole: function () {
                return {
                    menu: "menuitem",
                    listbox: "option"
                }[this.options.role]
            },
            _setOption: function (t, e) {
                if ("icons" === t) {
                    var i = this.element.find(".ui-menu-icon");
                    this._removeClass(i, null, this.options.icons.submenu)._addClass(i, null, e.submenu)
                }
                this._super(t, e)
            },
            _setOptionDisabled: function (t) {
                this._super(t), this.element.attr("aria-disabled", t + ""), this._toggleClass(null, "ui-state-disabled", !!t)
            },
            focus: function (t, e) {
                var i, n, s;
                this.blur(t, t && "focus" === t.type), this._scrollIntoView(e), this.active = e.first(), n = this.active.children(".ui-menu-item-wrapper"), this._addClass(n, null, "ui-state-active"), this.options.role && this.element.attr("aria-activedescendant", n.attr("id")), s = this.active.parent().closest(".ui-menu-item").children(".ui-menu-item-wrapper"), this._addClass(s, null, "ui-state-active"), t && "keydown" === t.type ? this._close() : this.timer = this._delay(function () {
                    this._close()
                }, this.delay), (i = e.children(".ui-menu")).length && t && /^mouse/.test(t.type) && this._startOpening(i), this.activeMenu = e.parent(), this._trigger("focus", t, {
                    item: e
                })
            },
            _scrollIntoView: function (t) {
                var e, i, n, s, o, r;
                this._hasScroll() && (e = parseFloat(x.css(this.activeMenu[0], "borderTopWidth")) || 0, i = parseFloat(x.css(this.activeMenu[0], "paddingTop")) || 0, n = t.offset().top - this.activeMenu.offset().top - e - i, s = this.activeMenu.scrollTop(), o = this.activeMenu.height(), r = t.outerHeight(), n < 0 ? this.activeMenu.scrollTop(s + n) : o < n + r && this.activeMenu.scrollTop(s + n - o + r))
            },
            blur: function (t, e) {
                e || clearTimeout(this.timer), this.active && (this._removeClass(this.active.children(".ui-menu-item-wrapper"), null, "ui-state-active"), this._trigger("blur", t, {
                    item: this.active
                }), this.active = null)
            },
            _startOpening: function (t) {
                clearTimeout(this.timer), "true" === t.attr("aria-hidden") && (this.timer = this._delay(function () {
                    this._close(), this._open(t)
                }, this.delay))
            },
            _open: function (t) {
                var e = x.extend({
                    of: this.active
                }, this.options.position);
                clearTimeout(this.timer), this.element.find(".ui-menu").not(t.parents(".ui-menu")).hide().attr("aria-hidden", "true"), t.show().removeAttr("aria-hidden").attr("aria-expanded", "true").position(e)
            },
            collapseAll: function (e, i) {
                clearTimeout(this.timer), this.timer = this._delay(function () {
                    var t = i ? this.element : x(e && e.target).closest(this.element.find(".ui-menu"));
                    t.length || (t = this.element), this._close(t), this.blur(e), this._removeClass(t.find(".ui-state-active"), null, "ui-state-active"), this.activeMenu = t
                }, this.delay)
            },
            _close: function (t) {
                (t = t || (this.active ? this.active.parent() : this.element)).find(".ui-menu").hide().attr("aria-hidden", "true").attr("aria-expanded", "false")
            },
            _closeOnDocumentClick: function (t) {
                return !x(t.target).closest(".ui-menu").length
            },
            _isDivider: function (t) {
                return !/[^\-\u2014\u2013\s]/.test(t.text())
            },
            collapse: function (t) {
                var e = this.active && this.active.parent().closest(".ui-menu-item", this.element);
                e && e.length && (this._close(), this.focus(t, e))
            },
            expand: function (t) {
                var e = this.active && this.active.children(".ui-menu ").find(this.options.items).first();
                e && e.length && (this._open(e.parent()), this._delay(function () {
                    this.focus(t, e)
                }))
            },
            next: function (t) {
                this._move("next", "first", t)
            },
            previous: function (t) {
                this._move("prev", "last", t)
            },
            isFirstItem: function () {
                return this.active && !this.active.prevAll(".ui-menu-item").length
            },
            isLastItem: function () {
                return this.active && !this.active.nextAll(".ui-menu-item").length
            },
            _move: function (t, e, i) {
                var n;
                this.active && (n = "first" === t || "last" === t ? this.active["first" === t ? "prevAll" : "nextAll"](".ui-menu-item").eq(-1) : this.active[t + "All"](".ui-menu-item").eq(0)), n && n.length && this.active || (n = this.activeMenu.find(this.options.items)[e]()), this.focus(i, n)
            },
            nextPage: function (t) {
                var e, i, n;
                return this.active ? void (this.isLastItem() || (this._hasScroll() ? (i = this.active.offset().top, n = this.element.height(), this.active.nextAll(".ui-menu-item").each(function () {
                    return (e = x(this)).offset().top - i - n < 0
                }), this.focus(t, e)) : this.focus(t, this.activeMenu.find(this.options.items)[this.active ? "last" : "first"]()))) : void this.next(t)
            },
            previousPage: function (t) {
                var e, i, n;
                return this.active ? void (this.isFirstItem() || (this._hasScroll() ? (i = this.active.offset().top, n = this.element.height(), this.active.prevAll(".ui-menu-item").each(function () {
                    return 0 < (e = x(this)).offset().top - i + n
                }), this.focus(t, e)) : this.focus(t, this.activeMenu.find(this.options.items).first()))) : void this.next(t)
            },
            _hasScroll: function () {
                return this.element.outerHeight() < this.element.prop("scrollHeight")
            },
            select: function (t) {
                this.active = this.active || x(t.target).closest(".ui-menu-item");
                var e = {
                    item: this.active
                };
                this.active.has(".ui-menu").length || this.collapseAll(t, !0), this._trigger("select", t, e)
            },
            _filterMenuItems: function (t) {
                var e = t.replace(/[\-\[\]{}()*+?.,\\\^$|#\s]/g, "\\$&"),
                    i = RegExp("^" + e, "i");
                return this.activeMenu.find(this.options.items).filter(".ui-menu-item").filter(function () {
                    return i.test(x.trim(x(this).children(".ui-menu-item-wrapper").text()))
                })
            }
        }), x.widget("ui.autocomplete", {
            version: "1.12.1",
            defaultElement: "<input>",
            options: {
                appendTo: null,
                autoFocus: !1,
                delay: 300,
                minLength: 1,
                position: {
                    my: "left top",
                    at: "left bottom",
                    collision: "none"
                },
                source: null,
                change: null,
                close: null,
                focus: null,
                open: null,
                response: null,
                search: null,
                select: null
            },
            requestIndex: 0,
            pending: 0,
            _create: function () {
                var i, n, s, t = this.element[0].nodeName.toLowerCase(),
                    e = "textarea" === t,
                    o = "input" === t;
                this.isMultiLine = e || !o && this._isContentEditable(this.element), this.valueMethod = this.element[e || o ? "val" : "text"], this.isNewMenu = !0, this._addClass("ui-autocomplete-input"), this.element.attr("autocomplete", "off"), this._on(this.element, {
                    keydown: function (t) {
                        if (this.element.prop("readOnly")) n = s = i = !0;
                        else {
                            n = s = i = !1;
                            var e = x.ui.keyCode;
                            switch (t.keyCode) {
                                case e.PAGE_UP:
                                    i = !0, this._move("previousPage", t);
                                    break;
                                case e.PAGE_DOWN:
                                    i = !0, this._move("nextPage", t);
                                    break;
                                case e.UP:
                                    i = !0, this._keyEvent("previous", t);
                                    break;
                                case e.DOWN:
                                    i = !0, this._keyEvent("next", t);
                                    break;
                                case e.ENTER:
                                    this.menu.active && (i = !0, t.preventDefault(), this.menu.select(t));
                                    break;
                                case e.TAB:
                                    this.menu.active && this.menu.select(t);
                                    break;
                                case e.ESCAPE:
                                    this.menu.element.is(":visible") && (this.isMultiLine || this._value(this.term), this.close(t), t.preventDefault());
                                    break;
                                default:
                                    n = !0, this._searchTimeout(t)
                            }
                        }
                    },
                    keypress: function (t) {
                        if (i) return i = !1, void (this.isMultiLine && !this.menu.element.is(":visible") || t.preventDefault());
                        if (!n) {
                            var e = x.ui.keyCode;
                            switch (t.keyCode) {
                                case e.PAGE_UP:
                                    this._move("previousPage", t);
                                    break;
                                case e.PAGE_DOWN:
                                    this._move("nextPage", t);
                                    break;
                                case e.UP:
                                    this._keyEvent("previous", t);
                                    break;
                                case e.DOWN:
                                    this._keyEvent("next", t)
                            }
                        }
                    },
                    input: function (t) {
                        return s ? (s = !1, void t.preventDefault()) : void this._searchTimeout(t)
                    },
                    focus: function () {
                        this.selectedItem = null, this.previous = this._value()
                    },
                    blur: function (t) {
                        return this.cancelBlur ? void delete this.cancelBlur : (clearTimeout(this.searching), this.close(t), void this._change(t))
                    }
                }), this._initSource(), this.menu = x("<ul>").appendTo(this._appendTo()).menu({
                    role: null
                }).hide().menu("instance"), this._addClass(this.menu.element, "ui-autocomplete", "ui-front"), this._on(this.menu.element, {
                    mousedown: function (t) {
                        t.preventDefault(), this.cancelBlur = !0, this._delay(function () {
                            delete this.cancelBlur, this.element[0] !== x.ui.safeActiveElement(this.document[0]) && this.element.trigger("focus")
                        })
                    },
                    menufocus: function (t, e) {
                        var i, n;
                        return this.isNewMenu && (this.isNewMenu = !1, t.originalEvent && /^mouse/.test(t.originalEvent.type)) ? (this.menu.blur(), void this.document.one("mousemove", function () {
                            x(t.target).trigger(t.originalEvent)
                        })) : (n = e.item.data("ui-autocomplete-item"), !1 !== this._trigger("focus", t, {
                            item: n
                        }) && t.originalEvent && /^key/.test(t.originalEvent.type) && this._value(n.value), void ((i = e.item.attr("aria-label") || n.value) && x.trim(i).length && (this.liveRegion.children().hide(), x("<div>").text(i).appendTo(this.liveRegion))))
                    },
                    menuselect: function (t, e) {
                        var i = e.item.data("ui-autocomplete-item"),
                            n = this.previous;
                        this.element[0] !== x.ui.safeActiveElement(this.document[0]) && (this.element.trigger("focus"), this.previous = n, this._delay(function () {
                            this.previous = n, this.selectedItem = i
                        })), !1 !== this._trigger("select", t, {
                            item: i
                        }) && this._value(i.value), this.term = this._value(), this.close(t), this.selectedItem = i
                    }
                }), this.liveRegion = x("<div>", {
                    role: "status",
                    "aria-live": "assertive",
                    "aria-relevant": "additions"
                }).appendTo(this.document[0].body), this._addClass(this.liveRegion, null, "ui-helper-hidden-accessible"), this._on(this.window, {
                    beforeunload: function () {
                        this.element.removeAttr("autocomplete")
                    }
                })
            },
            _destroy: function () {
                clearTimeout(this.searching), this.element.removeAttr("autocomplete"), this.menu.element.remove(), this.liveRegion.remove()
            },
            _setOption: function (t, e) {
                this._super(t, e), "source" === t && this._initSource(), "appendTo" === t && this.menu.element.appendTo(this._appendTo()), "disabled" === t && e && this.xhr && this.xhr.abort()
            },
            _isEventTargetInWidget: function (t) {
                var e = this.menu.element[0];
                return t.target === this.element[0] || t.target === e || x.contains(e, t.target)
            },
            _closeOnClickOutside: function (t) {
                this._isEventTargetInWidget(t) || this.close()
            },
            _appendTo: function () {
                var t = this.options.appendTo;
                return (t = t && (t.jquery || t.nodeType ? x(t) : this.document.find(t).eq(0))) && t[0] || (t = this.element.closest(".ui-front, dialog")), t.length || (t = this.document[0].body), t
            },
            _initSource: function () {
                var i, n, s = this;
                x.isArray(this.options.source) ? (i = this.options.source, this.source = function (t, e) {
                    e(x.ui.autocomplete.filter(i, t.term))
                }) : "string" == typeof this.options.source ? (n = this.options.source, this.source = function (t, e) {
                    s.xhr && s.xhr.abort(), s.xhr = x.ajax({
                        url: n,
                        data: t,
                        dataType: "json",
                        success: function (t) {
                            e(t)
                        },
                        error: function () {
                            e([])
                        }
                    })
                }) : this.source = this.options.source
            },
            _searchTimeout: function (n) {
                clearTimeout(this.searching), this.searching = this._delay(function () {
                    var t = this.term === this._value(),
                        e = this.menu.element.is(":visible"),
                        i = n.altKey || n.ctrlKey || n.metaKey || n.shiftKey;
                    t && (!t || e || i) || (this.selectedItem = null, this.search(null, n))
                }, this.options.delay)
            },
            search: function (t, e) {
                return t = null != t ? t : this._value(), this.term = this._value(), t.length < this.options.minLength ? this.close(e) : !1 !== this._trigger("search", e) ? this._search(t) : void 0
            },
            _search: function (t) {
                this.pending++ , this._addClass("ui-autocomplete-loading"), this.cancelSearch = !1, this.source({
                    term: t
                }, this._response())
            },
            _response: function () {
                var e = ++this.requestIndex;
                return x.proxy(function (t) {
                    e === this.requestIndex && this.__response(t), this.pending-- , this.pending || this._removeClass("ui-autocomplete-loading")
                }, this)
            },
            __response: function (t) {
                t = t && this._normalize(t), this._trigger("response", null, {
                    content: t
                }), !this.options.disabled && t && t.length && !this.cancelSearch ? (this._suggest(t), this._trigger("open")) : this._close()
            },
            close: function (t) {
                this.cancelSearch = !0, this._close(t)
            },
            _close: function (t) {
                this._off(this.document, "mousedown"), this.menu.element.is(":visible") && (this.menu.element.hide(), this.menu.blur(), this.isNewMenu = !0, this._trigger("close", t))
            },
            _change: function (t) {
                this.previous !== this._value() && this._trigger("change", t, {
                    item: this.selectedItem
                })
            },
            _normalize: function (t) {
                return t.length && t[0].label && t[0].value ? t : x.map(t, function (t) {
                    return "string" == typeof t ? {
                        label: t,
                        value: t
                    } : x.extend({}, t, {
                        label: t.label || t.value,
                        value: t.value || t.label
                    })
                })
            },
            _suggest: function (t) {
                var e = this.menu.element.empty();
                this._renderMenu(e, t), this.isNewMenu = !0, this.menu.refresh(), e.show(), this._resizeMenu(), e.position(x.extend({
                    of: this.element
                }, this.options.position)), this.options.autoFocus && this.menu.next(), this._on(this.document, {
                    mousedown: "_closeOnClickOutside"
                })
            },
            _resizeMenu: function () {
                var t = this.menu.element;
                t.outerWidth(Math.max(t.width("").outerWidth() + 1, this.element.outerWidth()))
            },
            _renderMenu: function (i, t) {
                var n = this;
                x.each(t, function (t, e) {
                    n._renderItemData(i, e)
                })
            },
            _renderItemData: function (t, e) {
                return this._renderItem(t, e).data("ui-autocomplete-item", e)
            },
            _renderItem: function (t, e) {
                return x("<li>").append(x("<div>").text(e.label)).appendTo(t)
            },
            _move: function (t, e) {
                return this.menu.element.is(":visible") ? this.menu.isFirstItem() && /^previous/.test(t) || this.menu.isLastItem() && /^next/.test(t) ? (this.isMultiLine || this._value(this.term), void this.menu.blur()) : void this.menu[t](e) : void this.search(null, e)
            },
            widget: function () {
                return this.menu.element
            },
            _value: function () {
                return this.valueMethod.apply(this.element, arguments)
            },
            _keyEvent: function (t, e) {
                this.isMultiLine && !this.menu.element.is(":visible") || (this._move(t, e), e.preventDefault())
            },
            _isContentEditable: function (t) {
                if (!t.length) return !1;
                var e = t.prop("contentEditable");
                return "inherit" === e ? this._isContentEditable(t.parent()) : "true" === e
            }
        }), x.extend(x.ui.autocomplete, {
            escapeRegex: function (t) {
                return t.replace(/[\-\[\]{}()*+?.,\\\^$|#\s]/g, "\\$&")
            },
            filter: function (t, e) {
                var i = RegExp(x.ui.autocomplete.escapeRegex(e), "i");
                return x.grep(t, function (t) {
                    return i.test(t.label || t.value || t)
                })
            }
        }), x.widget("ui.autocomplete", x.ui.autocomplete, {
            options: {
                messages: {
                    noResults: "No search results.",
                    results: function (t) {
                        return t + (1 < t ? " results are" : " result is") + " available, use up and down arrow keys to navigate."
                    }
                }
            },
            __response: function (t) {
                var e;
                this._superApply(arguments), this.options.disabled || this.cancelSearch || (e = t && t.length ? this.options.messages.results(t.length) : this.options.messages.noResults, this.liveRegion.children().hide(), x("<div>").text(e).appendTo(this.liveRegion))
            }
        }), x.ui.autocomplete;
        var et, it, nt = /ui-corner-([a-z]){2,6}/g;
        x.widget("ui.controlgroup", {
            version: "1.12.1",
            defaultElement: "<div>",
            options: {
                direction: "horizontal",
                disabled: null,
                onlyVisible: !0,
                items: {
                    button: "input[type=button], input[type=submit], input[type=reset], button, a",
                    controlgroupLabel: ".ui-controlgroup-label",
                    checkboxradio: "input[type='checkbox'], input[type='radio']",
                    selectmenu: "select",
                    spinner: ".ui-spinner-input"
                }
            },
            _create: function () {
                this._enhance()
            },
            _enhance: function () {
                this.element.attr("role", "toolbar"), this.refresh()
            },
            _destroy: function () {
                this._callChildMethod("destroy"), this.childWidgets.removeData("ui-controlgroup-data"), this.element.removeAttr("role"), this.options.items.controlgroupLabel && this.element.find(this.options.items.controlgroupLabel).find(".ui-controlgroup-label-contents").contents().unwrap()
            },
            _initWidgets: function () {
                var r = this,
                    a = [];
                x.each(this.options.items, function (s, t) {
                    var e, o = {};
                    return t ? "controlgroupLabel" === s ? ((e = r.element.find(t)).each(function () {
                        var t = x(this);
                        t.children(".ui-controlgroup-label-contents").length || t.contents().wrapAll("<span class='ui-controlgroup-label-contents'></span>")
                    }), r._addClass(e, null, "ui-widget ui-widget-content ui-state-default"), void (a = a.concat(e.get()))) : void (x.fn[s] && (o = r["_" + s + "Options"] ? r["_" + s + "Options"]("middle") : {
                        classes: {}
                    }, r.element.find(t).each(function () {
                        var t = x(this),
                            e = t[s]("instance"),
                            i = x.widget.extend({}, o);
                        if ("button" !== s || !t.parent(".ui-spinner").length) {
                            (e = e || t[s]()[s]("instance")) && (i.classes = r._resolveClassesValues(i.classes, e)), t[s](i);
                            var n = t[s]("widget");
                            x.data(n[0], "ui-controlgroup-data", e || t[s]("instance")), a.push(n[0])
                        }
                    }))) : void 0
                }), this.childWidgets = x(x.unique(a)), this._addClass(this.childWidgets, "ui-controlgroup-item")
            },
            _callChildMethod: function (e) {
                this.childWidgets.each(function () {
                    var t = x(this).data("ui-controlgroup-data");
                    t && t[e] && t[e]()
                })
            },
            _updateCornerClass: function (t, e) {
                var i = this._buildSimpleOptions(e, "label").classes.label;
                this._removeClass(t, null, "ui-corner-top ui-corner-bottom ui-corner-left ui-corner-right ui-corner-all"), this._addClass(t, null, i)
            },
            _buildSimpleOptions: function (t, e) {
                var i = "vertical" === this.options.direction,
                    n = {
                        classes: {}
                    };
                return n.classes[e] = {
                    middle: "",
                    first: "ui-corner-" + (i ? "top" : "left"),
                    last: "ui-corner-" + (i ? "bottom" : "right"),
                    only: "ui-corner-all"
                }[t], n
            },
            _spinnerOptions: function (t) {
                var e = this._buildSimpleOptions(t, "ui-spinner");
                return e.classes["ui-spinner-up"] = "", e.classes["ui-spinner-down"] = "", e
            },
            _buttonOptions: function (t) {
                return this._buildSimpleOptions(t, "ui-button")
            },
            _checkboxradioOptions: function (t) {
                return this._buildSimpleOptions(t, "ui-checkboxradio-label")
            },
            _selectmenuOptions: function (t) {
                var e = "vertical" === this.options.direction;
                return {
                    width: e && "auto",
                    classes: {
                        middle: {
                            "ui-selectmenu-button-open": "",
                            "ui-selectmenu-button-closed": ""
                        },
                        first: {
                            "ui-selectmenu-button-open": "ui-corner-" + (e ? "top" : "tl"),
                            "ui-selectmenu-button-closed": "ui-corner-" + (e ? "top" : "left")
                        },
                        last: {
                            "ui-selectmenu-button-open": e ? "" : "ui-corner-tr",
                            "ui-selectmenu-button-closed": "ui-corner-" + (e ? "bottom" : "right")
                        },
                        only: {
                            "ui-selectmenu-button-open": "ui-corner-top",
                            "ui-selectmenu-button-closed": "ui-corner-all"
                        }
                    }[t]
                }
            },
            _resolveClassesValues: function (i, n) {
                var s = {};
                return x.each(i, function (t) {
                    var e = n.options.classes[t] || "";
                    e = x.trim(e.replace(nt, "")), s[t] = (e + " " + i[t]).replace(/\s+/g, " ")
                }), s
            },
            _setOption: function (t, e) {
                return "direction" === t && this._removeClass("ui-controlgroup-" + this.options.direction), this._super(t, e), "disabled" === t ? void this._callChildMethod(e ? "disable" : "enable") : void this.refresh()
            },
            refresh: function () {
                var s, o = this;
                this._addClass("ui-controlgroup ui-controlgroup-" + this.options.direction), "horizontal" === this.options.direction && this._addClass(null, "ui-helper-clearfix"), this._initWidgets(), s = this.childWidgets, this.options.onlyVisible && (s = s.filter(":visible")), s.length && (x.each(["first", "last"], function (t, e) {
                    var i = s[e]().data("ui-controlgroup-data");
                    if (i && o["_" + i.widgetName + "Options"]) {
                        var n = o["_" + i.widgetName + "Options"](1 === s.length ? "only" : e);
                        n.classes = o._resolveClassesValues(n.classes, i), i.element[i.widgetName](n)
                    } else o._updateCornerClass(s[e](), e)
                }), this._callChildMethod("refresh"))
            }
        }), x.widget("ui.checkboxradio", [x.ui.formResetMixin, {
            version: "1.12.1",
            options: {
                disabled: null,
                label: null,
                icon: !0,
                classes: {
                    "ui-checkboxradio-label": "ui-corner-all",
                    "ui-checkboxradio-icon": "ui-corner-all"
                }
            },
            _getCreateOptions: function () {
                var t, e, i = this,
                    n = this._super() || {};
                return this._readType(), e = this.element.labels(), this.label = x(e[e.length - 1]), this.label.length || x.error("No label found for checkboxradio widget"), this.originalLabel = "", this.label.contents().not(this.element[0]).each(function () {
                    i.originalLabel += 3 === this.nodeType ? x(this).text() : this.outerHTML
                }), this.originalLabel && (n.label = this.originalLabel), null != (t = this.element[0].disabled) && (n.disabled = t), n
            },
            _create: function () {
                var t = this.element[0].checked;
                this._bindFormResetHandler(), null == this.options.disabled && (this.options.disabled = this.element[0].disabled), this._setOption("disabled", this.options.disabled), this._addClass("ui-checkboxradio", "ui-helper-hidden-accessible"), this._addClass(this.label, "ui-checkboxradio-label", "ui-button ui-widget"), "radio" === this.type && this._addClass(this.label, "ui-checkboxradio-radio-label"), this.options.label && this.options.label !== this.originalLabel ? this._updateLabel() : this.originalLabel && (this.options.label = this.originalLabel), this._enhance(), t && (this._addClass(this.label, "ui-checkboxradio-checked", "ui-state-active"), this.icon && this._addClass(this.icon, null, "ui-state-hover")), this._on({
                    change: "_toggleClasses",
                    focus: function () {
                        this._addClass(this.label, null, "ui-state-focus ui-visual-focus")
                    },
                    blur: function () {
                        this._removeClass(this.label, null, "ui-state-focus ui-visual-focus")
                    }
                })
            },
            _readType: function () {
                var t = this.element[0].nodeName.toLowerCase();
                this.type = this.element[0].type, "input" === t && /radio|checkbox/.test(this.type) || x.error("Can't create checkboxradio on element.nodeName=" + t + " and element.type=" + this.type)
            },
            _enhance: function () {
                this._updateIcon(this.element[0].checked)
            },
            widget: function () {
                return this.label
            },
            _getRadioGroup: function () {
                var t = this.element[0].name,
                    e = "input[name='" + x.ui.escapeSelector(t) + "']";
                return t ? (this.form.length ? x(this.form[0].elements).filter(e) : x(e).filter(function () {
                    return 0 === x(this).form().length
                })).not(this.element) : x([])
            },
            _toggleClasses: function () {
                var t = this.element[0].checked;
                this._toggleClass(this.label, "ui-checkboxradio-checked", "ui-state-active", t), this.options.icon && "checkbox" === this.type && this._toggleClass(this.icon, null, "ui-icon-check ui-state-checked", t)._toggleClass(this.icon, null, "ui-icon-blank", !t), "radio" === this.type && this._getRadioGroup().each(function () {
                    var t = x(this).checkboxradio("instance");
                    t && t._removeClass(t.label, "ui-checkboxradio-checked", "ui-state-active")
                })
            },
            _destroy: function () {
                this._unbindFormResetHandler(), this.icon && (this.icon.remove(), this.iconSpace.remove())
            },
            _setOption: function (t, e) {
                return "label" !== t || e ? (this._super(t, e), "disabled" === t ? (this._toggleClass(this.label, null, "ui-state-disabled", e), void (this.element[0].disabled = e)) : void this.refresh()) : void 0
            },
            _updateIcon: function (t) {
                var e = "ui-icon ui-icon-background ";
                this.options.icon ? (this.icon || (this.icon = x("<span>"), this.iconSpace = x("<span> </span>"), this._addClass(this.iconSpace, "ui-checkboxradio-icon-space")), "checkbox" === this.type ? (e += t ? "ui-icon-check ui-state-checked" : "ui-icon-blank", this._removeClass(this.icon, null, t ? "ui-icon-blank" : "ui-icon-check")) : e += "ui-icon-blank", this._addClass(this.icon, "ui-checkboxradio-icon", e), t || this._removeClass(this.icon, null, "ui-icon-check ui-state-checked"), this.icon.prependTo(this.label).after(this.iconSpace)) : void 0 !== this.icon && (this.icon.remove(), this.iconSpace.remove(), delete this.icon)
            },
            _updateLabel: function () {
                var t = this.label.contents().not(this.element[0]);
                this.icon && (t = t.not(this.icon[0])), this.iconSpace && (t = t.not(this.iconSpace[0])), t.remove(), this.label.append(this.options.label)
            },
            refresh: function () {
                var t = this.element[0].checked,
                    e = this.element[0].disabled;
                this._updateIcon(t), this._toggleClass(this.label, "ui-checkboxradio-checked", "ui-state-active", t), null !== this.options.label && this._updateLabel(), e !== this.options.disabled && this._setOptions({
                    disabled: e
                })
            }
        }]), x.ui.checkboxradio, x.widget("ui.button", {
            version: "1.12.1",
            defaultElement: "<button>",
            options: {
                classes: {
                    "ui-button": "ui-corner-all"
                },
                disabled: null,
                icon: null,
                iconPosition: "beginning",
                label: null,
                showLabel: !0
            },
            _getCreateOptions: function () {
                var t, e = this._super() || {};
                return this.isInput = this.element.is("input"), null != (t = this.element[0].disabled) && (e.disabled = t), this.originalLabel = this.isInput ? this.element.val() : this.element.html(), this.originalLabel && (e.label = this.originalLabel), e
            },
            _create: function () {
                !this.option.showLabel & !this.options.icon && (this.options.showLabel = !0), null == this.options.disabled && (this.options.disabled = this.element[0].disabled || !1), this.hasTitle = !!this.element.attr("title"), this.options.label && this.options.label !== this.originalLabel && (this.isInput ? this.element.val(this.options.label) : this.element.html(this.options.label)), this._addClass("ui-button", "ui-widget"), this._setOption("disabled", this.options.disabled), this._enhance(), this.element.is("a") && this._on({
                    keyup: function (t) {
                        t.keyCode === x.ui.keyCode.SPACE && (t.preventDefault(), this.element[0].click ? this.element[0].click() : this.element.trigger("click"))
                    }
                })
            },
            _enhance: function () {
                this.element.is("button") || this.element.attr("role", "button"), this.options.icon && (this._updateIcon("icon", this.options.icon), this._updateTooltip())
            },
            _updateTooltip: function () {
                this.title = this.element.attr("title"), this.options.showLabel || this.title || this.element.attr("title", this.options.label)
            },
            _updateIcon: function (t, e) {
                var i = "iconPosition" !== t,
                    n = i ? this.options.iconPosition : e,
                    s = "top" === n || "bottom" === n;
                this.icon ? i && this._removeClass(this.icon, null, this.options.icon) : (this.icon = x("<span>"), this._addClass(this.icon, "ui-button-icon", "ui-icon"), this.options.showLabel || this._addClass("ui-button-icon-only")), i && this._addClass(this.icon, null, e), this._attachIcon(n), s ? (this._addClass(this.icon, null, "ui-widget-icon-block"), this.iconSpace && this.iconSpace.remove()) : (this.iconSpace || (this.iconSpace = x("<span> </span>"), this._addClass(this.iconSpace, "ui-button-icon-space")), this._removeClass(this.icon, null, "ui-wiget-icon-block"), this._attachIconSpace(n))
            },
            _destroy: function () {
                this.element.removeAttr("role"), this.icon && this.icon.remove(), this.iconSpace && this.iconSpace.remove(), this.hasTitle || this.element.removeAttr("title")
            },
            _attachIconSpace: function (t) {
                this.icon[/^(?:end|bottom)/.test(t) ? "before" : "after"](this.iconSpace)
            },
            _attachIcon: function (t) {
                this.element[/^(?:end|bottom)/.test(t) ? "append" : "prepend"](this.icon)
            },
            _setOptions: function (t) {
                var e = void 0 === t.showLabel ? this.options.showLabel : t.showLabel,
                    i = void 0 === t.icon ? this.options.icon : t.icon;
                e || i || (t.showLabel = !0), this._super(t)
            },
            _setOption: function (t, e) {
                "icon" === t && (e ? this._updateIcon(t, e) : this.icon && (this.icon.remove(), this.iconSpace && this.iconSpace.remove())), "iconPosition" === t && this._updateIcon(t, e), "showLabel" === t && (this._toggleClass("ui-button-icon-only", null, !e), this._updateTooltip()), "label" === t && (this.isInput ? this.element.val(e) : (this.element.html(e), this.icon && (this._attachIcon(this.options.iconPosition), this._attachIconSpace(this.options.iconPosition)))), this._super(t, e), "disabled" === t && (this._toggleClass(null, "ui-state-disabled", e), (this.element[0].disabled = e) && this.element.blur())
            },
            refresh: function () {
                var t = this.element.is("input, button") ? this.element[0].disabled : this.element.hasClass("ui-button-disabled");
                t !== this.options.disabled && this._setOptions({
                    disabled: t
                }), this._updateTooltip()
            }
        }), !1 !== x.uiBackCompat && (x.widget("ui.button", x.ui.button, {
            options: {
                text: !0,
                icons: {
                    primary: null,
                    secondary: null
                }
            },
            _create: function () {
                this.options.showLabel && !this.options.text && (this.options.showLabel = this.options.text), !this.options.showLabel && this.options.text && (this.options.text = this.options.showLabel), this.options.icon || !this.options.icons.primary && !this.options.icons.secondary ? this.options.icon && (this.options.icons.primary = this.options.icon) : this.options.icons.primary ? this.options.icon = this.options.icons.primary : (this.options.icon = this.options.icons.secondary, this.options.iconPosition = "end"), this._super()
            },
            _setOption: function (t, e) {
                return "text" === t ? void this._super("showLabel", e) : ("showLabel" === t && (this.options.text = e), "icon" === t && (this.options.icons.primary = e), "icons" === t && (e.primary ? (this._super("icon", e.primary), this._super("iconPosition", "beginning")) : e.secondary && (this._super("icon", e.secondary), this._super("iconPosition", "end"))), void this._superApply(arguments))
            }
        }), x.fn.button = (et = x.fn.button, function () {
            return !this.length || this.length && "INPUT" !== this[0].tagName || this.length && "INPUT" === this[0].tagName && "checkbox" !== this.attr("type") && "radio" !== this.attr("type") ? et.apply(this, arguments) : (x.ui.checkboxradio || x.error("Checkboxradio widget missing"), 0 === arguments.length ? this.checkboxradio({
                icon: !1
            }) : this.checkboxradio.apply(this, arguments))
        }), x.fn.buttonset = function () {
            return x.ui.controlgroup || x.error("Controlgroup widget missing"), "option" === arguments[0] && "items" === arguments[1] && arguments[2] ? this.controlgroup.apply(this, [arguments[0], "items.button", arguments[2]]) : "option" === arguments[0] && "items" === arguments[1] ? this.controlgroup.apply(this, [arguments[0], "items.button"]) : ("object" == typeof arguments[0] && arguments[0].items && (arguments[0].items = {
                button: arguments[0].items
            }), this.controlgroup.apply(this, arguments))
        }), x.ui.button, x.extend(x.ui, {
            datepicker: {
                version: "1.12.1"
            }
        }), x.extend(t.prototype, {
            markerClassName: "hasDatepicker",
            maxRows: 4,
            _widgetDatepicker: function () {
                return this.dpDiv
            },
            setDefaults: function (t) {
                return u(this._defaults, t || {}), this
            },
            _attachDatepicker: function (t, e) {
                var i, n, s;
                n = "div" === (i = t.nodeName.toLowerCase()) || "span" === i, t.id || (this.uuid += 1, t.id = "dp" + this.uuid), (s = this._newInst(x(t), n)).settings = x.extend({}, e || {}), "input" === i ? this._connectDatepicker(t, s) : n && this._inlineDatepicker(t, s)
            },
            _newInst: function (t, e) {
                return {
                    id: t[0].id.replace(/([^A-Za-z0-9_\-])/g, "\\\\$1"),
                    input: t,
                    selectedDay: 0,
                    selectedMonth: 0,
                    selectedYear: 0,
                    drawMonth: 0,
                    drawYear: 0,
                    inline: e,
                    dpDiv: e ? i(x("<div class='" + this._inlineClass + " ui-datepicker ui-widget ui-widget-content ui-helper-clearfix ui-corner-all'></div>")) : this.dpDiv
                }
            },
            _connectDatepicker: function (t, e) {
                var i = x(t);
                e.append = x([]), e.trigger = x([]), i.hasClass(this.markerClassName) || (this._attachments(i, e), i.addClass(this.markerClassName).on("keydown", this._doKeyDown).on("keypress", this._doKeyPress).on("keyup", this._doKeyUp), this._autoSize(e), x.data(t, "datepicker", e), e.settings.disabled && this._disableDatepicker(t))
            },
            _attachments: function (t, e) {
                var i, n, s, o = this._get(e, "appendText"),
                    r = this._get(e, "isRTL");
                e.append && e.append.remove(), o && (e.append = x("<span class='" + this._appendClass + "'>" + o + "</span>"), t[r ? "before" : "after"](e.append)), t.off("focus", this._showDatepicker), e.trigger && e.trigger.remove(), "focus" !== (i = this._get(e, "showOn")) && "both" !== i || t.on("focus", this._showDatepicker), "button" !== i && "both" !== i || (n = this._get(e, "buttonText"), s = this._get(e, "buttonImage"), e.trigger = x(this._get(e, "buttonImageOnly") ? x("<img/>").addClass(this._triggerClass).attr({
                    src: s,
                    alt: n,
                    title: n
                }) : x("<button type='button'></button>").addClass(this._triggerClass).html(s ? x("<img/>").attr({
                    src: s,
                    alt: n,
                    title: n
                }) : n)), t[r ? "before" : "after"](e.trigger), e.trigger.on("click", function () {
                    return x.datepicker._datepickerShowing && x.datepicker._lastInput === t[0] ? x.datepicker._hideDatepicker() : (x.datepicker._datepickerShowing && x.datepicker._lastInput !== t[0] && x.datepicker._hideDatepicker(), x.datepicker._showDatepicker(t[0])), !1
                }))
            },
            _autoSize: function (t) {
                if (this._get(t, "autoSize") && !t.inline) {
                    var e, i, n, s, o = new Date(2009, 11, 20),
                        r = this._get(t, "dateFormat");
                    r.match(/[DM]/) && (e = function (t) {
                        for (s = n = i = 0; t.length > s; s++) t[s].length > i && (i = t[s].length, n = s);
                        return n
                    }, o.setMonth(e(this._get(t, r.match(/MM/) ? "monthNames" : "monthNamesShort"))), o.setDate(e(this._get(t, r.match(/DD/) ? "dayNames" : "dayNamesShort")) + 20 - o.getDay())), t.input.attr("size", this._formatDate(t, o).length)
                }
            },
            _inlineDatepicker: function (t, e) {
                var i = x(t);
                i.hasClass(this.markerClassName) || (i.addClass(this.markerClassName).append(e.dpDiv), x.data(t, "datepicker", e), this._setDate(e, this._getDefaultDate(e), !0), this._updateDatepicker(e), this._updateAlternate(e), e.settings.disabled && this._disableDatepicker(t), e.dpDiv.css("display", "block"))
            },
            _dialogDatepicker: function (t, e, i, n, s) {
                var o, r, a, l, h, c = this._dialogInst;
                return c || (this.uuid += 1, o = "dp" + this.uuid, this._dialogInput = x("<input type='text' id='" + o + "' style='position: absolute; top: -100px; width: 0px;'/>"), this._dialogInput.on("keydown", this._doKeyDown), x("body").append(this._dialogInput), (c = this._dialogInst = this._newInst(this._dialogInput, !1)).settings = {}, x.data(this._dialogInput[0], "datepicker", c)), u(c.settings, n || {}), e = e && e.constructor === Date ? this._formatDate(c, e) : e, this._dialogInput.val(e), this._pos = s ? s.length ? s : [s.pageX, s.pageY] : null, this._pos || (r = document.documentElement.clientWidth, a = document.documentElement.clientHeight, l = document.documentElement.scrollLeft || document.body.scrollLeft, h = document.documentElement.scrollTop || document.body.scrollTop, this._pos = [r / 2 - 100 + l, a / 2 - 150 + h]), this._dialogInput.css("left", this._pos[0] + 20 + "px").css("top", this._pos[1] + "px"), c.settings.onSelect = i, this._inDialog = !0, this.dpDiv.addClass(this._dialogClass), this._showDatepicker(this._dialogInput[0]), x.blockUI && x.blockUI(this.dpDiv), x.data(this._dialogInput[0], "datepicker", c), this
            },
            _destroyDatepicker: function (t) {
                var e, i = x(t),
                    n = x.data(t, "datepicker");
                i.hasClass(this.markerClassName) && (e = t.nodeName.toLowerCase(), x.removeData(t, "datepicker"), "input" === e ? (n.append.remove(), n.trigger.remove(), i.removeClass(this.markerClassName).off("focus", this._showDatepicker).off("keydown", this._doKeyDown).off("keypress", this._doKeyPress).off("keyup", this._doKeyUp)) : "div" !== e && "span" !== e || i.removeClass(this.markerClassName).empty(), it === n && (it = null))
            },
            _enableDatepicker: function (e) {
                var t, i, n = x(e),
                    s = x.data(e, "datepicker");
                n.hasClass(this.markerClassName) && ("input" === (t = e.nodeName.toLowerCase()) ? (e.disabled = !1, s.trigger.filter("button").each(function () {
                    this.disabled = !1
                }).end().filter("img").css({
                    opacity: "1.0",
                    cursor: ""
                })) : "div" !== t && "span" !== t || ((i = n.children("." + this._inlineClass)).children().removeClass("ui-state-disabled"), i.find("select.ui-datepicker-month, select.ui-datepicker-year").prop("disabled", !1)), this._disabledInputs = x.map(this._disabledInputs, function (t) {
                    return t === e ? null : t
                }))
            },
            _disableDatepicker: function (e) {
                var t, i, n = x(e),
                    s = x.data(e, "datepicker");
                n.hasClass(this.markerClassName) && ("input" === (t = e.nodeName.toLowerCase()) ? (e.disabled = !0, s.trigger.filter("button").each(function () {
                    this.disabled = !0
                }).end().filter("img").css({
                    opacity: "0.5",
                    cursor: "default"
                })) : "div" !== t && "span" !== t || ((i = n.children("." + this._inlineClass)).children().addClass("ui-state-disabled"), i.find("select.ui-datepicker-month, select.ui-datepicker-year").prop("disabled", !0)), this._disabledInputs = x.map(this._disabledInputs, function (t) {
                    return t === e ? null : t
                }), this._disabledInputs[this._disabledInputs.length] = e)
            },
            _isDisabledDatepicker: function (t) {
                if (!t) return !1;
                for (var e = 0; this._disabledInputs.length > e; e++)
                    if (this._disabledInputs[e] === t) return !0;
                return !1
            },
            _getInst: function (t) {
                try {
                    return x.data(t, "datepicker")
                } catch (t) {
                    throw "Missing instance data for this datepicker"
                }
            },
            _optionDatepicker: function (t, e, i) {
                var n, s, o, r, a = this._getInst(t);
                return 2 === arguments.length && "string" == typeof e ? "defaults" === e ? x.extend({}, x.datepicker._defaults) : a ? "all" === e ? x.extend({}, a.settings) : this._get(a, e) : null : (n = e || {}, "string" == typeof e && ((n = {})[e] = i), void (a && (this._curInst === a && this._hideDatepicker(), s = this._getDateDatepicker(t, !0), o = this._getMinMaxDate(a, "min"), r = this._getMinMaxDate(a, "max"), u(a.settings, n), null !== o && void 0 !== n.dateFormat && void 0 === n.minDate && (a.settings.minDate = this._formatDate(a, o)), null !== r && void 0 !== n.dateFormat && void 0 === n.maxDate && (a.settings.maxDate = this._formatDate(a, r)), "disabled" in n && (n.disabled ? this._disableDatepicker(t) : this._enableDatepicker(t)), this._attachments(x(t), a), this._autoSize(a), this._setDate(a, s), this._updateAlternate(a), this._updateDatepicker(a))))
            },
            _changeDatepicker: function (t, e, i) {
                this._optionDatepicker(t, e, i)
            },
            _refreshDatepicker: function (t) {
                var e = this._getInst(t);
                e && this._updateDatepicker(e)
            },
            _setDateDatepicker: function (t, e) {
                var i = this._getInst(t);
                i && (this._setDate(i, e), this._updateDatepicker(i), this._updateAlternate(i))
            },
            _getDateDatepicker: function (t, e) {
                var i = this._getInst(t);
                return i && !i.inline && this._setDateFromField(i, e), i ? this._getDate(i) : null
            },
            _doKeyDown: function (t) {
                var e, i, n, s = x.datepicker._getInst(t.target),
                    o = !0,
                    r = s.dpDiv.is(".ui-datepicker-rtl");
                if (s._keyEvent = !0, x.datepicker._datepickerShowing) switch (t.keyCode) {
                    case 9:
                        x.datepicker._hideDatepicker(), o = !1;
                        break;
                    case 13:
                        return (n = x("td." + x.datepicker._dayOverClass + ":not(." + x.datepicker._currentClass + ")", s.dpDiv))[0] && x.datepicker._selectDay(t.target, s.selectedMonth, s.selectedYear, n[0]), (e = x.datepicker._get(s, "onSelect")) ? (i = x.datepicker._formatDate(s), e.apply(s.input ? s.input[0] : null, [i, s])) : x.datepicker._hideDatepicker(), !1;
                    case 27:
                        x.datepicker._hideDatepicker();
                        break;
                    case 33:
                        x.datepicker._adjustDate(t.target, t.ctrlKey ? -x.datepicker._get(s, "stepBigMonths") : -x.datepicker._get(s, "stepMonths"), "M");
                        break;
                    case 34:
                        x.datepicker._adjustDate(t.target, t.ctrlKey ? +x.datepicker._get(s, "stepBigMonths") : +x.datepicker._get(s, "stepMonths"), "M");
                        break;
                    case 35:
                        (t.ctrlKey || t.metaKey) && x.datepicker._clearDate(t.target), o = t.ctrlKey || t.metaKey;
                        break;
                    case 36:
                        (t.ctrlKey || t.metaKey) && x.datepicker._gotoToday(t.target), o = t.ctrlKey || t.metaKey;
                        break;
                    case 37:
                        (t.ctrlKey || t.metaKey) && x.datepicker._adjustDate(t.target, r ? 1 : -1, "D"), o = t.ctrlKey || t.metaKey, t.originalEvent.altKey && x.datepicker._adjustDate(t.target, t.ctrlKey ? -x.datepicker._get(s, "stepBigMonths") : -x.datepicker._get(s, "stepMonths"), "M");
                        break;
                    case 38:
                        (t.ctrlKey || t.metaKey) && x.datepicker._adjustDate(t.target, -7, "D"), o = t.ctrlKey || t.metaKey;
                        break;
                    case 39:
                        (t.ctrlKey || t.metaKey) && x.datepicker._adjustDate(t.target, r ? -1 : 1, "D"), o = t.ctrlKey || t.metaKey, t.originalEvent.altKey && x.datepicker._adjustDate(t.target, t.ctrlKey ? +x.datepicker._get(s, "stepBigMonths") : +x.datepicker._get(s, "stepMonths"), "M");
                        break;
                    case 40:
                        (t.ctrlKey || t.metaKey) && x.datepicker._adjustDate(t.target, 7, "D"), o = t.ctrlKey || t.metaKey;
                        break;
                    default:
                        o = !1
                } else 36 === t.keyCode && t.ctrlKey ? x.datepicker._showDatepicker(this) : o = !1;
                o && (t.preventDefault(), t.stopPropagation())
            },
            _doKeyPress: function (t) {
                var e, i, n = x.datepicker._getInst(t.target);
                return x.datepicker._get(n, "constrainInput") ? (e = x.datepicker._possibleChars(x.datepicker._get(n, "dateFormat")), i = String.fromCharCode(null == t.charCode ? t.keyCode : t.charCode), t.ctrlKey || t.metaKey || i < " " || !e || -1 < e.indexOf(i)) : void 0
            },
            _doKeyUp: function (t) {
                var e = x.datepicker._getInst(t.target);
                if (e.input.val() !== e.lastVal) try {
                    x.datepicker.parseDate(x.datepicker._get(e, "dateFormat"), e.input ? e.input.val() : null, x.datepicker._getFormatConfig(e)) && (x.datepicker._setDateFromField(e), x.datepicker._updateAlternate(e), x.datepicker._updateDatepicker(e))
                } catch (t) { }
                return !0
            },
            _showDatepicker: function (t) {
                var e, i, n, s, o, r, a;
                "input" !== (t = t.target || t).nodeName.toLowerCase() && (t = x("input", t.parentNode)[0]), x.datepicker._isDisabledDatepicker(t) || x.datepicker._lastInput === t || (e = x.datepicker._getInst(t), x.datepicker._curInst && x.datepicker._curInst !== e && (x.datepicker._curInst.dpDiv.stop(!0, !0), e && x.datepicker._datepickerShowing && x.datepicker._hideDatepicker(x.datepicker._curInst.input[0])), !1 !== (n = (i = x.datepicker._get(e, "beforeShow")) ? i.apply(t, [t, e]) : {}) && (u(e.settings, n), e.lastVal = null, x.datepicker._lastInput = t, x.datepicker._setDateFromField(e), x.datepicker._inDialog && (t.value = ""), x.datepicker._pos || (x.datepicker._pos = x.datepicker._findPos(t), x.datepicker._pos[1] += t.offsetHeight), s = !1, x(t).parents().each(function () {
                    return !(s |= "fixed" === x(this).css("position"))
                }), o = {
                    left: x.datepicker._pos[0],
                    top: x.datepicker._pos[1]
                }, x.datepicker._pos = null, e.dpDiv.empty(), e.dpDiv.css({
                    position: "absolute",
                    display: "block",
                    top: "-1000px"
                }), x.datepicker._updateDatepicker(e), o = x.datepicker._checkOffset(e, o, s), e.dpDiv.css({
                    position: x.datepicker._inDialog && x.blockUI ? "static" : s ? "fixed" : "absolute",
                    display: "none",
                    left: o.left + "px",
                    top: o.top + "px"
                }), e.inline || (r = x.datepicker._get(e, "showAnim"), a = x.datepicker._get(e, "duration"), e.dpDiv.css("z-index", function (t) {
                    for (var e, i; t.length && t[0] !== document;) {
                        if (("absolute" === (e = t.css("position")) || "relative" === e || "fixed" === e) && (i = parseInt(t.css("zIndex"), 10), !isNaN(i) && 0 !== i)) return i;
                        t = t.parent()
                    }
                    return 0
                }(x(t)) + 1), x.datepicker._datepickerShowing = !0, x.effects && x.effects.effect[r] ? e.dpDiv.show(r, x.datepicker._get(e, "showOptions"), a) : e.dpDiv[r || "show"](r ? a : null), x.datepicker._shouldFocusInput(e) && e.input.trigger("focus"), x.datepicker._curInst = e)))
            },
            _updateDatepicker: function (t) {
                this.maxRows = 4, (it = t).dpDiv.empty().append(this._generateHTML(t)), this._attachHandlers(t);
                var e, i = this._getNumberOfMonths(t),
                    n = i[1],
                    s = t.dpDiv.find("." + this._dayOverClass + " a");
                0 < s.length && o.apply(s.get(0)), t.dpDiv.removeClass("ui-datepicker-multi-2 ui-datepicker-multi-3 ui-datepicker-multi-4").width(""), 1 < n && t.dpDiv.addClass("ui-datepicker-multi-" + n).css("width", 17 * n + "em"), t.dpDiv[(1 !== i[0] || 1 !== i[1] ? "add" : "remove") + "Class"]("ui-datepicker-multi"), t.dpDiv[(this._get(t, "isRTL") ? "add" : "remove") + "Class"]("ui-datepicker-rtl"), t === x.datepicker._curInst && x.datepicker._datepickerShowing && x.datepicker._shouldFocusInput(t) && t.input.trigger("focus"), t.yearshtml && (e = t.yearshtml, setTimeout(function () {
                    e === t.yearshtml && t.yearshtml && t.dpDiv.find("select.ui-datepicker-year:first").replaceWith(t.yearshtml), e = t.yearshtml = null
                }, 0))
            },
            _shouldFocusInput: function (t) {
                return t.input && t.input.is(":visible") && !t.input.is(":disabled") && !t.input.is(":focus")
            },
            _checkOffset: function (t, e, i) {
                var n = t.dpDiv.outerWidth(),
                    s = t.dpDiv.outerHeight(),
                    o = t.input ? t.input.outerWidth() : 0,
                    r = t.input ? t.input.outerHeight() : 0,
                    a = document.documentElement.clientWidth + (i ? 0 : x(document).scrollLeft()),
                    l = document.documentElement.clientHeight + (i ? 0 : x(document).scrollTop());
                return e.left -= this._get(t, "isRTL") ? n - o : 0, e.left -= i && e.left === t.input.offset().left ? x(document).scrollLeft() : 0, e.top -= i && e.top === t.input.offset().top + r ? x(document).scrollTop() : 0, e.left -= Math.min(e.left, e.left + n > a && n < a ? Math.abs(e.left + n - a) : 0), e.top -= Math.min(e.top, e.top + s > l && s < l ? Math.abs(s + r) : 0), e
            },
            _findPos: function (t) {
                for (var e, i = this._getInst(t), n = this._get(i, "isRTL"); t && ("hidden" === t.type || 1 !== t.nodeType || x.expr.filters.hidden(t));) t = t[n ? "previousSibling" : "nextSibling"];
                return [(e = x(t).offset()).left, e.top]
            },
            _hideDatepicker: function (t) {
                var e, i, n, s, o = this._curInst;
                !o || t && o !== x.data(t, "datepicker") || this._datepickerShowing && (e = this._get(o, "showAnim"), i = this._get(o, "duration"), n = function () {
                    x.datepicker._tidyDialog(o)
                }, x.effects && (x.effects.effect[e] || x.effects[e]) ? o.dpDiv.hide(e, x.datepicker._get(o, "showOptions"), i, n) : o.dpDiv["slideDown" === e ? "slideUp" : "fadeIn" === e ? "fadeOut" : "hide"](e ? i : null, n), e || n(), this._datepickerShowing = !1, (s = this._get(o, "onClose")) && s.apply(o.input ? o.input[0] : null, [o.input ? o.input.val() : "", o]), this._lastInput = null, this._inDialog && (this._dialogInput.css({
                    position: "absolute",
                    left: "0",
                    top: "-100px"
                }), x.blockUI && (x.unblockUI(), x("body").append(this.dpDiv))), this._inDialog = !1)
            },
            _tidyDialog: function (t) {
                t.dpDiv.removeClass(this._dialogClass).off(".ui-datepicker-calendar")
            },
            _checkExternalClick: function (t) {
                if (x.datepicker._curInst) {
                    var e = x(t.target),
                        i = x.datepicker._getInst(e[0]);
                    (e[0].id === x.datepicker._mainDivId || 0 !== e.parents("#" + x.datepicker._mainDivId).length || e.hasClass(x.datepicker.markerClassName) || e.closest("." + x.datepicker._triggerClass).length || !x.datepicker._datepickerShowing || x.datepicker._inDialog && x.blockUI) && (!e.hasClass(x.datepicker.markerClassName) || x.datepicker._curInst === i) || x.datepicker._hideDatepicker()
                }
            },
            _adjustDate: function (t, e, i) {
                var n = x(t),
                    s = this._getInst(n[0]);
                this._isDisabledDatepicker(n[0]) || (this._adjustInstDate(s, e + ("M" === i ? this._get(s, "showCurrentAtPos") : 0), i), this._updateDatepicker(s))
            },
            _gotoToday: function (t) {
                var e, i = x(t),
                    n = this._getInst(i[0]);
                this._get(n, "gotoCurrent") && n.currentDay ? (n.selectedDay = n.currentDay, n.drawMonth = n.selectedMonth = n.currentMonth, n.drawYear = n.selectedYear = n.currentYear) : (e = new Date, n.selectedDay = e.getDate(), n.drawMonth = n.selectedMonth = e.getMonth(), n.drawYear = n.selectedYear = e.getFullYear()), this._notifyChange(n), this._adjustDate(i)
            },
            _selectMonthYear: function (t, e, i) {
                var n = x(t),
                    s = this._getInst(n[0]);
                s["selected" + ("M" === i ? "Month" : "Year")] = s["draw" + ("M" === i ? "Month" : "Year")] = parseInt(e.options[e.selectedIndex].value, 10), this._notifyChange(s), this._adjustDate(n)
            },
            _selectDay: function (t, e, i, n) {
                var s, o = x(t);
                x(n).hasClass(this._unselectableClass) || this._isDisabledDatepicker(o[0]) || ((s = this._getInst(o[0])).selectedDay = s.currentDay = x("a", n).html(), s.selectedMonth = s.currentMonth = e, s.selectedYear = s.currentYear = i, this._selectDate(t, this._formatDate(s, s.currentDay, s.currentMonth, s.currentYear)))
            },
            _clearDate: function (t) {
                var e = x(t);
                this._selectDate(e, "")
            },
            _selectDate: function (t, e) {
                var i, n = x(t),
                    s = this._getInst(n[0]);
                e = null != e ? e : this._formatDate(s), s.input && s.input.val(e), this._updateAlternate(s), (i = this._get(s, "onSelect")) ? i.apply(s.input ? s.input[0] : null, [e, s]) : s.input && s.input.trigger("change"), s.inline ? this._updateDatepicker(s) : (this._hideDatepicker(), this._lastInput = s.input[0], "object" != typeof s.input[0] && s.input.trigger("focus"), this._lastInput = null)
            },
            _updateAlternate: function (t) {
                var e, i, n, s = this._get(t, "altField");
                s && (e = this._get(t, "altFormat") || this._get(t, "dateFormat"), i = this._getDate(t), n = this.formatDate(e, i, this._getFormatConfig(t)), x(s).val(n))
            },
            noWeekends: function (t) {
                var e = t.getDay();
                return [0 < e && e < 6, ""]
            },
            iso8601Week: function (t) {
                var e, i = new Date(t.getTime());
                return i.setDate(i.getDate() + 4 - (i.getDay() || 7)), e = i.getTime(), i.setMonth(0), i.setDate(1), Math.floor(Math.round((e - i) / 864e5) / 7) + 1
            },
            parseDate: function (i, o, t) {
                if (null == i || null == o) throw "Invalid arguments";
                if ("" === (o = "object" == typeof o ? "" + o : o + "")) return null;

                function r(t) {
                    var e = i.length > a + 1 && i.charAt(a + 1) === t;
                    return e && a++ , e
                }

                function e(t) {
                    var e = r(t),
                        i = "@" === t ? 14 : "!" === t ? 20 : "y" === t && e ? 4 : "o" === t ? 3 : 2,
                        n = RegExp("^\\d{" + ("y" === t ? i : 1) + "," + i + "}"),
                        s = o.substring(u).match(n);
                    if (!s) throw "Missing number at position " + u;
                    return u += s[0].length, parseInt(s[0], 10)
                }

                function n(t, e, i) {
                    var n = -1,
                        s = x.map(r(t) ? i : e, function (t, e) {
                            return [
                                [e, t]
                            ]
                        }).sort(function (t, e) {
                            return -(t[1].length - e[1].length)
                        });
                    if (x.each(s, function (t, e) {
                        var i = e[1];
                        return o.substr(u, i.length).toLowerCase() === i.toLowerCase() ? (n = e[0], u += i.length, !1) : void 0
                    }), -1 !== n) return n + 1;
                    throw "Unknown name at position " + u
                }

                function s() {
                    if (o.charAt(u) !== i.charAt(a)) throw "Unexpected literal at position " + u;
                    u++
                }
                var a, l, h, c, u = 0,
                    d = (t ? t.shortYearCutoff : null) || this._defaults.shortYearCutoff,
                    p = "string" != typeof d ? d : (new Date).getFullYear() % 100 + parseInt(d, 10),
                    f = (t ? t.dayNamesShort : null) || this._defaults.dayNamesShort,
                    g = (t ? t.dayNames : null) || this._defaults.dayNames,
                    m = (t ? t.monthNamesShort : null) || this._defaults.monthNamesShort,
                    v = (t ? t.monthNames : null) || this._defaults.monthNames,
                    _ = -1,
                    b = -1,
                    y = -1,
                    w = -1,
                    C = !1;
                for (a = 0; i.length > a; a++)
                    if (C) "'" !== i.charAt(a) || r("'") ? s() : C = !1;
                    else switch (i.charAt(a)) {
                        case "d":
                            y = e("d");
                            break;
                        case "D":
                            n("D", f, g);
                            break;
                        case "o":
                            w = e("o");
                            break;
                        case "m":
                            b = e("m");
                            break;
                        case "M":
                            b = n("M", m, v);
                            break;
                        case "y":
                            _ = e("y");
                            break;
                        case "@":
                            _ = (c = new Date(e("@"))).getFullYear(), b = c.getMonth() + 1, y = c.getDate();
                            break;
                        case "!":
                            _ = (c = new Date((e("!") - this._ticksTo1970) / 1e4)).getFullYear(), b = c.getMonth() + 1, y = c.getDate();
                            break;
                        case "'":
                            r("'") ? s() : C = !0;
                            break;
                        default:
                            s()
                    }
                if (o.length > u && (h = o.substr(u), !/^\s+/.test(h))) throw "Extra/unparsed characters found in date: " + h;
                if (-1 === _ ? _ = (new Date).getFullYear() : _ < 100 && (_ += (new Date).getFullYear() - (new Date).getFullYear() % 100 + (_ <= p ? 0 : -100)), -1 < w)
                    for (b = 1, y = w; !(y <= (l = this._getDaysInMonth(_, b - 1)));) b++ , y -= l;
                if ((c = this._daylightSavingAdjust(new Date(_, b - 1, y))).getFullYear() !== _ || c.getMonth() + 1 !== b || c.getDate() !== y) throw "Invalid date";
                return c
            },
            ATOM: "yy-mm-dd",
            COOKIE: "D, dd M yy",
            ISO_8601: "yy-mm-dd",
            RFC_822: "D, d M y",
            RFC_850: "DD, dd-M-y",
            RFC_1036: "D, d M y",
            RFC_1123: "D, d M yy",
            RFC_2822: "D, d M yy",
            RSS: "D, d M y",
            TICKS: "!",
            TIMESTAMP: "@",
            W3C: "yy-mm-dd",
            _ticksTo1970: 864e9 * (718685 + Math.floor(492.5) - Math.floor(19.7) + Math.floor(4.925)),
            formatDate: function (i, t, e) {
                if (!t) return "";

                function s(t) {
                    var e = i.length > r + 1 && i.charAt(r + 1) === t;
                    return e && r++ , e
                }

                function n(t, e, i) {
                    var n = "" + e;
                    if (s(t))
                        for (; i > n.length;) n = "0" + n;
                    return n
                }

                function o(t, e, i, n) {
                    return s(t) ? n[e] : i[e]
                }
                var r, a = (e ? e.dayNamesShort : null) || this._defaults.dayNamesShort,
                    l = (e ? e.dayNames : null) || this._defaults.dayNames,
                    h = (e ? e.monthNamesShort : null) || this._defaults.monthNamesShort,
                    c = (e ? e.monthNames : null) || this._defaults.monthNames,
                    u = "",
                    d = !1;
                if (t)
                    for (r = 0; i.length > r; r++)
                        if (d) "'" !== i.charAt(r) || s("'") ? u += i.charAt(r) : d = !1;
                        else switch (i.charAt(r)) {
                            case "d":
                                u += n("d", t.getDate(), 2);
                                break;
                            case "D":
                                u += o("D", t.getDay(), a, l);
                                break;
                            case "o":
                                u += n("o", Math.round((new Date(t.getFullYear(), t.getMonth(), t.getDate()).getTime() - new Date(t.getFullYear(), 0, 0).getTime()) / 864e5), 3);
                                break;
                            case "m":
                                u += n("m", t.getMonth() + 1, 2);
                                break;
                            case "M":
                                u += o("M", t.getMonth(), h, c);
                                break;
                            case "y":
                                u += s("y") ? t.getFullYear() : (t.getFullYear() % 100 < 10 ? "0" : "") + t.getFullYear() % 100;
                                break;
                            case "@":
                                u += t.getTime();
                                break;
                            case "!":
                                u += 1e4 * t.getTime() + this._ticksTo1970;
                                break;
                            case "'":
                                s("'") ? u += "'" : d = !0;
                                break;
                            default:
                                u += i.charAt(r)
                        }
                return u
            },
            _possibleChars: function (i) {
                function t(t) {
                    var e = i.length > n + 1 && i.charAt(n + 1) === t;
                    return e && n++ , e
                }
                var n, e = "",
                    s = !1;
                for (n = 0; i.length > n; n++)
                    if (s) "'" !== i.charAt(n) || t("'") ? e += i.charAt(n) : s = !1;
                    else switch (i.charAt(n)) {
                        case "d":
                        case "m":
                        case "y":
                        case "@":
                            e += "0123456789";
                            break;
                        case "D":
                        case "M":
                            return null;
                        case "'":
                            t("'") ? e += "'" : s = !0;
                            break;
                        default:
                            e += i.charAt(n)
                    }
                return e
            },
            _get: function (t, e) {
                return void 0 !== t.settings[e] ? t.settings[e] : this._defaults[e]
            },
            _setDateFromField: function (t, e) {
                if (t.input.val() !== t.lastVal) {
                    var i = this._get(t, "dateFormat"),
                        n = t.lastVal = t.input ? t.input.val() : null,
                        s = this._getDefaultDate(t),
                        o = s,
                        r = this._getFormatConfig(t);
                    try {
                        o = this.parseDate(i, n, r) || s
                    } catch (t) {
                        n = e ? "" : n
                    }
                    t.selectedDay = o.getDate(), t.drawMonth = t.selectedMonth = o.getMonth(), t.drawYear = t.selectedYear = o.getFullYear(), t.currentDay = n ? o.getDate() : 0, t.currentMonth = n ? o.getMonth() : 0, t.currentYear = n ? o.getFullYear() : 0, this._adjustInstDate(t)
                }
            },
            _getDefaultDate: function (t) {
                return this._restrictMinMax(t, this._determineDate(t, this._get(t, "defaultDate"), new Date))
            },
            _determineDate: function (a, t, e) {
                var i, n, s = null == t || "" === t ? e : "string" == typeof t ? function (t) {
                    try {
                        return x.datepicker.parseDate(x.datepicker._get(a, "dateFormat"), t, x.datepicker._getFormatConfig(a))
                    } catch (t) { }
                    for (var e = (t.toLowerCase().match(/^c/) ? x.datepicker._getDate(a) : null) || new Date, i = e.getFullYear(), n = e.getMonth(), s = e.getDate(), o = /([+\-]?[0-9]+)\s*(d|D|w|W|m|M|y|Y)?/g, r = o.exec(t); r;) {
                        switch (r[2] || "d") {
                            case "d":
                            case "D":
                                s += parseInt(r[1], 10);
                                break;
                            case "w":
                            case "W":
                                s += 7 * parseInt(r[1], 10);
                                break;
                            case "m":
                            case "M":
                                n += parseInt(r[1], 10), s = Math.min(s, x.datepicker._getDaysInMonth(i, n));
                                break;
                            case "y":
                            case "Y":
                                i += parseInt(r[1], 10), s = Math.min(s, x.datepicker._getDaysInMonth(i, n))
                        }
                        r = o.exec(t)
                    }
                    return new Date(i, n, s)
                }(t) : "number" == typeof t ? isNaN(t) ? e : (i = t, (n = new Date).setDate(n.getDate() + i), n) : new Date(t.getTime());
                return (s = s && "Invalid Date" == "" + s ? e : s) && (s.setHours(0), s.setMinutes(0), s.setSeconds(0), s.setMilliseconds(0)), this._daylightSavingAdjust(s)
            },
            _daylightSavingAdjust: function (t) {
                return t ? (t.setHours(12 < t.getHours() ? t.getHours() + 2 : 0), t) : null
            },
            _setDate: function (t, e, i) {
                var n = !e,
                    s = t.selectedMonth,
                    o = t.selectedYear,
                    r = this._restrictMinMax(t, this._determineDate(t, e, new Date));
                t.selectedDay = t.currentDay = r.getDate(), t.drawMonth = t.selectedMonth = t.currentMonth = r.getMonth(), t.drawYear = t.selectedYear = t.currentYear = r.getFullYear(), s === t.selectedMonth && o === t.selectedYear || i || this._notifyChange(t), this._adjustInstDate(t), t.input && t.input.val(n ? "" : this._formatDate(t))
            },
            _getDate: function (t) {
                return !t.currentYear || t.input && "" === t.input.val() ? null : this._daylightSavingAdjust(new Date(t.currentYear, t.currentMonth, t.currentDay))
            },
            _attachHandlers: function (t) {
                var e = this._get(t, "stepMonths"),
                    i = "#" + t.id.replace(/\\\\/g, "\\");
                t.dpDiv.find("[data-handler]").map(function () {
                    var t = {
                        prev: function () {
                            x.datepicker._adjustDate(i, -e, "M")
                        },
                        next: function () {
                            x.datepicker._adjustDate(i, +e, "M")
                        },
                        hide: function () {
                            x.datepicker._hideDatepicker()
                        },
                        today: function () {
                            x.datepicker._gotoToday(i)
                        },
                        selectDay: function () {
                            return x.datepicker._selectDay(i, +this.getAttribute("data-month"), +this.getAttribute("data-year"), this), !1
                        },
                        selectMonth: function () {
                            return x.datepicker._selectMonthYear(i, this, "M"), !1
                        },
                        selectYear: function () {
                            return x.datepicker._selectMonthYear(i, this, "Y"), !1
                        }
                    };
                    x(this).on(this.getAttribute("data-event"), t[this.getAttribute("data-handler")])
                })
            },
            _generateHTML: function (t) {
                var e, i, n, s, o, r, a, l, h, c, u, d, p, f, g, m, v, _, b, y, w, C, x, k, D, T, S, E, I, A, P, N, O, M, $, H, L, R, W, F = new Date,
                    j = this._daylightSavingAdjust(new Date(F.getFullYear(), F.getMonth(), F.getDate())),
                    z = this._get(t, "isRTL"),
                    q = this._get(t, "showButtonPanel"),
                    B = this._get(t, "hideIfNoPrevNext"),
                    U = this._get(t, "navigationAsDateFormat"),
                    Y = this._getNumberOfMonths(t),
                    K = this._get(t, "showCurrentAtPos"),
                    V = this._get(t, "stepMonths"),
                    X = 1 !== Y[0] || 1 !== Y[1],
                    Q = this._daylightSavingAdjust(t.currentDay ? new Date(t.currentYear, t.currentMonth, t.currentDay) : new Date(9999, 9, 9)),
                    G = this._getMinMaxDate(t, "min"),
                    J = this._getMinMaxDate(t, "max"),
                    Z = t.drawMonth - K,
                    tt = t.drawYear;
                if (Z < 0 && (Z += 12, tt--), J)
                    for (e = this._daylightSavingAdjust(new Date(J.getFullYear(), J.getMonth() - Y[0] * Y[1] + 1, J.getDate())), e = G && e < G ? G : e; this._daylightSavingAdjust(new Date(tt, Z, 1)) > e;)--Z < 0 && (Z = 11, tt--);
                for (t.drawMonth = Z, t.drawYear = tt, i = this._get(t, "prevText"), i = U ? this.formatDate(i, this._daylightSavingAdjust(new Date(tt, Z - V, 1)), this._getFormatConfig(t)) : i, n = this._canAdjustMonth(t, -1, tt, Z) ? "<a class='ui-datepicker-prev ui-corner-all' data-handler='prev' data-event='click' title='" + i + "'><span class='ui-icon ui-icon-circle-triangle-" + (z ? "e" : "w") + "'>" + i + "</span></a>" : B ? "" : "<a class='ui-datepicker-prev ui-corner-all ui-state-disabled' title='" + i + "'><span class='ui-icon ui-icon-circle-triangle-" + (z ? "e" : "w") + "'>" + i + "</span></a>", s = this._get(t, "nextText"), s = U ? this.formatDate(s, this._daylightSavingAdjust(new Date(tt, Z + V, 1)), this._getFormatConfig(t)) : s, o = this._canAdjustMonth(t, 1, tt, Z) ? "<a class='ui-datepicker-next ui-corner-all' data-handler='next' data-event='click' title='" + s + "'><span class='ui-icon ui-icon-circle-triangle-" + (z ? "w" : "e") + "'>" + s + "</span></a>" : B ? "" : "<a class='ui-datepicker-next ui-corner-all ui-state-disabled' title='" + s + "'><span class='ui-icon ui-icon-circle-triangle-" + (z ? "w" : "e") + "'>" + s + "</span></a>", r = this._get(t, "currentText"), a = this._get(t, "gotoCurrent") && t.currentDay ? Q : j, r = U ? this.formatDate(r, a, this._getFormatConfig(t)) : r, l = t.inline ? "" : "<button type='button' class='ui-datepicker-close ui-state-default ui-priority-primary ui-corner-all' data-handler='hide' data-event='click'>" + this._get(t, "closeText") + "</button>", h = q ? "<div class='ui-datepicker-buttonpane ui-widget-content'>" + (z ? l : "") + (this._isInRange(t, a) ? "<button type='button' class='ui-datepicker-current ui-state-default ui-priority-secondary ui-corner-all' data-handler='today' data-event='click'>" + r + "</button>" : "") + (z ? "" : l) + "</div>" : "", c = parseInt(this._get(t, "firstDay"), 10), c = isNaN(c) ? 0 : c, u = this._get(t, "showWeek"), d = this._get(t, "dayNames"), p = this._get(t, "dayNamesMin"), f = this._get(t, "monthNames"), g = this._get(t, "monthNamesShort"), m = this._get(t, "beforeShowDay"), v = this._get(t, "showOtherMonths"), _ = this._get(t, "selectOtherMonths"), b = this._getDefaultDate(t), y = "", C = 0; Y[0] > C; C++) {
                    for (x = "", this.maxRows = 4, k = 0; Y[1] > k; k++) {
                        if (D = this._daylightSavingAdjust(new Date(tt, Z, t.selectedDay)), T = " ui-corner-all", S = "", X) {
                            if (S += "<div class='ui-datepicker-group", 1 < Y[1]) switch (k) {
                                case 0:
                                    S += " ui-datepicker-group-first", T = " ui-corner-" + (z ? "right" : "left");
                                    break;
                                case Y[1] - 1:
                                    S += " ui-datepicker-group-last", T = " ui-corner-" + (z ? "left" : "right");
                                    break;
                                default:
                                    S += " ui-datepicker-group-middle", T = ""
                            }
                            S += "'>"
                        }
                        for (S += "<div class='ui-datepicker-header ui-widget-header ui-helper-clearfix" + T + "'>" + (/all|left/.test(T) && 0 === C ? z ? o : n : "") + (/all|right/.test(T) && 0 === C ? z ? n : o : "") + this._generateMonthYearHeader(t, Z, tt, G, J, 0 < C || 0 < k, f, g) + "</div><table class='ui-datepicker-calendar'><thead><tr>", E = u ? "<th class='ui-datepicker-week-col'>" + this._get(t, "weekHeader") + "</th>" : "", w = 0; w < 7; w++) E += "<th scope='col'" + (5 <= (w + c + 6) % 7 ? " class='ui-datepicker-week-end'" : "") + "><span title='" + d[I = (w + c) % 7] + "'>" + p[I] + "</span></th>";
                        for (S += E + "</tr></thead><tbody>", A = this._getDaysInMonth(tt, Z), tt === t.selectedYear && Z === t.selectedMonth && (t.selectedDay = Math.min(t.selectedDay, A)), P = (this._getFirstDayOfMonth(tt, Z) - c + 7) % 7, N = Math.ceil((P + A) / 7), O = X && this.maxRows > N ? this.maxRows : N, this.maxRows = O, M = this._daylightSavingAdjust(new Date(tt, Z, 1 - P)), $ = 0; $ < O; $++) {
                            for (S += "<tr>", H = u ? "<td class='ui-datepicker-week-col'>" + this._get(t, "calculateWeek")(M) + "</td>" : "", w = 0; w < 7; w++) L = m ? m.apply(t.input ? t.input[0] : null, [M]) : [!0, ""], W = (R = M.getMonth() !== Z) && !_ || !L[0] || G && M < G || J && J < M, H += "<td class='" + (5 <= (w + c + 6) % 7 ? " ui-datepicker-week-end" : "") + (R ? " ui-datepicker-other-month" : "") + (M.getTime() === D.getTime() && Z === t.selectedMonth && t._keyEvent || b.getTime() === M.getTime() && b.getTime() === D.getTime() ? " " + this._dayOverClass : "") + (W ? " " + this._unselectableClass + " ui-state-disabled" : "") + (R && !v ? "" : " " + L[1] + (M.getTime() === Q.getTime() ? " " + this._currentClass : "") + (M.getTime() === j.getTime() ? " ui-datepicker-today" : "")) + "'" + (R && !v || !L[2] ? "" : " title='" + L[2].replace(/'/g, "&#39;") + "'") + (W ? "" : " data-handler='selectDay' data-event='click' data-month='" + M.getMonth() + "' data-year='" + M.getFullYear() + "'") + ">" + (R && !v ? "&#xa0;" : W ? "<span class='ui-state-default'>" + M.getDate() + "</span>" : "<a class='ui-state-default" + (M.getTime() === j.getTime() ? " ui-state-highlight" : "") + (M.getTime() === Q.getTime() ? " ui-state-active" : "") + (R ? " ui-priority-secondary" : "") + "' href='#'>" + M.getDate() + "</a>") + "</td>", M.setDate(M.getDate() + 1), M = this._daylightSavingAdjust(M);
                            S += H + "</tr>"
                        }
                        11 < ++Z && (Z = 0, tt++), x += S += "</tbody></table>" + (X ? "</div>" + (0 < Y[0] && k === Y[1] - 1 ? "<div class='ui-datepicker-row-break'></div>" : "") : "")
                    }
                    y += x
                }
                return y += h, t._keyEvent = !1, y
            },
            _generateMonthYearHeader: function (t, e, i, n, s, o, r, a) {
                var l, h, c, u, d, p, f, g, m = this._get(t, "changeMonth"),
                    v = this._get(t, "changeYear"),
                    _ = this._get(t, "showMonthAfterYear"),
                    b = "<div class='ui-datepicker-title'>",
                    y = "";
                if (o || !m) y += "<span class='ui-datepicker-month'>" + r[e] + "</span>";
                else {
                    for (l = n && n.getFullYear() === i, h = s && s.getFullYear() === i, y += "<select class='ui-datepicker-month' data-handler='selectMonth' data-event='change'>", c = 0; c < 12; c++)(!l || c >= n.getMonth()) && (!h || s.getMonth() >= c) && (y += "<option value='" + c + "'" + (c === e ? " selected='selected'" : "") + ">" + a[c] + "</option>");
                    y += "</select>"
                }
                if (_ || (b += y + (!o && m && v ? "" : "&#xa0;")), !t.yearshtml)
                    if (t.yearshtml = "", o || !v) b += "<span class='ui-datepicker-year'>" + i + "</span>";
                    else {
                        for (u = this._get(t, "yearRange").split(":"), d = (new Date).getFullYear(), f = (p = function (t) {
                            var e = t.match(/c[+\-].*/) ? i + parseInt(t.substring(1), 10) : t.match(/[+\-].*/) ? d + parseInt(t, 10) : parseInt(t, 10);
                            return isNaN(e) ? d : e
                        })(u[0]), g = Math.max(f, p(u[1] || "")), f = n ? Math.max(f, n.getFullYear()) : f, g = s ? Math.min(g, s.getFullYear()) : g, t.yearshtml += "<select class='ui-datepicker-year' data-handler='selectYear' data-event='change'>"; f <= g; f++) t.yearshtml += "<option value='" + f + "'" + (f === i ? " selected='selected'" : "") + ">" + f + "</option>";
                        t.yearshtml += "</select>", b += t.yearshtml, t.yearshtml = null
                    }
                return b += this._get(t, "yearSuffix"), _ && (b += (!o && m && v ? "" : "&#xa0;") + y), b + "</div>"
            },
            _adjustInstDate: function (t, e, i) {
                var n = t.selectedYear + ("Y" === i ? e : 0),
                    s = t.selectedMonth + ("M" === i ? e : 0),
                    o = Math.min(t.selectedDay, this._getDaysInMonth(n, s)) + ("D" === i ? e : 0),
                    r = this._restrictMinMax(t, this._daylightSavingAdjust(new Date(n, s, o)));
                t.selectedDay = r.getDate(), t.drawMonth = t.selectedMonth = r.getMonth(), t.drawYear = t.selectedYear = r.getFullYear(), "M" !== i && "Y" !== i || this._notifyChange(t)
            },
            _restrictMinMax: function (t, e) {
                var i = this._getMinMaxDate(t, "min"),
                    n = this._getMinMaxDate(t, "max"),
                    s = i && e < i ? i : e;
                return n && n < s ? n : s
            },
            _notifyChange: function (t) {
                var e = this._get(t, "onChangeMonthYear");
                e && e.apply(t.input ? t.input[0] : null, [t.selectedYear, t.selectedMonth + 1, t])
            },
            _getNumberOfMonths: function (t) {
                var e = this._get(t, "numberOfMonths");
                return null == e ? [1, 1] : "number" == typeof e ? [1, e] : e
            },
            _getMinMaxDate: function (t, e) {
                return this._determineDate(t, this._get(t, e + "Date"), null)
            },
            _getDaysInMonth: function (t, e) {
                return 32 - this._daylightSavingAdjust(new Date(t, e, 32)).getDate()
            },
            _getFirstDayOfMonth: function (t, e) {
                return new Date(t, e, 1).getDay()
            },
            _canAdjustMonth: function (t, e, i, n) {
                var s = this._getNumberOfMonths(t),
                    o = this._daylightSavingAdjust(new Date(i, n + (e < 0 ? e : s[0] * s[1]), 1));
                return e < 0 && o.setDate(this._getDaysInMonth(o.getFullYear(), o.getMonth())), this._isInRange(t, o)
            },
            _isInRange: function (t, e) {
                var i, n, s = this._getMinMaxDate(t, "min"),
                    o = this._getMinMaxDate(t, "max"),
                    r = null,
                    a = null,
                    l = this._get(t, "yearRange");
                return l && (i = l.split(":"), n = (new Date).getFullYear(), r = parseInt(i[0], 10), a = parseInt(i[1], 10), i[0].match(/[+\-].*/) && (r += n), i[1].match(/[+\-].*/) && (a += n)), (!s || e.getTime() >= s.getTime()) && (!o || e.getTime() <= o.getTime()) && (!r || e.getFullYear() >= r) && (!a || a >= e.getFullYear())
            },
            _getFormatConfig: function (t) {
                var e = this._get(t, "shortYearCutoff");
                return {
                    shortYearCutoff: e = "string" != typeof e ? e : (new Date).getFullYear() % 100 + parseInt(e, 10),
                    dayNamesShort: this._get(t, "dayNamesShort"),
                    dayNames: this._get(t, "dayNames"),
                    monthNamesShort: this._get(t, "monthNamesShort"),
                    monthNames: this._get(t, "monthNames")
                }
            },
            _formatDate: function (t, e, i, n) {
                e || (t.currentDay = t.selectedDay, t.currentMonth = t.selectedMonth, t.currentYear = t.selectedYear);
                var s = e ? "object" == typeof e ? e : this._daylightSavingAdjust(new Date(n, i, e)) : this._daylightSavingAdjust(new Date(t.currentYear, t.currentMonth, t.currentDay));
                return this.formatDate(this._get(t, "dateFormat"), s, this._getFormatConfig(t))
            }
        }), x.fn.datepicker = function (t) {
            if (!this.length) return this;
            x.datepicker.initialized || (x(document).on("mousedown", x.datepicker._checkExternalClick), x.datepicker.initialized = !0), 0 === x("#" + x.datepicker._mainDivId).length && x("body").append(x.datepicker.dpDiv);
            var e = Array.prototype.slice.call(arguments, 1);
            return "string" != typeof t || "isDisabled" !== t && "getDate" !== t && "widget" !== t ? "option" === t && 2 === arguments.length && "string" == typeof arguments[1] ? x.datepicker["_" + t + "Datepicker"].apply(x.datepicker, [this[0]].concat(e)) : this.each(function () {
                "string" == typeof t ? x.datepicker["_" + t + "Datepicker"].apply(x.datepicker, [this].concat(e)) : x.datepicker._attachDatepicker(this, t)
            }) : x.datepicker["_" + t + "Datepicker"].apply(x.datepicker, [this[0]].concat(e))
        }, x.datepicker = new t, x.datepicker.initialized = !1, x.datepicker.uuid = (new Date).getTime(), x.datepicker.version = "1.12.1", x.datepicker, x.ui.ie = !!/msie [\w.]+/.exec(navigator.userAgent.toLowerCase());
        var st = !1;
        x(document).on("mouseup", function () {
            st = !1
        }), x.widget("ui.mouse", {
            version: "1.12.1",
            options: {
                cancel: "input, textarea, button, select, option",
                distance: 1,
                delay: 0
            },
            _mouseInit: function () {
                var e = this;
                this.element.on("mousedown." + this.widgetName, function (t) {
                    return e._mouseDown(t)
                }).on("click." + this.widgetName, function (t) {
                    return !0 === x.data(t.target, e.widgetName + ".preventClickEvent") ? (x.removeData(t.target, e.widgetName + ".preventClickEvent"), t.stopImmediatePropagation(), !1) : void 0
                }), this.started = !1
            },
            _mouseDestroy: function () {
                this.element.off("." + this.widgetName), this._mouseMoveDelegate && this.document.off("mousemove." + this.widgetName, this._mouseMoveDelegate).off("mouseup." + this.widgetName, this._mouseUpDelegate)
            },
            _mouseDown: function (t) {
                if (!st) {
                    this._mouseMoved = !1, this._mouseStarted && this._mouseUp(t), this._mouseDownEvent = t;
                    var e = this,
                        i = 1 === t.which,
                        n = !("string" != typeof this.options.cancel || !t.target.nodeName) && x(t.target).closest(this.options.cancel).length;
                    return i && !n && this._mouseCapture(t) && (this.mouseDelayMet = !this.options.delay, this.mouseDelayMet || (this._mouseDelayTimer = setTimeout(function () {
                        e.mouseDelayMet = !0
                    }, this.options.delay)), this._mouseDistanceMet(t) && this._mouseDelayMet(t) && (this._mouseStarted = !1 !== this._mouseStart(t), !this._mouseStarted) ? t.preventDefault() : (!0 === x.data(t.target, this.widgetName + ".preventClickEvent") && x.removeData(t.target, this.widgetName + ".preventClickEvent"), this._mouseMoveDelegate = function (t) {
                        return e._mouseMove(t)
                    }, this._mouseUpDelegate = function (t) {
                        return e._mouseUp(t)
                    }, this.document.on("mousemove." + this.widgetName, this._mouseMoveDelegate).on("mouseup." + this.widgetName, this._mouseUpDelegate), t.preventDefault(), st = !0)), !0
                }
            },
            _mouseMove: function (t) {
                if (this._mouseMoved) {
                    if (x.ui.ie && (!document.documentMode || document.documentMode < 9) && !t.button) return this._mouseUp(t);
                    if (!t.which)
                        if (t.originalEvent.altKey || t.originalEvent.ctrlKey || t.originalEvent.metaKey || t.originalEvent.shiftKey) this.ignoreMissingWhich = !0;
                        else if (!this.ignoreMissingWhich) return this._mouseUp(t)
                }
                return (t.which || t.button) && (this._mouseMoved = !0), this._mouseStarted ? (this._mouseDrag(t), t.preventDefault()) : (this._mouseDistanceMet(t) && this._mouseDelayMet(t) && (this._mouseStarted = !1 !== this._mouseStart(this._mouseDownEvent, t), this._mouseStarted ? this._mouseDrag(t) : this._mouseUp(t)), !this._mouseStarted)
            },
            _mouseUp: function (t) {
                this.document.off("mousemove." + this.widgetName, this._mouseMoveDelegate).off("mouseup." + this.widgetName, this._mouseUpDelegate), this._mouseStarted && (this._mouseStarted = !1, t.target === this._mouseDownEvent.target && x.data(t.target, this.widgetName + ".preventClickEvent", !0), this._mouseStop(t)), this._mouseDelayTimer && (clearTimeout(this._mouseDelayTimer), delete this._mouseDelayTimer), this.ignoreMissingWhich = !1, st = !1, t.preventDefault()
            },
            _mouseDistanceMet: function (t) {
                return Math.max(Math.abs(this._mouseDownEvent.pageX - t.pageX), Math.abs(this._mouseDownEvent.pageY - t.pageY)) >= this.options.distance
            },
            _mouseDelayMet: function () {
                return this.mouseDelayMet
            },
            _mouseStart: function () { },
            _mouseDrag: function () { },
            _mouseStop: function () { },
            _mouseCapture: function () {
                return !0
            }
        }), x.ui.plugin = {
            add: function (t, e, i) {
                var n, s = x.ui[t].prototype;
                for (n in i) s.plugins[n] = s.plugins[n] || [], s.plugins[n].push([e, i[n]])
            },
            call: function (t, e, i, n) {
                var s, o = t.plugins[e];
                if (o && (n || t.element[0].parentNode && 11 !== t.element[0].parentNode.nodeType))
                    for (s = 0; o.length > s; s++) t.options[o[s][0]] && o[s][1].apply(t.element, i)
            }
        }, x.ui.safeBlur = function (t) {
            t && "body" !== t.nodeName.toLowerCase() && x(t).trigger("blur")
        }, x.widget("ui.draggable", x.ui.mouse, {
            version: "1.12.1",
            widgetEventPrefix: "drag",
            options: {
                addClasses: !0,
                appendTo: "parent",
                axis: !1,
                connectToSortable: !1,
                containment: !1,
                cursor: "auto",
                cursorAt: !1,
                grid: !1,
                handle: !1,
                helper: "original",
                iframeFix: !1,
                opacity: !1,
                refreshPositions: !1,
                revert: !1,
                revertDuration: 500,
                scope: "default",
                scroll: !0,
                scrollSensitivity: 20,
                scrollSpeed: 20,
                snap: !1,
                snapMode: "both",
                snapTolerance: 20,
                stack: !1,
                zIndex: !1,
                drag: null,
                start: null,
                stop: null
            },
            _create: function () {
                "original" === this.options.helper && this._setPositionRelative(), this.options.addClasses && this._addClass("ui-draggable"), this._setHandleClassName(), this._mouseInit()
            },
            _setOption: function (t, e) {
                this._super(t, e), "handle" === t && (this._removeHandleClassName(), this._setHandleClassName())
            },
            _destroy: function () {
                return (this.helper || this.element).is(".ui-draggable-dragging") ? void (this.destroyOnClear = !0) : (this._removeHandleClassName(), void this._mouseDestroy())
            },
            _mouseCapture: function (t) {
                var e = this.options;
                return !(this.helper || e.disabled || 0 < x(t.target).closest(".ui-resizable-handle").length) && (this.handle = this._getHandle(t), !!this.handle && (this._blurActiveElement(t), this._blockFrames(!0 === e.iframeFix ? "iframe" : e.iframeFix), !0))
            },
            _blockFrames: function (t) {
                this.iframeBlocks = this.document.find(t).map(function () {
                    var t = x(this);
                    return x("<div>").css("position", "absolute").appendTo(t.parent()).outerWidth(t.outerWidth()).outerHeight(t.outerHeight()).offset(t.offset())[0]
                })
            },
            _unblockFrames: function () {
                this.iframeBlocks && (this.iframeBlocks.remove(), delete this.iframeBlocks)
            },
            _blurActiveElement: function (t) {
                var e = x.ui.safeActiveElement(this.document[0]);
                x(t.target).closest(e).length || x.ui.safeBlur(e)
            },
            _mouseStart: function (t) {
                var e = this.options;
                return this.helper = this._createHelper(t), this._addClass(this.helper, "ui-draggable-dragging"), this._cacheHelperProportions(), x.ui.ddmanager && (x.ui.ddmanager.current = this), this._cacheMargins(), this.cssPosition = this.helper.css("position"), this.scrollParent = this.helper.scrollParent(!0), this.offsetParent = this.helper.offsetParent(), this.hasFixedAncestor = 0 < this.helper.parents().filter(function () {
                    return "fixed" === x(this).css("position")
                }).length, this.positionAbs = this.element.offset(), this._refreshOffsets(t), this.originalPosition = this.position = this._generatePosition(t, !1), this.originalPageX = t.pageX, this.originalPageY = t.pageY, e.cursorAt && this._adjustOffsetFromHelper(e.cursorAt), this._setContainment(), !1 === this._trigger("start", t) ? (this._clear(), !1) : (this._cacheHelperProportions(), x.ui.ddmanager && !e.dropBehaviour && x.ui.ddmanager.prepareOffsets(this, t), this._mouseDrag(t, !0), x.ui.ddmanager && x.ui.ddmanager.dragStart(this, t), !0)
            },
            _refreshOffsets: function (t) {
                this.offset = {
                    top: this.positionAbs.top - this.margins.top,
                    left: this.positionAbs.left - this.margins.left,
                    scroll: !1,
                    parent: this._getParentOffset(),
                    relative: this._getRelativeOffset()
                }, this.offset.click = {
                    left: t.pageX - this.offset.left,
                    top: t.pageY - this.offset.top
                }
            },
            _mouseDrag: function (t, e) {
                if (this.hasFixedAncestor && (this.offset.parent = this._getParentOffset()), this.position = this._generatePosition(t, !0), this.positionAbs = this._convertPositionTo("absolute"), !e) {
                    var i = this._uiHash();
                    if (!1 === this._trigger("drag", t, i)) return this._mouseUp(new x.Event("mouseup", t)), !1;
                    this.position = i.position
                }
                return this.helper[0].style.left = this.position.left + "px", this.helper[0].style.top = this.position.top + "px", x.ui.ddmanager && x.ui.ddmanager.drag(this, t), !1
            },
            _mouseStop: function (t) {
                var e = this,
                    i = !1;
                return x.ui.ddmanager && !this.options.dropBehaviour && (i = x.ui.ddmanager.drop(this, t)), this.dropped && (i = this.dropped, this.dropped = !1), "invalid" === this.options.revert && !i || "valid" === this.options.revert && i || !0 === this.options.revert || x.isFunction(this.options.revert) && this.options.revert.call(this.element, i) ? x(this.helper).animate(this.originalPosition, parseInt(this.options.revertDuration, 10), function () {
                    !1 !== e._trigger("stop", t) && e._clear()
                }) : !1 !== this._trigger("stop", t) && this._clear(), !1
            },
            _mouseUp: function (t) {
                return this._unblockFrames(), x.ui.ddmanager && x.ui.ddmanager.dragStop(this, t), this.handleElement.is(t.target) && this.element.trigger("focus"), x.ui.mouse.prototype._mouseUp.call(this, t)
            },
            cancel: function () {
                return this.helper.is(".ui-draggable-dragging") ? this._mouseUp(new x.Event("mouseup", {
                    target: this.element[0]
                })) : this._clear(), this
            },
            _getHandle: function (t) {
                return !this.options.handle || !!x(t.target).closest(this.element.find(this.options.handle)).length
            },
            _setHandleClassName: function () {
                this.handleElement = this.options.handle ? this.element.find(this.options.handle) : this.element, this._addClass(this.handleElement, "ui-draggable-handle")
            },
            _removeHandleClassName: function () {
                this._removeClass(this.handleElement, "ui-draggable-handle")
            },
            _createHelper: function (t) {
                var e = this.options,
                    i = x.isFunction(e.helper),
                    n = i ? x(e.helper.apply(this.element[0], [t])) : "clone" === e.helper ? this.element.clone().removeAttr("id") : this.element;
                return n.parents("body").length || n.appendTo("parent" === e.appendTo ? this.element[0].parentNode : e.appendTo), i && n[0] === this.element[0] && this._setPositionRelative(), n[0] === this.element[0] || /(fixed|absolute)/.test(n.css("position")) || n.css("position", "absolute"), n
            },
            _setPositionRelative: function () {
                /^(?:r|a|f)/.test(this.element.css("position")) || (this.element[0].style.position = "relative")
            },
            _adjustOffsetFromHelper: function (t) {
                "string" == typeof t && (t = t.split(" ")), x.isArray(t) && (t = {
                    left: +t[0],
                    top: +t[1] || 0
                }), "left" in t && (this.offset.click.left = t.left + this.margins.left), "right" in t && (this.offset.click.left = this.helperProportions.width - t.right + this.margins.left), "top" in t && (this.offset.click.top = t.top + this.margins.top), "bottom" in t && (this.offset.click.top = this.helperProportions.height - t.bottom + this.margins.top)
            },
            _isRootNode: function (t) {
                return /(html|body)/i.test(t.tagName) || t === this.document[0]
            },
            _getParentOffset: function () {
                var t = this.offsetParent.offset(),
                    e = this.document[0];
                return "absolute" === this.cssPosition && this.scrollParent[0] !== e && x.contains(this.scrollParent[0], this.offsetParent[0]) && (t.left += this.scrollParent.scrollLeft(), t.top += this.scrollParent.scrollTop()), this._isRootNode(this.offsetParent[0]) && (t = {
                    top: 0,
                    left: 0
                }), {
                    top: t.top + (parseInt(this.offsetParent.css("borderTopWidth"), 10) || 0),
                    left: t.left + (parseInt(this.offsetParent.css("borderLeftWidth"), 10) || 0)
                }
            },
            _getRelativeOffset: function () {
                if ("relative" !== this.cssPosition) return {
                    top: 0,
                    left: 0
                };
                var t = this.element.position(),
                    e = this._isRootNode(this.scrollParent[0]);
                return {
                    top: t.top - (parseInt(this.helper.css("top"), 10) || 0) + (e ? 0 : this.scrollParent.scrollTop()),
                    left: t.left - (parseInt(this.helper.css("left"), 10) || 0) + (e ? 0 : this.scrollParent.scrollLeft())
                }
            },
            _cacheMargins: function () {
                this.margins = {
                    left: parseInt(this.element.css("marginLeft"), 10) || 0,
                    top: parseInt(this.element.css("marginTop"), 10) || 0,
                    right: parseInt(this.element.css("marginRight"), 10) || 0,
                    bottom: parseInt(this.element.css("marginBottom"), 10) || 0
                }
            },
            _cacheHelperProportions: function () {
                this.helperProportions = {
                    width: this.helper.outerWidth(),
                    height: this.helper.outerHeight()
                }
            },
            _setContainment: function () {
                var t, e, i, n = this.options,
                    s = this.document[0];
                return this.relativeContainer = null, n.containment ? "window" === n.containment ? void (this.containment = [x(window).scrollLeft() - this.offset.relative.left - this.offset.parent.left, x(window).scrollTop() - this.offset.relative.top - this.offset.parent.top, x(window).scrollLeft() + x(window).width() - this.helperProportions.width - this.margins.left, x(window).scrollTop() + (x(window).height() || s.body.parentNode.scrollHeight) - this.helperProportions.height - this.margins.top]) : "document" === n.containment ? void (this.containment = [0, 0, x(s).width() - this.helperProportions.width - this.margins.left, (x(s).height() || s.body.parentNode.scrollHeight) - this.helperProportions.height - this.margins.top]) : n.containment.constructor === Array ? void (this.containment = n.containment) : ("parent" === n.containment && (n.containment = this.helper[0].parentNode), void ((i = (e = x(n.containment))[0]) && (t = /(scroll|auto)/.test(e.css("overflow")), this.containment = [(parseInt(e.css("borderLeftWidth"), 10) || 0) + (parseInt(e.css("paddingLeft"), 10) || 0), (parseInt(e.css("borderTopWidth"), 10) || 0) + (parseInt(e.css("paddingTop"), 10) || 0), (t ? Math.max(i.scrollWidth, i.offsetWidth) : i.offsetWidth) - (parseInt(e.css("borderRightWidth"), 10) || 0) - (parseInt(e.css("paddingRight"), 10) || 0) - this.helperProportions.width - this.margins.left - this.margins.right, (t ? Math.max(i.scrollHeight, i.offsetHeight) : i.offsetHeight) - (parseInt(e.css("borderBottomWidth"), 10) || 0) - (parseInt(e.css("paddingBottom"), 10) || 0) - this.helperProportions.height - this.margins.top - this.margins.bottom], this.relativeContainer = e))) : void (this.containment = null)
            },
            _convertPositionTo: function (t, e) {
                e = e || this.position;
                var i = "absolute" === t ? 1 : -1,
                    n = this._isRootNode(this.scrollParent[0]);
                return {
                    top: e.top + this.offset.relative.top * i + this.offset.parent.top * i - ("fixed" === this.cssPosition ? -this.offset.scroll.top : n ? 0 : this.offset.scroll.top) * i,
                    left: e.left + this.offset.relative.left * i + this.offset.parent.left * i - ("fixed" === this.cssPosition ? -this.offset.scroll.left : n ? 0 : this.offset.scroll.left) * i
                }
            },
            _generatePosition: function (t, e) {
                var i, n, s, o, r = this.options,
                    a = this._isRootNode(this.scrollParent[0]),
                    l = t.pageX,
                    h = t.pageY;
                return a && this.offset.scroll || (this.offset.scroll = {
                    top: this.scrollParent.scrollTop(),
                    left: this.scrollParent.scrollLeft()
                }), e && (this.containment && (i = this.relativeContainer ? (n = this.relativeContainer.offset(), [this.containment[0] + n.left, this.containment[1] + n.top, this.containment[2] + n.left, this.containment[3] + n.top]) : this.containment, t.pageX - this.offset.click.left < i[0] && (l = i[0] + this.offset.click.left), t.pageY - this.offset.click.top < i[1] && (h = i[1] + this.offset.click.top), t.pageX - this.offset.click.left > i[2] && (l = i[2] + this.offset.click.left), t.pageY - this.offset.click.top > i[3] && (h = i[3] + this.offset.click.top)), r.grid && (s = r.grid[1] ? this.originalPageY + Math.round((h - this.originalPageY) / r.grid[1]) * r.grid[1] : this.originalPageY, h = i ? s - this.offset.click.top >= i[1] || s - this.offset.click.top > i[3] ? s : s - this.offset.click.top >= i[1] ? s - r.grid[1] : s + r.grid[1] : s, o = r.grid[0] ? this.originalPageX + Math.round((l - this.originalPageX) / r.grid[0]) * r.grid[0] : this.originalPageX, l = i ? o - this.offset.click.left >= i[0] || o - this.offset.click.left > i[2] ? o : o - this.offset.click.left >= i[0] ? o - r.grid[0] : o + r.grid[0] : o), "y" === r.axis && (l = this.originalPageX), "x" === r.axis && (h = this.originalPageY)), {
                    top: h - this.offset.click.top - this.offset.relative.top - this.offset.parent.top + ("fixed" === this.cssPosition ? -this.offset.scroll.top : a ? 0 : this.offset.scroll.top),
                    left: l - this.offset.click.left - this.offset.relative.left - this.offset.parent.left + ("fixed" === this.cssPosition ? -this.offset.scroll.left : a ? 0 : this.offset.scroll.left)
                }
            },
            _clear: function () {
                this._removeClass(this.helper, "ui-draggable-dragging"), this.helper[0] === this.element[0] || this.cancelHelperRemoval || this.helper.remove(), this.helper = null, this.cancelHelperRemoval = !1, this.destroyOnClear && this.destroy()
            },
            _trigger: function (t, e, i) {
                return i = i || this._uiHash(), x.ui.plugin.call(this, t, [e, i, this], !0), /^(drag|start|stop)/.test(t) && (this.positionAbs = this._convertPositionTo("absolute"), i.offset = this.positionAbs), x.Widget.prototype._trigger.call(this, t, e, i)
            },
            plugins: {},
            _uiHash: function () {
                return {
                    helper: this.helper,
                    position: this.position,
                    originalPosition: this.originalPosition,
                    offset: this.positionAbs
                }
            }
        }), x.ui.plugin.add("draggable", "connectToSortable", {
            start: function (e, t, i) {
                var n = x.extend({}, t, {
                    item: i.element
                });
                i.sortables = [], x(i.options.connectToSortable).each(function () {
                    var t = x(this).sortable("instance");
                    t && !t.options.disabled && (i.sortables.push(t), t.refreshPositions(), t._trigger("activate", e, n))
                })
            },
            stop: function (e, t, i) {
                var n = x.extend({}, t, {
                    item: i.element
                });
                i.cancelHelperRemoval = !1, x.each(i.sortables, function () {
                    var t = this;
                    t.isOver ? (t.isOver = 0, i.cancelHelperRemoval = !0, t.cancelHelperRemoval = !1, t._storedCSS = {
                        position: t.placeholder.css("position"),
                        top: t.placeholder.css("top"),
                        left: t.placeholder.css("left")
                    }, t._mouseStop(e), t.options.helper = t.options._helper) : (t.cancelHelperRemoval = !0, t._trigger("deactivate", e, n))
                })
            },
            drag: function (i, n, s) {
                x.each(s.sortables, function () {
                    var t = !1,
                        e = this;
                    e.positionAbs = s.positionAbs, e.helperProportions = s.helperProportions, e.offset.click = s.offset.click, e._intersectsWith(e.containerCache) && (t = !0, x.each(s.sortables, function () {
                        return this.positionAbs = s.positionAbs, this.helperProportions = s.helperProportions, this.offset.click = s.offset.click, this !== e && this._intersectsWith(this.containerCache) && x.contains(e.element[0], this.element[0]) && (t = !1), t
                    })), t ? (e.isOver || (e.isOver = 1, s._parent = n.helper.parent(), e.currentItem = n.helper.appendTo(e.element).data("ui-sortable-item", !0), e.options._helper = e.options.helper, e.options.helper = function () {
                        return n.helper[0]
                    }, i.target = e.currentItem[0], e._mouseCapture(i, !0), e._mouseStart(i, !0, !0), e.offset.click.top = s.offset.click.top, e.offset.click.left = s.offset.click.left, e.offset.parent.left -= s.offset.parent.left - e.offset.parent.left, e.offset.parent.top -= s.offset.parent.top - e.offset.parent.top, s._trigger("toSortable", i), s.dropped = e.element, x.each(s.sortables, function () {
                        this.refreshPositions()
                    }), s.currentItem = s.element, e.fromOutside = s), e.currentItem && (e._mouseDrag(i), n.position = e.position)) : e.isOver && (e.isOver = 0, e.cancelHelperRemoval = !0, e.options._revert = e.options.revert, e.options.revert = !1, e._trigger("out", i, e._uiHash(e)), e._mouseStop(i, !0), e.options.revert = e.options._revert, e.options.helper = e.options._helper, e.placeholder && e.placeholder.remove(), n.helper.appendTo(s._parent), s._refreshOffsets(i), n.position = s._generatePosition(i, !0), s._trigger("fromSortable", i), s.dropped = !1, x.each(s.sortables, function () {
                        this.refreshPositions()
                    }))
                })
            }
        }), x.ui.plugin.add("draggable", "cursor", {
            start: function (t, e, i) {
                var n = x("body"),
                    s = i.options;
                n.css("cursor") && (s._cursor = n.css("cursor")), n.css("cursor", s.cursor)
            },
            stop: function (t, e, i) {
                var n = i.options;
                n._cursor && x("body").css("cursor", n._cursor)
            }
        }), x.ui.plugin.add("draggable", "opacity", {
            start: function (t, e, i) {
                var n = x(e.helper),
                    s = i.options;
                n.css("opacity") && (s._opacity = n.css("opacity")), n.css("opacity", s.opacity)
            },
            stop: function (t, e, i) {
                var n = i.options;
                n._opacity && x(e.helper).css("opacity", n._opacity)
            }
        }), x.ui.plugin.add("draggable", "scroll", {
            start: function (t, e, i) {
                i.scrollParentNotHidden || (i.scrollParentNotHidden = i.helper.scrollParent(!1)), i.scrollParentNotHidden[0] !== i.document[0] && "HTML" !== i.scrollParentNotHidden[0].tagName && (i.overflowOffset = i.scrollParentNotHidden.offset())
            },
            drag: function (t, e, i) {
                var n = i.options,
                    s = !1,
                    o = i.scrollParentNotHidden[0],
                    r = i.document[0];
                o !== r && "HTML" !== o.tagName ? (n.axis && "x" === n.axis || (i.overflowOffset.top + o.offsetHeight - t.pageY < n.scrollSensitivity ? o.scrollTop = s = o.scrollTop + n.scrollSpeed : t.pageY - i.overflowOffset.top < n.scrollSensitivity && (o.scrollTop = s = o.scrollTop - n.scrollSpeed)), n.axis && "y" === n.axis || (i.overflowOffset.left + o.offsetWidth - t.pageX < n.scrollSensitivity ? o.scrollLeft = s = o.scrollLeft + n.scrollSpeed : t.pageX - i.overflowOffset.left < n.scrollSensitivity && (o.scrollLeft = s = o.scrollLeft - n.scrollSpeed))) : (n.axis && "x" === n.axis || (t.pageY - x(r).scrollTop() < n.scrollSensitivity ? s = x(r).scrollTop(x(r).scrollTop() - n.scrollSpeed) : x(window).height() - (t.pageY - x(r).scrollTop()) < n.scrollSensitivity && (s = x(r).scrollTop(x(r).scrollTop() + n.scrollSpeed))), n.axis && "y" === n.axis || (t.pageX - x(r).scrollLeft() < n.scrollSensitivity ? s = x(r).scrollLeft(x(r).scrollLeft() - n.scrollSpeed) : x(window).width() - (t.pageX - x(r).scrollLeft()) < n.scrollSensitivity && (s = x(r).scrollLeft(x(r).scrollLeft() + n.scrollSpeed)))), !1 !== s && x.ui.ddmanager && !n.dropBehaviour && x.ui.ddmanager.prepareOffsets(i, t)
            }
        }), x.ui.plugin.add("draggable", "snap", {
            start: function (t, e, i) {
                var n = i.options;
                i.snapElements = [], x(n.snap.constructor !== String ? n.snap.items || ":data(ui-draggable)" : n.snap).each(function () {
                    var t = x(this),
                        e = t.offset();
                    this !== i.element[0] && i.snapElements.push({
                        item: this,
                        width: t.outerWidth(),
                        height: t.outerHeight(),
                        top: e.top,
                        left: e.left
                    })
                })
            },
            drag: function (t, e, i) {
                var n, s, o, r, a, l, h, c, u, d, p = i.options,
                    f = p.snapTolerance,
                    g = e.offset.left,
                    m = g + i.helperProportions.width,
                    v = e.offset.top,
                    _ = v + i.helperProportions.height;
                for (u = i.snapElements.length - 1; 0 <= u; u--) l = (a = i.snapElements[u].left - i.margins.left) + i.snapElements[u].width, c = (h = i.snapElements[u].top - i.margins.top) + i.snapElements[u].height, m < a - f || l + f < g || _ < h - f || c + f < v || !x.contains(i.snapElements[u].item.ownerDocument, i.snapElements[u].item) ? (i.snapElements[u].snapping && i.options.snap.release && i.options.snap.release.call(i.element, t, x.extend(i._uiHash(), {
                    snapItem: i.snapElements[u].item
                })), i.snapElements[u].snapping = !1) : ("inner" !== p.snapMode && (n = f >= Math.abs(h - _), s = f >= Math.abs(c - v), o = f >= Math.abs(a - m), r = f >= Math.abs(l - g), n && (e.position.top = i._convertPositionTo("relative", {
                    top: h - i.helperProportions.height,
                    left: 0
                }).top), s && (e.position.top = i._convertPositionTo("relative", {
                    top: c,
                    left: 0
                }).top), o && (e.position.left = i._convertPositionTo("relative", {
                    top: 0,
                    left: a - i.helperProportions.width
                }).left), r && (e.position.left = i._convertPositionTo("relative", {
                    top: 0,
                    left: l
                }).left)), d = n || s || o || r, "outer" !== p.snapMode && (n = f >= Math.abs(h - v), s = f >= Math.abs(c - _), o = f >= Math.abs(a - g), r = f >= Math.abs(l - m), n && (e.position.top = i._convertPositionTo("relative", {
                    top: h,
                    left: 0
                }).top), s && (e.position.top = i._convertPositionTo("relative", {
                    top: c - i.helperProportions.height,
                    left: 0
                }).top), o && (e.position.left = i._convertPositionTo("relative", {
                    top: 0,
                    left: a
                }).left), r && (e.position.left = i._convertPositionTo("relative", {
                    top: 0,
                    left: l - i.helperProportions.width
                }).left)), !i.snapElements[u].snapping && (n || s || o || r || d) && i.options.snap.snap && i.options.snap.snap.call(i.element, t, x.extend(i._uiHash(), {
                    snapItem: i.snapElements[u].item
                })), i.snapElements[u].snapping = n || s || o || r || d)
            }
        }), x.ui.plugin.add("draggable", "stack", {
            start: function (t, e, i) {
                var n, s = i.options,
                    o = x.makeArray(x(s.stack)).sort(function (t, e) {
                        return (parseInt(x(t).css("zIndex"), 10) || 0) - (parseInt(x(e).css("zIndex"), 10) || 0)
                    });
                o.length && (n = parseInt(x(o[0]).css("zIndex"), 10) || 0, x(o).each(function (t) {
                    x(this).css("zIndex", n + t)
                }), this.css("zIndex", n + o.length))
            }
        }), x.ui.plugin.add("draggable", "zIndex", {
            start: function (t, e, i) {
                var n = x(e.helper),
                    s = i.options;
                n.css("zIndex") && (s._zIndex = n.css("zIndex")), n.css("zIndex", s.zIndex)
            },
            stop: function (t, e, i) {
                var n = i.options;
                n._zIndex && x(e.helper).css("zIndex", n._zIndex)
            }
        }), x.ui.draggable, x.widget("ui.resizable", x.ui.mouse, {
            version: "1.12.1",
            widgetEventPrefix: "resize",
            options: {
                alsoResize: !1,
                animate: !1,
                animateDuration: "slow",
                animateEasing: "swing",
                aspectRatio: !1,
                autoHide: !1,
                classes: {
                    "ui-resizable-se": "ui-icon ui-icon-gripsmall-diagonal-se"
                },
                containment: !1,
                ghost: !1,
                grid: !1,
                handles: "e,s,se",
                helper: !1,
                maxHeight: null,
                maxWidth: null,
                minHeight: 10,
                minWidth: 10,
                zIndex: 90,
                resize: null,
                start: null,
                stop: null
            },
            _num: function (t) {
                return parseFloat(t) || 0
            },
            _isNumber: function (t) {
                return !isNaN(parseFloat(t))
            },
            _hasScroll: function (t, e) {
                if ("hidden" === x(t).css("overflow")) return !1;
                var i = e && "left" === e ? "scrollLeft" : "scrollTop",
                    n = !1;
                return 0 < t[i] || (t[i] = 1, n = 0 < t[i], t[i] = 0, n)
            },
            _create: function () {
                var t, e = this.options,
                    i = this;
                this._addClass("ui-resizable"), x.extend(this, {
                    _aspectRatio: !!e.aspectRatio,
                    aspectRatio: e.aspectRatio,
                    originalElement: this.element,
                    _proportionallyResizeElements: [],
                    _helper: e.helper || e.ghost || e.animate ? e.helper || "ui-resizable-helper" : null
                }), this.element[0].nodeName.match(/^(canvas|textarea|input|select|button|img)$/i) && (this.element.wrap(x("<div class='ui-wrapper' style='overflow: hidden;'></div>").css({
                    position: this.element.css("position"),
                    width: this.element.outerWidth(),
                    height: this.element.outerHeight(),
                    top: this.element.css("top"),
                    left: this.element.css("left")
                })), this.element = this.element.parent().data("ui-resizable", this.element.resizable("instance")), this.elementIsWrapper = !0, t = {
                    marginTop: this.originalElement.css("marginTop"),
                    marginRight: this.originalElement.css("marginRight"),
                    marginBottom: this.originalElement.css("marginBottom"),
                    marginLeft: this.originalElement.css("marginLeft")
                }, this.element.css(t), this.originalElement.css("margin", 0), this.originalResizeStyle = this.originalElement.css("resize"), this.originalElement.css("resize", "none"), this._proportionallyResizeElements.push(this.originalElement.css({
                    position: "static",
                    zoom: 1,
                    display: "block"
                })), this.originalElement.css(t), this._proportionallyResize()), this._setupHandles(), e.autoHide && x(this.element).on("mouseenter", function () {
                    e.disabled || (i._removeClass("ui-resizable-autohide"), i._handles.show())
                }).on("mouseleave", function () {
                    e.disabled || i.resizing || (i._addClass("ui-resizable-autohide"), i._handles.hide())
                }), this._mouseInit()
            },
            _destroy: function () {
                this._mouseDestroy();

                function t(t) {
                    x(t).removeData("resizable").removeData("ui-resizable").off(".resizable").find(".ui-resizable-handle").remove()
                }
                var e;
                return this.elementIsWrapper && (t(this.element), e = this.element, this.originalElement.css({
                    position: e.css("position"),
                    width: e.outerWidth(),
                    height: e.outerHeight(),
                    top: e.css("top"),
                    left: e.css("left")
                }).insertAfter(e), e.remove()), this.originalElement.css("resize", this.originalResizeStyle), t(this.originalElement), this
            },
            _setOption: function (t, e) {
                switch (this._super(t, e), t) {
                    case "handles":
                        this._removeHandles(), this._setupHandles()
                }
            },
            _setupHandles: function () {
                var t, e, i, n, s, o = this.options,
                    r = this;
                if (this.handles = o.handles || (x(".ui-resizable-handle", this.element).length ? {
                    n: ".ui-resizable-n",
                    e: ".ui-resizable-e",
                    s: ".ui-resizable-s",
                    w: ".ui-resizable-w",
                    se: ".ui-resizable-se",
                    sw: ".ui-resizable-sw",
                    ne: ".ui-resizable-ne",
                    nw: ".ui-resizable-nw"
                } : "e,s,se"), this._handles = x(), this.handles.constructor === String)
                    for ("all" === this.handles && (this.handles = "n,e,s,w,se,sw,ne,nw"), i = this.handles.split(","), this.handles = {}, e = 0; i.length > e; e++) n = "ui-resizable-" + (t = x.trim(i[e])), s = x("<div>"), this._addClass(s, "ui-resizable-handle " + n), s.css({
                        zIndex: o.zIndex
                    }), this.handles[t] = ".ui-resizable-" + t, this.element.append(s);
                this._renderAxis = function (t) {
                    var e, i, n, s;
                    for (e in t = t || this.element, this.handles) this.handles[e].constructor === String ? this.handles[e] = this.element.children(this.handles[e]).first().show() : (this.handles[e].jquery || this.handles[e].nodeType) && (this.handles[e] = x(this.handles[e]), this._on(this.handles[e], {
                        mousedown: r._mouseDown
                    })), this.elementIsWrapper && this.originalElement[0].nodeName.match(/^(textarea|input|select|button)$/i) && (i = x(this.handles[e], this.element), s = /sw|ne|nw|se|n|s/.test(e) ? i.outerHeight() : i.outerWidth(), n = ["padding", /ne|nw|n/.test(e) ? "Top" : /se|sw|s/.test(e) ? "Bottom" : /^e$/.test(e) ? "Right" : "Left"].join(""), t.css(n, s), this._proportionallyResize()), this._handles = this._handles.add(this.handles[e])
                }, this._renderAxis(this.element), this._handles = this._handles.add(this.element.find(".ui-resizable-handle")), this._handles.disableSelection(), this._handles.on("mouseover", function () {
                    r.resizing || (this.className && (s = this.className.match(/ui-resizable-(se|sw|ne|nw|n|e|s|w)/i)), r.axis = s && s[1] ? s[1] : "se")
                }), o.autoHide && (this._handles.hide(), this._addClass("ui-resizable-autohide"))
            },
            _removeHandles: function () {
                this._handles.remove()
            },
            _mouseCapture: function (t) {
                var e, i, n = !1;
                for (e in this.handles) (i = x(this.handles[e])[0]) !== t.target && !x.contains(i, t.target) || (n = !0);
                return !this.options.disabled && n
            },
            _mouseStart: function (t) {
                var e, i, n, s = this.options,
                    o = this.element;
                return this.resizing = !0, this._renderProxy(), e = this._num(this.helper.css("left")), i = this._num(this.helper.css("top")), s.containment && (e += x(s.containment).scrollLeft() || 0, i += x(s.containment).scrollTop() || 0), this.offset = this.helper.offset(), this.position = {
                    left: e,
                    top: i
                }, this.size = this._helper ? {
                    width: this.helper.width(),
                    height: this.helper.height()
                } : {
                        width: o.width(),
                        height: o.height()
                    }, this.originalSize = this._helper ? {
                        width: o.outerWidth(),
                        height: o.outerHeight()
                    } : {
                            width: o.width(),
                            height: o.height()
                        }, this.sizeDiff = {
                            width: o.outerWidth() - o.width(),
                            height: o.outerHeight() - o.height()
                        }, this.originalPosition = {
                            left: e,
                            top: i
                        }, this.originalMousePosition = {
                            left: t.pageX,
                            top: t.pageY
                        }, this.aspectRatio = "number" == typeof s.aspectRatio ? s.aspectRatio : this.originalSize.width / this.originalSize.height || 1, n = x(".ui-resizable-" + this.axis).css("cursor"), x("body").css("cursor", "auto" === n ? this.axis + "-resize" : n), this._addClass("ui-resizable-resizing"), this._propagate("start", t), !0
            },
            _mouseDrag: function (t) {
                var e, i, n = this.originalMousePosition,
                    s = this.axis,
                    o = t.pageX - n.left || 0,
                    r = t.pageY - n.top || 0,
                    a = this._change[s];
                return this._updatePrevProperties(), a && (e = a.apply(this, [t, o, r]), this._updateVirtualBoundaries(t.shiftKey), (this._aspectRatio || t.shiftKey) && (e = this._updateRatio(e, t)), e = this._respectSize(e, t), this._updateCache(e), this._propagate("resize", t), i = this._applyChanges(), !this._helper && this._proportionallyResizeElements.length && this._proportionallyResize(), x.isEmptyObject(i) || (this._updatePrevProperties(), this._trigger("resize", t, this.ui()), this._applyChanges())), !1
            },
            _mouseStop: function (t) {
                this.resizing = !1;
                var e, i, n, s, o, r, a, l = this.options,
                    h = this;
                return this._helper && (n = (i = (e = this._proportionallyResizeElements).length && /textarea/i.test(e[0].nodeName)) && this._hasScroll(e[0], "left") ? 0 : h.sizeDiff.height, s = i ? 0 : h.sizeDiff.width, o = {
                    width: h.helper.width() - s,
                    height: h.helper.height() - n
                }, r = parseFloat(h.element.css("left")) + (h.position.left - h.originalPosition.left) || null, a = parseFloat(h.element.css("top")) + (h.position.top - h.originalPosition.top) || null, l.animate || this.element.css(x.extend(o, {
                    top: a,
                    left: r
                })), h.helper.height(h.size.height), h.helper.width(h.size.width), this._helper && !l.animate && this._proportionallyResize()), x("body").css("cursor", "auto"), this._removeClass("ui-resizable-resizing"), this._propagate("stop", t), this._helper && this.helper.remove(), !1
            },
            _updatePrevProperties: function () {
                this.prevPosition = {
                    top: this.position.top,
                    left: this.position.left
                }, this.prevSize = {
                    width: this.size.width,
                    height: this.size.height
                }
            },
            _applyChanges: function () {
                var t = {};
                return this.position.top !== this.prevPosition.top && (t.top = this.position.top + "px"), this.position.left !== this.prevPosition.left && (t.left = this.position.left + "px"), this.size.width !== this.prevSize.width && (t.width = this.size.width + "px"), this.size.height !== this.prevSize.height && (t.height = this.size.height + "px"), this.helper.css(t), t
            },
            _updateVirtualBoundaries: function (t) {
                var e, i, n, s, o, r = this.options;
                o = {
                    minWidth: this._isNumber(r.minWidth) ? r.minWidth : 0,
                    maxWidth: this._isNumber(r.maxWidth) ? r.maxWidth : 1 / 0,
                    minHeight: this._isNumber(r.minHeight) ? r.minHeight : 0,
                    maxHeight: this._isNumber(r.maxHeight) ? r.maxHeight : 1 / 0
                }, (this._aspectRatio || t) && (e = o.minHeight * this.aspectRatio, n = o.minWidth / this.aspectRatio, i = o.maxHeight * this.aspectRatio, s = o.maxWidth / this.aspectRatio, e > o.minWidth && (o.minWidth = e), n > o.minHeight && (o.minHeight = n), o.maxWidth > i && (o.maxWidth = i), o.maxHeight > s && (o.maxHeight = s)), this._vBoundaries = o
            },
            _updateCache: function (t) {
                this.offset = this.helper.offset(), this._isNumber(t.left) && (this.position.left = t.left), this._isNumber(t.top) && (this.position.top = t.top), this._isNumber(t.height) && (this.size.height = t.height), this._isNumber(t.width) && (this.size.width = t.width)
            },
            _updateRatio: function (t) {
                var e = this.position,
                    i = this.size,
                    n = this.axis;
                return this._isNumber(t.height) ? t.width = t.height * this.aspectRatio : this._isNumber(t.width) && (t.height = t.width / this.aspectRatio), "sw" === n && (t.left = e.left + (i.width - t.width), t.top = null), "nw" === n && (t.top = e.top + (i.height - t.height), t.left = e.left + (i.width - t.width)), t
            },
            _respectSize: function (t) {
                var e = this._vBoundaries,
                    i = this.axis,
                    n = this._isNumber(t.width) && e.maxWidth && e.maxWidth < t.width,
                    s = this._isNumber(t.height) && e.maxHeight && e.maxHeight < t.height,
                    o = this._isNumber(t.width) && e.minWidth && e.minWidth > t.width,
                    r = this._isNumber(t.height) && e.minHeight && e.minHeight > t.height,
                    a = this.originalPosition.left + this.originalSize.width,
                    l = this.originalPosition.top + this.originalSize.height,
                    h = /sw|nw|w/.test(i),
                    c = /nw|ne|n/.test(i);
                return o && (t.width = e.minWidth), r && (t.height = e.minHeight), n && (t.width = e.maxWidth), s && (t.height = e.maxHeight), o && h && (t.left = a - e.minWidth), n && h && (t.left = a - e.maxWidth), r && c && (t.top = l - e.minHeight), s && c && (t.top = l - e.maxHeight), t.width || t.height || t.left || !t.top ? t.width || t.height || t.top || !t.left || (t.left = null) : t.top = null, t
            },
            _getPaddingPlusBorderDimensions: function (t) {
                for (var e = 0, i = [], n = [t.css("borderTopWidth"), t.css("borderRightWidth"), t.css("borderBottomWidth"), t.css("borderLeftWidth")], s = [t.css("paddingTop"), t.css("paddingRight"), t.css("paddingBottom"), t.css("paddingLeft")]; e < 4; e++) i[e] = parseFloat(n[e]) || 0, i[e] += parseFloat(s[e]) || 0;
                return {
                    height: i[0] + i[2],
                    width: i[1] + i[3]
                }
            },
            _proportionallyResize: function () {
                if (this._proportionallyResizeElements.length)
                    for (var t, e = 0, i = this.helper || this.element; this._proportionallyResizeElements.length > e; e++) t = this._proportionallyResizeElements[e], this.outerDimensions || (this.outerDimensions = this._getPaddingPlusBorderDimensions(t)), t.css({
                        height: i.height() - this.outerDimensions.height || 0,
                        width: i.width() - this.outerDimensions.width || 0
                    })
            },
            _renderProxy: function () {
                var t = this.element,
                    e = this.options;
                this.elementOffset = t.offset(), this._helper ? (this.helper = this.helper || x("<div style='overflow:hidden;'></div>"), this._addClass(this.helper, this._helper), this.helper.css({
                    width: this.element.outerWidth(),
                    height: this.element.outerHeight(),
                    position: "absolute",
                    left: this.elementOffset.left + "px",
                    top: this.elementOffset.top + "px",
                    zIndex: ++e.zIndex
                }), this.helper.appendTo("body").disableSelection()) : this.helper = this.element
            },
            _change: {
                e: function (t, e) {
                    return {
                        width: this.originalSize.width + e
                    }
                },
                w: function (t, e) {
                    var i = this.originalSize;
                    return {
                        left: this.originalPosition.left + e,
                        width: i.width - e
                    }
                },
                n: function (t, e, i) {
                    var n = this.originalSize;
                    return {
                        top: this.originalPosition.top + i,
                        height: n.height - i
                    }
                },
                s: function (t, e, i) {
                    return {
                        height: this.originalSize.height + i
                    }
                },
                se: function (t, e, i) {
                    return x.extend(this._change.s.apply(this, arguments), this._change.e.apply(this, [t, e, i]))
                },
                sw: function (t, e, i) {
                    return x.extend(this._change.s.apply(this, arguments), this._change.w.apply(this, [t, e, i]))
                },
                ne: function (t, e, i) {
                    return x.extend(this._change.n.apply(this, arguments), this._change.e.apply(this, [t, e, i]))
                },
                nw: function (t, e, i) {
                    return x.extend(this._change.n.apply(this, arguments), this._change.w.apply(this, [t, e, i]))
                }
            },
            _propagate: function (t, e) {
                x.ui.plugin.call(this, t, [e, this.ui()]), "resize" !== t && this._trigger(t, e, this.ui())
            },
            plugins: {},
            ui: function () {
                return {
                    originalElement: this.originalElement,
                    element: this.element,
                    helper: this.helper,
                    position: this.position,
                    size: this.size,
                    originalSize: this.originalSize,
                    originalPosition: this.originalPosition
                }
            }
        }), x.ui.plugin.add("resizable", "animate", {
            stop: function (e) {
                var i = x(this).resizable("instance"),
                    t = i.options,
                    n = i._proportionallyResizeElements,
                    s = n.length && /textarea/i.test(n[0].nodeName),
                    o = s && i._hasScroll(n[0], "left") ? 0 : i.sizeDiff.height,
                    r = s ? 0 : i.sizeDiff.width,
                    a = {
                        width: i.size.width - r,
                        height: i.size.height - o
                    },
                    l = parseFloat(i.element.css("left")) + (i.position.left - i.originalPosition.left) || null,
                    h = parseFloat(i.element.css("top")) + (i.position.top - i.originalPosition.top) || null;
                i.element.animate(x.extend(a, h && l ? {
                    top: h,
                    left: l
                } : {}), {
                    duration: t.animateDuration,
                    easing: t.animateEasing,
                    step: function () {
                        var t = {
                            width: parseFloat(i.element.css("width")),
                            height: parseFloat(i.element.css("height")),
                            top: parseFloat(i.element.css("top")),
                            left: parseFloat(i.element.css("left"))
                        };
                        n && n.length && x(n[0]).css({
                            width: t.width,
                            height: t.height
                        }), i._updateCache(t), i._propagate("resize", e)
                    }
                })
            }
        }), x.ui.plugin.add("resizable", "containment", {
            start: function () {
                var i, n, t, e, s, o, r, a = x(this).resizable("instance"),
                    l = a.options,
                    h = a.element,
                    c = l.containment,
                    u = c instanceof x ? c.get(0) : /parent/.test(c) ? h.parent().get(0) : c;
                u && (a.containerElement = x(u), /document/.test(c) || c === document ? (a.containerOffset = {
                    left: 0,
                    top: 0
                }, a.containerPosition = {
                    left: 0,
                    top: 0
                }, a.parentData = {
                    element: x(document),
                    left: 0,
                    top: 0,
                    width: x(document).width(),
                    height: x(document).height() || document.body.parentNode.scrollHeight
                }) : (i = x(u), n = [], x(["Top", "Right", "Left", "Bottom"]).each(function (t, e) {
                    n[t] = a._num(i.css("padding" + e))
                }), a.containerOffset = i.offset(), a.containerPosition = i.position(), a.containerSize = {
                    height: i.innerHeight() - n[3],
                    width: i.innerWidth() - n[1]
                }, t = a.containerOffset, e = a.containerSize.height, s = a.containerSize.width, o = a._hasScroll(u, "left") ? u.scrollWidth : s, r = a._hasScroll(u) ? u.scrollHeight : e, a.parentData = {
                    element: u,
                    left: t.left,
                    top: t.top,
                    width: o,
                    height: r
                }))
            },
            resize: function (t) {
                var e, i, n, s, o = x(this).resizable("instance"),
                    r = o.options,
                    a = o.containerOffset,
                    l = o.position,
                    h = o._aspectRatio || t.shiftKey,
                    c = {
                        top: 0,
                        left: 0
                    },
                    u = o.containerElement,
                    d = !0;
                u[0] !== document && /static/.test(u.css("position")) && (c = a), l.left < (o._helper ? a.left : 0) && (o.size.width = o.size.width + (o._helper ? o.position.left - a.left : o.position.left - c.left), h && (o.size.height = o.size.width / o.aspectRatio, d = !1), o.position.left = r.helper ? a.left : 0), l.top < (o._helper ? a.top : 0) && (o.size.height = o.size.height + (o._helper ? o.position.top - a.top : o.position.top), h && (o.size.width = o.size.height * o.aspectRatio, d = !1), o.position.top = o._helper ? a.top : 0), n = o.containerElement.get(0) === o.element.parent().get(0), s = /relative|absolute/.test(o.containerElement.css("position")), n && s ? (o.offset.left = o.parentData.left + o.position.left, o.offset.top = o.parentData.top + o.position.top) : (o.offset.left = o.element.offset().left, o.offset.top = o.element.offset().top), e = Math.abs(o.sizeDiff.width + (o._helper ? o.offset.left - c.left : o.offset.left - a.left)), i = Math.abs(o.sizeDiff.height + (o._helper ? o.offset.top - c.top : o.offset.top - a.top)), e + o.size.width >= o.parentData.width && (o.size.width = o.parentData.width - e, h && (o.size.height = o.size.width / o.aspectRatio, d = !1)), i + o.size.height >= o.parentData.height && (o.size.height = o.parentData.height - i, h && (o.size.width = o.size.height * o.aspectRatio, d = !1)), d || (o.position.left = o.prevPosition.left, o.position.top = o.prevPosition.top, o.size.width = o.prevSize.width, o.size.height = o.prevSize.height)
            },
            stop: function () {
                var t = x(this).resizable("instance"),
                    e = t.options,
                    i = t.containerOffset,
                    n = t.containerPosition,
                    s = t.containerElement,
                    o = x(t.helper),
                    r = o.offset(),
                    a = o.outerWidth() - t.sizeDiff.width,
                    l = o.outerHeight() - t.sizeDiff.height;
                t._helper && !e.animate && /relative/.test(s.css("position")) && x(this).css({
                    left: r.left - n.left - i.left,
                    width: a,
                    height: l
                }), t._helper && !e.animate && /static/.test(s.css("position")) && x(this).css({
                    left: r.left - n.left - i.left,
                    width: a,
                    height: l
                })
            }
        }), x.ui.plugin.add("resizable", "alsoResize", {
            start: function () {
                var t = x(this).resizable("instance").options;
                x(t.alsoResize).each(function () {
                    var t = x(this);
                    t.data("ui-resizable-alsoresize", {
                        width: parseFloat(t.width()),
                        height: parseFloat(t.height()),
                        left: parseFloat(t.css("left")),
                        top: parseFloat(t.css("top"))
                    })
                })
            },
            resize: function (t, i) {
                var e = x(this).resizable("instance"),
                    n = e.options,
                    s = e.originalSize,
                    o = e.originalPosition,
                    r = {
                        height: e.size.height - s.height || 0,
                        width: e.size.width - s.width || 0,
                        top: e.position.top - o.top || 0,
                        left: e.position.left - o.left || 0
                    };
                x(n.alsoResize).each(function () {
                    var t = x(this),
                        n = x(this).data("ui-resizable-alsoresize"),
                        s = {},
                        e = t.parents(i.originalElement[0]).length ? ["width", "height"] : ["width", "height", "top", "left"];
                    x.each(e, function (t, e) {
                        var i = (n[e] || 0) + (r[e] || 0);
                        i && 0 <= i && (s[e] = i || null)
                    }), t.css(s)
                })
            },
            stop: function () {
                x(this).removeData("ui-resizable-alsoresize")
            }
        }), x.ui.plugin.add("resizable", "ghost", {
            start: function () {
                var t = x(this).resizable("instance"),
                    e = t.size;
                t.ghost = t.originalElement.clone(), t.ghost.css({
                    opacity: .25,
                    display: "block",
                    position: "relative",
                    height: e.height,
                    width: e.width,
                    margin: 0,
                    left: 0,
                    top: 0
                }), t._addClass(t.ghost, "ui-resizable-ghost"), !1 !== x.uiBackCompat && "string" == typeof t.options.ghost && t.ghost.addClass(this.options.ghost), t.ghost.appendTo(t.helper)
            },
            resize: function () {
                var t = x(this).resizable("instance");
                t.ghost && t.ghost.css({
                    position: "relative",
                    height: t.size.height,
                    width: t.size.width
                })
            },
            stop: function () {
                var t = x(this).resizable("instance");
                t.ghost && t.helper && t.helper.get(0).removeChild(t.ghost.get(0))
            }
        }), x.ui.plugin.add("resizable", "grid", {
            resize: function () {
                var t, e = x(this).resizable("instance"),
                    i = e.options,
                    n = e.size,
                    s = e.originalSize,
                    o = e.originalPosition,
                    r = e.axis,
                    a = "number" == typeof i.grid ? [i.grid, i.grid] : i.grid,
                    l = a[0] || 1,
                    h = a[1] || 1,
                    c = Math.round((n.width - s.width) / l) * l,
                    u = Math.round((n.height - s.height) / h) * h,
                    d = s.width + c,
                    p = s.height + u,
                    f = i.maxWidth && d > i.maxWidth,
                    g = i.maxHeight && p > i.maxHeight,
                    m = i.minWidth && i.minWidth > d,
                    v = i.minHeight && i.minHeight > p;
                i.grid = a, m && (d += l), v && (p += h), f && (d -= l), g && (p -= h), /^(se|s|e)$/.test(r) ? (e.size.width = d, e.size.height = p) : /^(ne)$/.test(r) ? (e.size.width = d, e.size.height = p, e.position.top = o.top - u) : /^(sw)$/.test(r) ? (e.size.width = d, e.size.height = p, e.position.left = o.left - c) : ((p - h <= 0 || d - l <= 0) && (t = e._getPaddingPlusBorderDimensions(this)), 0 < p - h ? (e.size.height = p, e.position.top = o.top - u) : (p = h - t.height, e.size.height = p, e.position.top = o.top + s.height - p), 0 < d - l ? (e.size.width = d, e.position.left = o.left - c) : (d = l - t.width, e.size.width = d, e.position.left = o.left + s.width - d))
            }
        }), x.ui.resizable, x.widget("ui.dialog", {
            version: "1.12.1",
            options: {
                appendTo: "body",
                autoOpen: !0,
                buttons: [],
                classes: {
                    "ui-dialog": "ui-corner-all",
                    "ui-dialog-titlebar": "ui-corner-all"
                },
                closeOnEscape: !0,
                closeText: "Close",
                draggable: !0,
                hide: null,
                height: "auto",
                maxHeight: null,
                maxWidth: null,
                minHeight: 150,
                minWidth: 150,
                modal: !1,
                position: {
                    my: "center",
                    at: "center",
                    of: window,
                    collision: "fit",
                    using: function (t) {
                        var e = x(this).css(t).offset().top;
                        e < 0 && x(this).css("top", t.top - e)
                    }
                },
                resizable: !0,
                show: null,
                title: null,
                width: 300,
                beforeClose: null,
                close: null,
                drag: null,
                dragStart: null,
                dragStop: null,
                focus: null,
                open: null,
                resize: null,
                resizeStart: null,
                resizeStop: null
            },
            sizeRelatedOptions: {
                buttons: !0,
                height: !0,
                maxHeight: !0,
                maxWidth: !0,
                minHeight: !0,
                minWidth: !0,
                width: !0
            },
            resizableRelatedOptions: {
                maxHeight: !0,
                maxWidth: !0,
                minHeight: !0,
                minWidth: !0
            },
            _create: function () {
                this.originalCss = {
                    display: this.element[0].style.display,
                    width: this.element[0].style.width,
                    minHeight: this.element[0].style.minHeight,
                    maxHeight: this.element[0].style.maxHeight,
                    height: this.element[0].style.height
                }, this.originalPosition = {
                    parent: this.element.parent(),
                    index: this.element.parent().children().index(this.element)
                }, this.originalTitle = this.element.attr("title"), null == this.options.title && null != this.originalTitle && (this.options.title = this.originalTitle), this.options.disabled && (this.options.disabled = !1), this._createWrapper(), this.element.show().removeAttr("title").appendTo(this.uiDialog), this._addClass("ui-dialog-content", "ui-widget-content"), this._createTitlebar(), this._createButtonPane(), this.options.draggable && x.fn.draggable && this._makeDraggable(), this.options.resizable && x.fn.resizable && this._makeResizable(), this._isOpen = !1, this._trackFocus()
            },
            _init: function () {
                this.options.autoOpen && this.open()
            },
            _appendTo: function () {
                var t = this.options.appendTo;
                return t && (t.jquery || t.nodeType) ? x(t) : this.document.find(t || "body").eq(0)
            },
            _destroy: function () {
                var t, e = this.originalPosition;
                this._untrackInstance(), this._destroyOverlay(), this.element.removeUniqueId().css(this.originalCss).detach(), this.uiDialog.remove(), this.originalTitle && this.element.attr("title", this.originalTitle), (t = e.parent.children().eq(e.index)).length && t[0] !== this.element[0] ? t.before(this.element) : e.parent.append(this.element)
            },
            widget: function () {
                return this.uiDialog
            },
            disable: x.noop,
            enable: x.noop,
            close: function (t) {
                var e = this;
                this._isOpen && !1 !== this._trigger("beforeClose", t) && (this._isOpen = !1, this._focusedElement = null, this._destroyOverlay(), this._untrackInstance(), this.opener.filter(":focusable").trigger("focus").length || x.ui.safeBlur(x.ui.safeActiveElement(this.document[0])), this._hide(this.uiDialog, this.options.hide, function () {
                    e._trigger("close", t)
                }))
            },
            isOpen: function () {
                return this._isOpen
            },
            moveToTop: function () {
                this._moveToTop()
            },
            _moveToTop: function (t, e) {
                var i = !1,
                    n = this.uiDialog.siblings(".ui-front:visible").map(function () {
                        return +x(this).css("z-index")
                    }).get(),
                    s = Math.max.apply(null, n);
                return s >= +this.uiDialog.css("z-index") && (this.uiDialog.css("z-index", s + 1), i = !0), i && !e && this._trigger("focus", t), i
            },
            open: function () {
                var t = this;
                return this._isOpen ? void (this._moveToTop() && this._focusTabbable()) : (this._isOpen = !0, this.opener = x(x.ui.safeActiveElement(this.document[0])), this._size(), this._position(), this._createOverlay(), this._moveToTop(null, !0), this.overlay && this.overlay.css("z-index", this.uiDialog.css("z-index") - 1), this._show(this.uiDialog, this.options.show, function () {
                    t._focusTabbable(), t._trigger("focus")
                }), this._makeFocusTarget(), void this._trigger("open"))
            },
            _focusTabbable: function () {
                var t = this._focusedElement;
                (t = t || this.element.find("[autofocus]")).length || (t = this.element.find(":tabbable")), t.length || (t = this.uiDialogButtonPane.find(":tabbable")), t.length || (t = this.uiDialogTitlebarClose.filter(":tabbable")), t.length || (t = this.uiDialog), t.eq(0).trigger("focus")
            },
            _keepFocus: function (t) {
                function e() {
                    var t = x.ui.safeActiveElement(this.document[0]);
                    this.uiDialog[0] === t || x.contains(this.uiDialog[0], t) || this._focusTabbable()
                }
                t.preventDefault(), e.call(this), this._delay(e)
            },
            _createWrapper: function () {
                this.uiDialog = x("<div>").hide().attr({
                    tabIndex: -1,
                    role: "dialog"
                }).appendTo(this._appendTo()), this._addClass(this.uiDialog, "ui-dialog", "ui-widget ui-widget-content ui-front"), this._on(this.uiDialog, {
                    keydown: function (t) {
                        if (this.options.closeOnEscape && !t.isDefaultPrevented() && t.keyCode && t.keyCode === x.ui.keyCode.ESCAPE) return t.preventDefault(), void this.close(t);
                        if (t.keyCode === x.ui.keyCode.TAB && !t.isDefaultPrevented()) {
                            var e = this.uiDialog.find(":tabbable"),
                                i = e.filter(":first"),
                                n = e.filter(":last");
                            t.target !== n[0] && t.target !== this.uiDialog[0] || t.shiftKey ? t.target !== i[0] && t.target !== this.uiDialog[0] || !t.shiftKey || (this._delay(function () {
                                n.trigger("focus")
                            }), t.preventDefault()) : (this._delay(function () {
                                i.trigger("focus")
                            }), t.preventDefault())
                        }
                    },
                    mousedown: function (t) {
                        this._moveToTop(t) && this._focusTabbable()
                    }
                }), this.element.find("[aria-describedby]").length || this.uiDialog.attr({
                    "aria-describedby": this.element.uniqueId().attr("id")
                })
            },
            _createTitlebar: function () {
                var t;
                this.uiDialogTitlebar = x("<div>"), this._addClass(this.uiDialogTitlebar, "ui-dialog-titlebar", "ui-widget-header ui-helper-clearfix"), this._on(this.uiDialogTitlebar, {
                    mousedown: function (t) {
                        x(t.target).closest(".ui-dialog-titlebar-close") || this.uiDialog.trigger("focus")
                    }
                }), this.uiDialogTitlebarClose = x("<button type='button'></button>").button({
                    label: x("<a>").text(this.options.closeText).html(),
                    icon: "ui-icon-closethick",
                    showLabel: !1
                }).appendTo(this.uiDialogTitlebar), this._addClass(this.uiDialogTitlebarClose, "ui-dialog-titlebar-close"), this._on(this.uiDialogTitlebarClose, {
                    click: function (t) {
                        t.preventDefault(), this.close(t)
                    }
                }), t = x("<span>").uniqueId().prependTo(this.uiDialogTitlebar), this._addClass(t, "ui-dialog-title"), this._title(t), this.uiDialogTitlebar.prependTo(this.uiDialog), this.uiDialog.attr({
                    "aria-labelledby": t.attr("id")
                })
            },
            _title: function (t) {
                this.options.title ? t.text(this.options.title) : t.html("&#160;")
            },
            _createButtonPane: function () {
                this.uiDialogButtonPane = x("<div>"), this._addClass(this.uiDialogButtonPane, "ui-dialog-buttonpane", "ui-widget-content ui-helper-clearfix"), this.uiButtonSet = x("<div>").appendTo(this.uiDialogButtonPane), this._addClass(this.uiButtonSet, "ui-dialog-buttonset"), this._createButtons()
            },
            _createButtons: function () {
                var s = this,
                    t = this.options.buttons;
                return this.uiDialogButtonPane.remove(), this.uiButtonSet.empty(), x.isEmptyObject(t) || x.isArray(t) && !t.length ? void this._removeClass(this.uiDialog, "ui-dialog-buttons") : (x.each(t, function (t, e) {
                    var i, n;
                    e = x.isFunction(e) ? {
                        click: e,
                        text: t
                    } : e, e = x.extend({
                        type: "button"
                    }, e), i = e.click, n = {
                        icon: e.icon,
                        iconPosition: e.iconPosition,
                        showLabel: e.showLabel,
                        icons: e.icons,
                        text: e.text
                    }, delete e.click, delete e.icon, delete e.iconPosition, delete e.showLabel, delete e.icons, "boolean" == typeof e.text && delete e.text, x("<button></button>", e).button(n).appendTo(s.uiButtonSet).on("click", function () {
                        i.apply(s.element[0], arguments)
                    })
                }), this._addClass(this.uiDialog, "ui-dialog-buttons"), void this.uiDialogButtonPane.appendTo(this.uiDialog))
            },
            _makeDraggable: function () {
                function s(t) {
                    return {
                        position: t.position,
                        offset: t.offset
                    }
                }
                var o = this,
                    r = this.options;
                this.uiDialog.draggable({
                    cancel: ".ui-dialog-content, .ui-dialog-titlebar-close",
                    handle: ".ui-dialog-titlebar",
                    containment: "document",
                    start: function (t, e) {
                        o._addClass(x(this), "ui-dialog-dragging"), o._blockFrames(), o._trigger("dragStart", t, s(e))
                    },
                    drag: function (t, e) {
                        o._trigger("drag", t, s(e))
                    },
                    stop: function (t, e) {
                        var i = e.offset.left - o.document.scrollLeft(),
                            n = e.offset.top - o.document.scrollTop();
                        r.position = {
                            my: "left top",
                            at: "left" + (0 <= i ? "+" : "") + i + " top" + (0 <= n ? "+" : "") + n,
                            of: o.window
                        }, o._removeClass(x(this), "ui-dialog-dragging"), o._unblockFrames(), o._trigger("dragStop", t, s(e))
                    }
                })
            },
            _makeResizable: function () {
                function o(t) {
                    return {
                        originalPosition: t.originalPosition,
                        originalSize: t.originalSize,
                        position: t.position,
                        size: t.size
                    }
                }
                var r = this,
                    a = this.options,
                    t = a.resizable,
                    e = this.uiDialog.css("position"),
                    i = "string" == typeof t ? t : "n,e,s,w,se,sw,ne,nw";
                this.uiDialog.resizable({
                    cancel: ".ui-dialog-content",
                    containment: "document",
                    alsoResize: this.element,
                    maxWidth: a.maxWidth,
                    maxHeight: a.maxHeight,
                    minWidth: a.minWidth,
                    minHeight: this._minHeight(),
                    handles: i,
                    start: function (t, e) {
                        r._addClass(x(this), "ui-dialog-resizing"), r._blockFrames(), r._trigger("resizeStart", t, o(e))
                    },
                    resize: function (t, e) {
                        r._trigger("resize", t, o(e))
                    },
                    stop: function (t, e) {
                        var i = r.uiDialog.offset(),
                            n = i.left - r.document.scrollLeft(),
                            s = i.top - r.document.scrollTop();
                        a.height = r.uiDialog.height(), a.width = r.uiDialog.width(), a.position = {
                            my: "left top",
                            at: "left" + (0 <= n ? "+" : "") + n + " top" + (0 <= s ? "+" : "") + s,
                            of: r.window
                        }, r._removeClass(x(this), "ui-dialog-resizing"), r._unblockFrames(), r._trigger("resizeStop", t, o(e))
                    }
                }).css("position", e)
            },
            _trackFocus: function () {
                this._on(this.widget(), {
                    focusin: function (t) {
                        this._makeFocusTarget(), this._focusedElement = x(t.target)
                    }
                })
            },
            _makeFocusTarget: function () {
                this._untrackInstance(), this._trackingInstances().unshift(this)
            },
            _untrackInstance: function () {
                var t = this._trackingInstances(),
                    e = x.inArray(this, t); - 1 !== e && t.splice(e, 1)
            },
            _trackingInstances: function () {
                var t = this.document.data("ui-dialog-instances");
                return t || (t = [], this.document.data("ui-dialog-instances", t)), t
            },
            _minHeight: function () {
                var t = this.options;
                return "auto" === t.height ? t.minHeight : Math.min(t.minHeight, t.height)
            },
            _position: function () {
                var t = this.uiDialog.is(":visible");
                t || this.uiDialog.show(), this.uiDialog.position(this.options.position), t || this.uiDialog.hide()
            },
            _setOptions: function (t) {
                var i = this,
                    n = !1,
                    s = {};
                x.each(t, function (t, e) {
                    i._setOption(t, e), t in i.sizeRelatedOptions && (n = !0), t in i.resizableRelatedOptions && (s[t] = e)
                }), n && (this._size(), this._position()), this.uiDialog.is(":data(ui-resizable)") && this.uiDialog.resizable("option", s)
            },
            _setOption: function (t, e) {
                var i, n, s = this.uiDialog;
                "disabled" !== t && (this._super(t, e), "appendTo" === t && this.uiDialog.appendTo(this._appendTo()), "buttons" === t && this._createButtons(), "closeText" === t && this.uiDialogTitlebarClose.button({
                    label: x("<a>").text("" + this.options.closeText).html()
                }), "draggable" === t && ((i = s.is(":data(ui-draggable)")) && !e && s.draggable("destroy"), !i && e && this._makeDraggable()), "position" === t && this._position(), "resizable" === t && ((n = s.is(":data(ui-resizable)")) && !e && s.resizable("destroy"), n && "string" == typeof e && s.resizable("option", "handles", e), n || !1 === e || this._makeResizable()), "title" === t && this._title(this.uiDialogTitlebar.find(".ui-dialog-title")))
            },
            _size: function () {
                var t, e, i, n = this.options;
                this.element.show().css({
                    width: "auto",
                    minHeight: 0,
                    maxHeight: "none",
                    height: 0
                }), n.minWidth > n.width && (n.width = n.minWidth), t = this.uiDialog.css({
                    height: "auto",
                    width: n.width
                }).outerHeight(), e = Math.max(0, n.minHeight - t), i = "number" == typeof n.maxHeight ? Math.max(0, n.maxHeight - t) : "none", "auto" === n.height ? this.element.css({
                    minHeight: e,
                    maxHeight: i,
                    height: "auto"
                }) : this.element.height(Math.max(0, n.height - t)), this.uiDialog.is(":data(ui-resizable)") && this.uiDialog.resizable("option", "minHeight", this._minHeight())
            },
            _blockFrames: function () {
                this.iframeBlocks = this.document.find("iframe").map(function () {
                    var t = x(this);
                    return x("<div>").css({
                        position: "absolute",
                        width: t.outerWidth(),
                        height: t.outerHeight()
                    }).appendTo(t.parent()).offset(t.offset())[0]
                })
            },
            _unblockFrames: function () {
                this.iframeBlocks && (this.iframeBlocks.remove(), delete this.iframeBlocks)
            },
            _allowInteraction: function (t) {
                return !!x(t.target).closest(".ui-dialog").length || !!x(t.target).closest(".ui-datepicker").length
            },
            _createOverlay: function () {
                if (this.options.modal) {
                    var e = !0;
                    this._delay(function () {
                        e = !1
                    }), this.document.data("ui-dialog-overlays") || this._on(this.document, {
                        focusin: function (t) {
                            e || this._allowInteraction(t) || (t.preventDefault(), this._trackingInstances()[0]._focusTabbable())
                        }
                    }), this.overlay = x("<div>").appendTo(this._appendTo()), this._addClass(this.overlay, null, "ui-widget-overlay ui-front"), this._on(this.overlay, {
                        mousedown: "_keepFocus"
                    }), this.document.data("ui-dialog-overlays", (this.document.data("ui-dialog-overlays") || 0) + 1)
                }
            },
            _destroyOverlay: function () {
                if (this.options.modal && this.overlay) {
                    var t = this.document.data("ui-dialog-overlays") - 1;
                    t ? this.document.data("ui-dialog-overlays", t) : (this._off(this.document, "focusin"), this.document.removeData("ui-dialog-overlays")), this.overlay.remove(), this.overlay = null
                }
            }
        }), !1 !== x.uiBackCompat && x.widget("ui.dialog", x.ui.dialog, {
            options: {
                dialogClass: ""
            },
            _createWrapper: function () {
                this._super(), this.uiDialog.addClass(this.options.dialogClass)
            },
            _setOption: function (t, e) {
                "dialogClass" === t && this.uiDialog.removeClass(this.options.dialogClass).addClass(e), this._superApply(arguments)
            }
        }), x.ui.dialog, x.widget("ui.droppable", {
            version: "1.12.1",
            widgetEventPrefix: "drop",
            options: {
                accept: "*",
                addClasses: !0,
                greedy: !1,
                scope: "default",
                tolerance: "intersect",
                activate: null,
                deactivate: null,
                drop: null,
                out: null,
                over: null
            },
            _create: function () {
                var t, e = this.options,
                    i = e.accept;
                this.isover = !1, this.isout = !0, this.accept = x.isFunction(i) ? i : function (t) {
                    return t.is(i)
                }, this.proportions = function () {
                    return arguments.length ? void (t = arguments[0]) : t || (t = {
                        width: this.element[0].offsetWidth,
                        height: this.element[0].offsetHeight
                    })
                }, this._addToManager(e.scope), e.addClasses && this._addClass("ui-droppable")
            },
            _addToManager: function (t) {
                x.ui.ddmanager.droppables[t] = x.ui.ddmanager.droppables[t] || [], x.ui.ddmanager.droppables[t].push(this)
            },
            _splice: function (t) {
                for (var e = 0; t.length > e; e++) t[e] === this && t.splice(e, 1)
            },
            _destroy: function () {
                var t = x.ui.ddmanager.droppables[this.options.scope];
                this._splice(t)
            },
            _setOption: function (t, e) {
                if ("accept" === t) this.accept = x.isFunction(e) ? e : function (t) {
                    return t.is(e)
                };
                else if ("scope" === t) {
                    var i = x.ui.ddmanager.droppables[this.options.scope];
                    this._splice(i), this._addToManager(e)
                }
                this._super(t, e)
            },
            _activate: function (t) {
                var e = x.ui.ddmanager.current;
                this._addActiveClass(), e && this._trigger("activate", t, this.ui(e))
            },
            _deactivate: function (t) {
                var e = x.ui.ddmanager.current;
                this._removeActiveClass(), e && this._trigger("deactivate", t, this.ui(e))
            },
            _over: function (t) {
                var e = x.ui.ddmanager.current;
                e && (e.currentItem || e.element)[0] !== this.element[0] && this.accept.call(this.element[0], e.currentItem || e.element) && (this._addHoverClass(), this._trigger("over", t, this.ui(e)))
            },
            _out: function (t) {
                var e = x.ui.ddmanager.current;
                e && (e.currentItem || e.element)[0] !== this.element[0] && this.accept.call(this.element[0], e.currentItem || e.element) && (this._removeHoverClass(), this._trigger("out", t, this.ui(e)))
            },
            _drop: function (e, t) {
                var i = t || x.ui.ddmanager.current,
                    n = !1;
                return !(!i || (i.currentItem || i.element)[0] === this.element[0]) && (this.element.find(":data(ui-droppable)").not(".ui-draggable-dragging").each(function () {
                    var t = x(this).droppable("instance");
                    return t.options.greedy && !t.options.disabled && t.options.scope === i.options.scope && t.accept.call(t.element[0], i.currentItem || i.element) && rt(i, x.extend(t, {
                        offset: t.element.offset()
                    }), t.options.tolerance, e) ? !(n = !0) : void 0
                }), !n && (!!this.accept.call(this.element[0], i.currentItem || i.element) && (this._removeActiveClass(), this._removeHoverClass(), this._trigger("drop", e, this.ui(i)), this.element)))
            },
            ui: function (t) {
                return {
                    draggable: t.currentItem || t.element,
                    helper: t.helper,
                    position: t.position,
                    offset: t.positionAbs
                }
            },
            _addHoverClass: function () {
                this._addClass("ui-droppable-hover")
            },
            _removeHoverClass: function () {
                this._removeClass("ui-droppable-hover")
            },
            _addActiveClass: function () {
                this._addClass("ui-droppable-active")
            },
            _removeActiveClass: function () {
                this._removeClass("ui-droppable-active")
            }
        });
        var ot, rt = x.ui.intersect = function (t, e, i, n) {
            if (!e.offset) return !1;
            var s = (t.positionAbs || t.position.absolute).left + t.margins.left,
                o = (t.positionAbs || t.position.absolute).top + t.margins.top,
                r = s + t.helperProportions.width,
                a = o + t.helperProportions.height,
                l = e.offset.left,
                h = e.offset.top,
                c = l + e.proportions().width,
                u = h + e.proportions().height;
            switch (i) {
                case "fit":
                    return l <= s && r <= c && h <= o && a <= u;
                case "intersect":
                    return s + t.helperProportions.width / 2 > l && c > r - t.helperProportions.width / 2 && o + t.helperProportions.height / 2 > h && u > a - t.helperProportions.height / 2;
                case "pointer":
                    return at(n.pageY, h, e.proportions().height) && at(n.pageX, l, e.proportions().width);
                case "touch":
                    return (h <= o && o <= u || h <= a && a <= u || o < h && u < a) && (l <= s && s <= c || l <= r && r <= c || s < l && c < r);
                default:
                    return !1
            }
        };

        function at(t, e, i) {
            return e <= t && t < e + i
        } !(x.ui.ddmanager = {
            current: null,
            droppables: {
                default: []
            },
            prepareOffsets: function (t, e) {
                var i, n, s = x.ui.ddmanager.droppables[t.options.scope] || [],
                    o = e ? e.type : null,
                    r = (t.currentItem || t.element).find(":data(ui-droppable)").addBack();
                t: for (i = 0; s.length > i; i++)
                    if (!(s[i].options.disabled || t && !s[i].accept.call(s[i].element[0], t.currentItem || t.element))) {
                        for (n = 0; r.length > n; n++)
                            if (r[n] === s[i].element[0]) {
                                s[i].proportions().height = 0;
                                continue t
                            }
                        s[i].visible = "none" !== s[i].element.css("display"), s[i].visible && ("mousedown" === o && s[i]._activate.call(s[i], e), s[i].offset = s[i].element.offset(), s[i].proportions({
                            width: s[i].element[0].offsetWidth,
                            height: s[i].element[0].offsetHeight
                        }))
                    }
            },
            drop: function (t, e) {
                var i = !1;
                return x.each((x.ui.ddmanager.droppables[t.options.scope] || []).slice(), function () {
                    this.options && (!this.options.disabled && this.visible && rt(t, this, this.options.tolerance, e) && (i = this._drop.call(this, e) || i), !this.options.disabled && this.visible && this.accept.call(this.element[0], t.currentItem || t.element) && (this.isout = !0, this.isover = !1, this._deactivate.call(this, e)))
                }), i
            },
            dragStart: function (t, e) {
                t.element.parentsUntil("body").on("scroll.droppable", function () {
                    t.options.refreshPositions || x.ui.ddmanager.prepareOffsets(t, e)
                })
            },
            drag: function (o, r) {
                o.options.refreshPositions && x.ui.ddmanager.prepareOffsets(o, r), x.each(x.ui.ddmanager.droppables[o.options.scope] || [], function () {
                    if (!this.options.disabled && !this.greedyChild && this.visible) {
                        var t, e, i, n = rt(o, this, this.options.tolerance, r),
                            s = !n && this.isover ? "isout" : n && !this.isover ? "isover" : null;
                        s && (this.options.greedy && (e = this.options.scope, (i = this.element.parents(":data(ui-droppable)").filter(function () {
                            return x(this).droppable("instance").options.scope === e
                        })).length && ((t = x(i[0]).droppable("instance")).greedyChild = "isover" === s)), t && "isover" === s && (t.isover = !1, t.isout = !0, t._out.call(t, r)), this[s] = !0, this["isout" === s ? "isover" : "isout"] = !1, this["isover" === s ? "_over" : "_out"].call(this, r), t && "isout" === s && (t.isout = !1, t.isover = !0, t._over.call(t, r)))
                    }
                })
            },
            dragStop: function (t, e) {
                t.element.parentsUntil("body").off("scroll.droppable"), t.options.refreshPositions || x.ui.ddmanager.prepareOffsets(t, e)
            }
        }) !== x.uiBackCompat && x.widget("ui.droppable", x.ui.droppable, {
            options: {
                hoverClass: !1,
                activeClass: !1
            },
            _addActiveClass: function () {
                this._super(), this.options.activeClass && this.element.addClass(this.options.activeClass)
            },
            _removeActiveClass: function () {
                this._super(), this.options.activeClass && this.element.removeClass(this.options.activeClass)
            },
            _addHoverClass: function () {
                this._super(), this.options.hoverClass && this.element.addClass(this.options.hoverClass)
            },
            _removeHoverClass: function () {
                this._super(), this.options.hoverClass && this.element.removeClass(this.options.hoverClass)
            }
        }), x.ui.droppable, x.widget("ui.progressbar", {
            version: "1.12.1",
            options: {
                classes: {
                    "ui-progressbar": "ui-corner-all",
                    "ui-progressbar-value": "ui-corner-left",
                    "ui-progressbar-complete": "ui-corner-right"
                },
                max: 100,
                value: 0,
                change: null,
                complete: null
            },
            min: 0,
            _create: function () {
                this.oldValue = this.options.value = this._constrainedValue(), this.element.attr({
                    role: "progressbar",
                    "aria-valuemin": this.min
                }), this._addClass("ui-progressbar", "ui-widget ui-widget-content"), this.valueDiv = x("<div>").appendTo(this.element), this._addClass(this.valueDiv, "ui-progressbar-value", "ui-widget-header"), this._refreshValue()
            },
            _destroy: function () {
                this.element.removeAttr("role aria-valuemin aria-valuemax aria-valuenow"), this.valueDiv.remove()
            },
            value: function (t) {
                return void 0 === t ? this.options.value : (this.options.value = this._constrainedValue(t), void this._refreshValue())
            },
            _constrainedValue: function (t) {
                return void 0 === t && (t = this.options.value), this.indeterminate = !1 === t, "number" != typeof t && (t = 0), !this.indeterminate && Math.min(this.options.max, Math.max(this.min, t))
            },
            _setOptions: function (t) {
                var e = t.value;
                delete t.value, this._super(t), this.options.value = this._constrainedValue(e), this._refreshValue()
            },
            _setOption: function (t, e) {
                "max" === t && (e = Math.max(this.min, e)), this._super(t, e)
            },
            _setOptionDisabled: function (t) {
                this._super(t), this.element.attr("aria-disabled", t), this._toggleClass(null, "ui-state-disabled", !!t)
            },
            _percentage: function () {
                return this.indeterminate ? 100 : 100 * (this.options.value - this.min) / (this.options.max - this.min)
            },
            _refreshValue: function () {
                var t = this.options.value,
                    e = this._percentage();
                this.valueDiv.toggle(this.indeterminate || t > this.min).width(e.toFixed(0) + "%"), this._toggleClass(this.valueDiv, "ui-progressbar-complete", null, t === this.options.max)._toggleClass("ui-progressbar-indeterminate", null, this.indeterminate), this.indeterminate ? (this.element.removeAttr("aria-valuenow"), this.overlayDiv || (this.overlayDiv = x("<div>").appendTo(this.valueDiv), this._addClass(this.overlayDiv, "ui-progressbar-overlay"))) : (this.element.attr({
                    "aria-valuemax": this.options.max,
                    "aria-valuenow": t
                }), this.overlayDiv && (this.overlayDiv.remove(), this.overlayDiv = null)), this.oldValue !== t && (this.oldValue = t, this._trigger("change")), t === this.options.max && this._trigger("complete")
            }
        }), x.widget("ui.selectable", x.ui.mouse, {
            version: "1.12.1",
            options: {
                appendTo: "body",
                autoRefresh: !0,
                distance: 0,
                filter: "*",
                tolerance: "touch",
                selected: null,
                selecting: null,
                start: null,
                stop: null,
                unselected: null,
                unselecting: null
            },
            _create: function () {
                var n = this;
                this._addClass("ui-selectable"), this.dragged = !1, this.refresh = function () {
                    n.elementPos = x(n.element[0]).offset(), n.selectees = x(n.options.filter, n.element[0]), n._addClass(n.selectees, "ui-selectee"), n.selectees.each(function () {
                        var t = x(this),
                            e = t.offset(),
                            i = {
                                left: e.left - n.elementPos.left,
                                top: e.top - n.elementPos.top
                            };
                        x.data(this, "selectable-item", {
                            element: this,
                            $element: t,
                            left: i.left,
                            top: i.top,
                            right: i.left + t.outerWidth(),
                            bottom: i.top + t.outerHeight(),
                            startselected: !1,
                            selected: t.hasClass("ui-selected"),
                            selecting: t.hasClass("ui-selecting"),
                            unselecting: t.hasClass("ui-unselecting")
                        })
                    })
                }, this.refresh(), this._mouseInit(), this.helper = x("<div>"), this._addClass(this.helper, "ui-selectable-helper")
            },
            _destroy: function () {
                this.selectees.removeData("selectable-item"), this._mouseDestroy()
            },
            _mouseStart: function (i) {
                var n = this,
                    t = this.options;
                this.opos = [i.pageX, i.pageY], this.elementPos = x(this.element[0]).offset(), this.options.disabled || (this.selectees = x(t.filter, this.element[0]), this._trigger("start", i), x(t.appendTo).append(this.helper), this.helper.css({
                    left: i.pageX,
                    top: i.pageY,
                    width: 0,
                    height: 0
                }), t.autoRefresh && this.refresh(), this.selectees.filter(".ui-selected").each(function () {
                    var t = x.data(this, "selectable-item");
                    t.startselected = !0, i.metaKey || i.ctrlKey || (n._removeClass(t.$element, "ui-selected"), t.selected = !1, n._addClass(t.$element, "ui-unselecting"), t.unselecting = !0, n._trigger("unselecting", i, {
                        unselecting: t.element
                    }))
                }), x(i.target).parents().addBack().each(function () {
                    var t, e = x.data(this, "selectable-item");
                    return e ? (t = !i.metaKey && !i.ctrlKey || !e.$element.hasClass("ui-selected"), n._removeClass(e.$element, t ? "ui-unselecting" : "ui-selected")._addClass(e.$element, t ? "ui-selecting" : "ui-unselecting"), e.unselecting = !t, e.selecting = t, (e.selected = t) ? n._trigger("selecting", i, {
                        selecting: e.element
                    }) : n._trigger("unselecting", i, {
                        unselecting: e.element
                    }), !1) : void 0
                }))
            },
            _mouseDrag: function (n) {
                if (this.dragged = !0, !this.options.disabled) {
                    var t, s = this,
                        o = this.options,
                        r = this.opos[0],
                        a = this.opos[1],
                        l = n.pageX,
                        h = n.pageY;
                    return l < r && (t = l, l = r, r = t), h < a && (t = h, h = a, a = t), this.helper.css({
                        left: r,
                        top: a,
                        width: l - r,
                        height: h - a
                    }), this.selectees.each(function () {
                        var t = x.data(this, "selectable-item"),
                            e = !1,
                            i = {};
                        t && t.element !== s.element[0] && (i.left = t.left + s.elementPos.left, i.right = t.right + s.elementPos.left, i.top = t.top + s.elementPos.top, i.bottom = t.bottom + s.elementPos.top, "touch" === o.tolerance ? e = !(i.left > l || r > i.right || i.top > h || a > i.bottom) : "fit" === o.tolerance && (e = i.left > r && l > i.right && i.top > a && h > i.bottom), e ? (t.selected && (s._removeClass(t.$element, "ui-selected"), t.selected = !1), t.unselecting && (s._removeClass(t.$element, "ui-unselecting"), t.unselecting = !1), t.selecting || (s._addClass(t.$element, "ui-selecting"), t.selecting = !0, s._trigger("selecting", n, {
                            selecting: t.element
                        }))) : (t.selecting && ((n.metaKey || n.ctrlKey) && t.startselected ? (s._removeClass(t.$element, "ui-selecting"), t.selecting = !1, s._addClass(t.$element, "ui-selected"), t.selected = !0) : (s._removeClass(t.$element, "ui-selecting"), t.selecting = !1, t.startselected && (s._addClass(t.$element, "ui-unselecting"), t.unselecting = !0), s._trigger("unselecting", n, {
                            unselecting: t.element
                        }))), t.selected && (n.metaKey || n.ctrlKey || t.startselected || (s._removeClass(t.$element, "ui-selected"), t.selected = !1, s._addClass(t.$element, "ui-unselecting"), t.unselecting = !0, s._trigger("unselecting", n, {
                            unselecting: t.element
                        })))))
                    }), !1
                }
            },
            _mouseStop: function (e) {
                var i = this;
                return this.dragged = !1, x(".ui-unselecting", this.element[0]).each(function () {
                    var t = x.data(this, "selectable-item");
                    i._removeClass(t.$element, "ui-unselecting"), t.unselecting = !1, t.startselected = !1, i._trigger("unselected", e, {
                        unselected: t.element
                    })
                }), x(".ui-selecting", this.element[0]).each(function () {
                    var t = x.data(this, "selectable-item");
                    i._removeClass(t.$element, "ui-selecting")._addClass(t.$element, "ui-selected"), t.selecting = !1, t.selected = !0, t.startselected = !0, i._trigger("selected", e, {
                        selected: t.element
                    })
                }), this._trigger("stop", e), this.helper.remove(), !1
            }
        }), x.widget("ui.selectmenu", [x.ui.formResetMixin, {
            version: "1.12.1",
            defaultElement: "<select>",
            options: {
                appendTo: null,
                classes: {
                    "ui-selectmenu-button-open": "ui-corner-top",
                    "ui-selectmenu-button-closed": "ui-corner-all"
                },
                disabled: null,
                icons: {
                    button: "ui-icon-triangle-1-s"
                },
                position: {
                    my: "left top",
                    at: "left bottom",
                    collision: "none"
                },
                width: !1,
                change: null,
                close: null,
                focus: null,
                open: null,
                select: null
            },
            _create: function () {
                var t = this.element.uniqueId().attr("id");
                this.ids = {
                    element: t,
                    button: t + "-button",
                    menu: t + "-menu"
                }, this._drawButton(), this._drawMenu(), this._bindFormResetHandler(), this._rendered = !1, this.menuItems = x()
            },
            _drawButton: function () {
                var t, e = this,
                    i = this._parseOption(this.element.find("option:selected"), this.element[0].selectedIndex);
                this.labels = this.element.labels().attr("for", this.ids.button), this._on(this.labels, {
                    click: function (t) {
                        this.button.focus(), t.preventDefault()
                    }
                }), this.element.hide(), this.button = x("<span>", {
                    tabindex: this.options.disabled ? -1 : 0,
                    id: this.ids.button,
                    role: "combobox",
                    "aria-expanded": "false",
                    "aria-autocomplete": "list",
                    "aria-owns": this.ids.menu,
                    "aria-haspopup": "true",
                    title: this.element.attr("title")
                }).insertAfter(this.element), this._addClass(this.button, "ui-selectmenu-button ui-selectmenu-button-closed", "ui-button ui-widget"), t = x("<span>").appendTo(this.button), this._addClass(t, "ui-selectmenu-icon", "ui-icon " + this.options.icons.button), this.buttonItem = this._renderButtonItem(i).appendTo(this.button), !1 !== this.options.width && this._resizeButton(), this._on(this.button, this._buttonEvents), this.button.one("focusin", function () {
                    e._rendered || e._refreshMenu()
                })
            },
            _drawMenu: function () {
                var n = this;
                this.menu = x("<ul>", {
                    "aria-hidden": "true",
                    "aria-labelledby": this.ids.button,
                    id: this.ids.menu
                }), this.menuWrap = x("<div>").append(this.menu), this._addClass(this.menuWrap, "ui-selectmenu-menu", "ui-front"), this.menuWrap.appendTo(this._appendTo()), this.menuInstance = this.menu.menu({
                    classes: {
                        "ui-menu": "ui-corner-bottom"
                    },
                    role: "listbox",
                    select: function (t, e) {
                        t.preventDefault(), n._setSelection(), n._select(e.item.data("ui-selectmenu-item"), t)
                    },
                    focus: function (t, e) {
                        var i = e.item.data("ui-selectmenu-item");
                        null != n.focusIndex && i.index !== n.focusIndex && (n._trigger("focus", t, {
                            item: i
                        }), n.isOpen || n._select(i, t)), n.focusIndex = i.index, n.button.attr("aria-activedescendant", n.menuItems.eq(i.index).attr("id"))
                    }
                }).menu("instance"), this.menuInstance._off(this.menu, "mouseleave"), this.menuInstance._closeOnDocumentClick = function () {
                    return !1
                }, this.menuInstance._isDivider = function () {
                    return !1
                }
            },
            refresh: function () {
                this._refreshMenu(), this.buttonItem.replaceWith(this.buttonItem = this._renderButtonItem(this._getSelectedItem().data("ui-selectmenu-item") || {})), null === this.options.width && this._resizeButton()
            },
            _refreshMenu: function () {
                var t, e = this.element.find("option");
                this.menu.empty(), this._parseOptions(e), this._renderMenu(this.menu, this.items), this.menuInstance.refresh(), this.menuItems = this.menu.find("li").not(".ui-selectmenu-optgroup").find(".ui-menu-item-wrapper"), this._rendered = !0, e.length && (t = this._getSelectedItem(), this.menuInstance.focus(null, t), this._setAria(t.data("ui-selectmenu-item")), this._setOption("disabled", this.element.prop("disabled")))
            },
            open: function (t) {
                this.options.disabled || (this._rendered ? (this._removeClass(this.menu.find(".ui-state-active"), null, "ui-state-active"), this.menuInstance.focus(null, this._getSelectedItem())) : this._refreshMenu(), this.menuItems.length && (this.isOpen = !0, this._toggleAttr(), this._resizeMenu(), this._position(), this._on(this.document, this._documentClick), this._trigger("open", t)))
            },
            _position: function () {
                this.menuWrap.position(x.extend({
                    of: this.button
                }, this.options.position))
            },
            close: function (t) {
                this.isOpen && (this.isOpen = !1, this._toggleAttr(), this.range = null, this._off(this.document), this._trigger("close", t))
            },
            widget: function () {
                return this.button
            },
            menuWidget: function () {
                return this.menu
            },
            _renderButtonItem: function (t) {
                var e = x("<span>");
                return this._setText(e, t.label), this._addClass(e, "ui-selectmenu-text"), e
            },
            _renderMenu: function (n, t) {
                var s = this,
                    o = "";
                x.each(t, function (t, e) {
                    var i;
                    e.optgroup !== o && (i = x("<li>", {
                        text: e.optgroup
                    }), s._addClass(i, "ui-selectmenu-optgroup", "ui-menu-divider" + (e.element.parent("optgroup").prop("disabled") ? " ui-state-disabled" : "")), i.appendTo(n), o = e.optgroup), s._renderItemData(n, e)
                })
            },
            _renderItemData: function (t, e) {
                return this._renderItem(t, e).data("ui-selectmenu-item", e)
            },
            _renderItem: function (t, e) {
                var i = x("<li>"),
                    n = x("<div>", {
                        title: e.element.attr("title")
                    });
                return e.disabled && this._addClass(i, null, "ui-state-disabled"), this._setText(n, e.label), i.append(n).appendTo(t)
            },
            _setText: function (t, e) {
                e ? t.text(e) : t.html("&#160;")
            },
            _move: function (t, e) {
                var i, n, s = ".ui-menu-item";
                this.isOpen ? i = this.menuItems.eq(this.focusIndex).parent("li") : (i = this.menuItems.eq(this.element[0].selectedIndex).parent("li"), s += ":not(.ui-state-disabled)"), (n = "first" === t || "last" === t ? i["first" === t ? "prevAll" : "nextAll"](s).eq(-1) : i[t + "All"](s).eq(0)).length && this.menuInstance.focus(e, n)
            },
            _getSelectedItem: function () {
                return this.menuItems.eq(this.element[0].selectedIndex).parent("li")
            },
            _toggle: function (t) {
                this[this.isOpen ? "close" : "open"](t)
            },
            _setSelection: function () {
                var t;
                this.range && (window.getSelection ? ((t = window.getSelection()).removeAllRanges(), t.addRange(this.range)) : this.range.select(), this.button.focus())
            },
            _documentClick: {
                mousedown: function (t) {
                    this.isOpen && (x(t.target).closest(".ui-selectmenu-menu, #" + x.ui.escapeSelector(this.ids.button)).length || this.close(t))
                }
            },
            _buttonEvents: {
                mousedown: function () {
                    var t;
                    window.getSelection ? (t = window.getSelection()).rangeCount && (this.range = t.getRangeAt(0)) : this.range = document.selection.createRange()
                },
                click: function (t) {
                    this._setSelection(), this._toggle(t)
                },
                keydown: function (t) {
                    var e = !0;
                    switch (t.keyCode) {
                        case x.ui.keyCode.TAB:
                        case x.ui.keyCode.ESCAPE:
                            this.close(t), e = !1;
                            break;
                        case x.ui.keyCode.ENTER:
                            this.isOpen && this._selectFocusedItem(t);
                            break;
                        case x.ui.keyCode.UP:
                            t.altKey ? this._toggle(t) : this._move("prev", t);
                            break;
                        case x.ui.keyCode.DOWN:
                            t.altKey ? this._toggle(t) : this._move("next", t);
                            break;
                        case x.ui.keyCode.SPACE:
                            this.isOpen ? this._selectFocusedItem(t) : this._toggle(t);
                            break;
                        case x.ui.keyCode.LEFT:
                            this._move("prev", t);
                            break;
                        case x.ui.keyCode.RIGHT:
                            this._move("next", t);
                            break;
                        case x.ui.keyCode.HOME:
                        case x.ui.keyCode.PAGE_UP:
                            this._move("first", t);
                            break;
                        case x.ui.keyCode.END:
                        case x.ui.keyCode.PAGE_DOWN:
                            this._move("last", t);
                            break;
                        default:
                            this.menu.trigger(t), e = !1
                    }
                    e && t.preventDefault()
                }
            },
            _selectFocusedItem: function (t) {
                var e = this.menuItems.eq(this.focusIndex).parent("li");
                e.hasClass("ui-state-disabled") || this._select(e.data("ui-selectmenu-item"), t)
            },
            _select: function (t, e) {
                var i = this.element[0].selectedIndex;
                this.element[0].selectedIndex = t.index, this.buttonItem.replaceWith(this.buttonItem = this._renderButtonItem(t)), this._setAria(t), this._trigger("select", e, {
                    item: t
                }), t.index !== i && this._trigger("change", e, {
                    item: t
                }), this.close(e)
            },
            _setAria: function (t) {
                var e = this.menuItems.eq(t.index).attr("id");
                this.button.attr({
                    "aria-labelledby": e,
                    "aria-activedescendant": e
                }), this.menu.attr("aria-activedescendant", e)
            },
            _setOption: function (t, e) {
                if ("icons" === t) {
                    var i = this.button.find("span.ui-icon");
                    this._removeClass(i, null, this.options.icons.button)._addClass(i, null, e.button)
                }
                this._super(t, e), "appendTo" === t && this.menuWrap.appendTo(this._appendTo()), "width" === t && this._resizeButton()
            },
            _setOptionDisabled: function (t) {
                this._super(t), this.menuInstance.option("disabled", t), this.button.attr("aria-disabled", t), this._toggleClass(this.button, null, "ui-state-disabled", t), this.element.prop("disabled", t), t ? (this.button.attr("tabindex", -1), this.close()) : this.button.attr("tabindex", 0)
            },
            _appendTo: function () {
                var t = this.options.appendTo;
                return (t = t && (t.jquery || t.nodeType ? x(t) : this.document.find(t).eq(0))) && t[0] || (t = this.element.closest(".ui-front, dialog")), t.length || (t = this.document[0].body), t
            },
            _toggleAttr: function () {
                this.button.attr("aria-expanded", this.isOpen), this._removeClass(this.button, "ui-selectmenu-button-" + (this.isOpen ? "closed" : "open"))._addClass(this.button, "ui-selectmenu-button-" + (this.isOpen ? "open" : "closed"))._toggleClass(this.menuWrap, "ui-selectmenu-open", null, this.isOpen), this.menu.attr("aria-hidden", !this.isOpen)
            },
            _resizeButton: function () {
                var t = this.options.width;
                return !1 === t ? void this.button.css("width", "") : (null === t && (t = this.element.show().outerWidth(), this.element.hide()), void this.button.outerWidth(t))
            },
            _resizeMenu: function () {
                this.menu.outerWidth(Math.max(this.button.outerWidth(), this.menu.width("").outerWidth() + 1))
            },
            _getCreateOptions: function () {
                var t = this._super();
                return t.disabled = this.element.prop("disabled"), t
            },
            _parseOptions: function (t) {
                var i = this,
                    n = [];
                t.each(function (t, e) {
                    n.push(i._parseOption(x(e), t))
                }), this.items = n
            },
            _parseOption: function (t, e) {
                var i = t.parent("optgroup");
                return {
                    element: t,
                    index: e,
                    value: t.val(),
                    label: t.text(),
                    optgroup: i.attr("label") || "",
                    disabled: i.prop("disabled") || t.prop("disabled")
                }
            },
            _destroy: function () {
                this._unbindFormResetHandler(), this.menuWrap.remove(), this.button.remove(), this.element.show(), this.element.removeUniqueId(), this.labels.attr("for", this.ids.element)
            }
        }]), x.widget("ui.slider", x.ui.mouse, {
            version: "1.12.1",
            widgetEventPrefix: "slide",
            options: {
                animate: !1,
                classes: {
                    "ui-slider": "ui-corner-all",
                    "ui-slider-handle": "ui-corner-all",
                    "ui-slider-range": "ui-corner-all ui-widget-header"
                },
                distance: 0,
                max: 100,
                min: 0,
                orientation: "horizontal",
                range: !1,
                step: 1,
                value: 0,
                values: null,
                change: null,
                slide: null,
                start: null,
                stop: null
            },
            numPages: 5,
            _create: function () {
                this._keySliding = !1, this._mouseSliding = !1, this._animateOff = !0, this._handleIndex = null, this._detectOrientation(), this._mouseInit(), this._calculateNewMax(), this._addClass("ui-slider ui-slider-" + this.orientation, "ui-widget ui-widget-content"), this._refresh(), this._animateOff = !1
            },
            _refresh: function () {
                this._createRange(), this._createHandles(), this._setupEvents(), this._refreshValue()
            },
            _createHandles: function () {
                var t, e, i = this.options,
                    n = this.element.find(".ui-slider-handle"),
                    s = [];
                for (e = i.values && i.values.length || 1, n.length > e && (n.slice(e).remove(), n = n.slice(0, e)), t = n.length; t < e; t++) s.push("<span tabindex='0'></span>");
                this.handles = n.add(x(s.join("")).appendTo(this.element)), this._addClass(this.handles, "ui-slider-handle", "ui-state-default"), this.handle = this.handles.eq(0), this.handles.each(function (t) {
                    x(this).data("ui-slider-handle-index", t).attr("tabIndex", 0)
                })
            },
            _createRange: function () {
                var t = this.options;
                t.range ? (!0 === t.range && (t.values ? t.values.length && 2 !== t.values.length ? t.values = [t.values[0], t.values[0]] : x.isArray(t.values) && (t.values = t.values.slice(0)) : t.values = [this._valueMin(), this._valueMin()]), this.range && this.range.length ? (this._removeClass(this.range, "ui-slider-range-min ui-slider-range-max"), this.range.css({
                    left: "",
                    bottom: ""
                })) : (this.range = x("<div>").appendTo(this.element), this._addClass(this.range, "ui-slider-range")), "min" !== t.range && "max" !== t.range || this._addClass(this.range, "ui-slider-range-" + t.range)) : (this.range && this.range.remove(), this.range = null)
            },
            _setupEvents: function () {
                this._off(this.handles), this._on(this.handles, this._handleEvents), this._hoverable(this.handles), this._focusable(this.handles)
            },
            _destroy: function () {
                this.handles.remove(), this.range && this.range.remove(), this._mouseDestroy()
            },
            _mouseCapture: function (t) {
                var e, i, n, s, o, r, a, l = this,
                    h = this.options;
                return !h.disabled && (this.elementSize = {
                    width: this.element.outerWidth(),
                    height: this.element.outerHeight()
                }, this.elementOffset = this.element.offset(), e = {
                    x: t.pageX,
                    y: t.pageY
                }, i = this._normValueFromMouse(e), n = this._valueMax() - this._valueMin() + 1, this.handles.each(function (t) {
                    var e = Math.abs(i - l.values(t));
                    (e < n || n === e && (t === l._lastChangedValue || l.values(t) === h.min)) && (n = e, s = x(this), o = t)
                }), !1 !== this._start(t, o) && (this._mouseSliding = !0, this._handleIndex = o, this._addClass(s, null, "ui-state-active"), s.trigger("focus"), r = s.offset(), a = !x(t.target).parents().addBack().is(".ui-slider-handle"), this._clickOffset = a ? {
                    left: 0,
                    top: 0
                } : {
                        left: t.pageX - r.left - s.width() / 2,
                        top: t.pageY - r.top - s.height() / 2 - (parseInt(s.css("borderTopWidth"), 10) || 0) - (parseInt(s.css("borderBottomWidth"), 10) || 0) + (parseInt(s.css("marginTop"), 10) || 0)
                    }, this.handles.hasClass("ui-state-hover") || this._slide(t, o, i), this._animateOff = !0))
            },
            _mouseStart: function () {
                return !0
            },
            _mouseDrag: function (t) {
                var e = {
                    x: t.pageX,
                    y: t.pageY
                },
                    i = this._normValueFromMouse(e);
                return this._slide(t, this._handleIndex, i), !1
            },
            _mouseStop: function (t) {
                return this._removeClass(this.handles, null, "ui-state-active"), this._mouseSliding = !1, this._stop(t, this._handleIndex), this._change(t, this._handleIndex), this._handleIndex = null, this._clickOffset = null, this._animateOff = !1
            },
            _detectOrientation: function () {
                this.orientation = "vertical" === this.options.orientation ? "vertical" : "horizontal"
            },
            _normValueFromMouse: function (t) {
                var e, i, n, s;
                return 1 < (i = ("horizontal" === this.orientation ? (e = this.elementSize.width, t.x - this.elementOffset.left - (this._clickOffset ? this._clickOffset.left : 0)) : (e = this.elementSize.height, t.y - this.elementOffset.top - (this._clickOffset ? this._clickOffset.top : 0))) / e) && (i = 1), i < 0 && (i = 0), "vertical" === this.orientation && (i = 1 - i), n = this._valueMax() - this._valueMin(), s = this._valueMin() + i * n, this._trimAlignValue(s)
            },
            _uiHash: function (t, e, i) {
                var n = {
                    handle: this.handles[t],
                    handleIndex: t,
                    value: void 0 !== e ? e : this.value()
                };
                return this._hasMultipleValues() && (n.value = void 0 !== e ? e : this.values(t), n.values = i || this.values()), n
            },
            _hasMultipleValues: function () {
                return this.options.values && this.options.values.length
            },
            _start: function (t, e) {
                return this._trigger("start", t, this._uiHash(e))
            },
            _slide: function (t, e, i) {
                var n, s = this.value(),
                    o = this.values();
                this._hasMultipleValues() && (n = this.values(e ? 0 : 1), s = this.values(e), 2 === this.options.values.length && !0 === this.options.range && (i = 0 === e ? Math.min(n, i) : Math.max(n, i)), o[e] = i), i === s || !1 !== this._trigger("slide", t, this._uiHash(e, i, o)) && (this._hasMultipleValues() ? this.values(e, i) : this.value(i))
            },
            _stop: function (t, e) {
                this._trigger("stop", t, this._uiHash(e))
            },
            _change: function (t, e) {
                this._keySliding || this._mouseSliding || (this._lastChangedValue = e, this._trigger("change", t, this._uiHash(e)))
            },
            value: function (t) {
                return arguments.length ? (this.options.value = this._trimAlignValue(t), this._refreshValue(), void this._change(null, 0)) : this._value()
            },
            values: function (t, e) {
                var i, n, s;
                if (1 < arguments.length) return this.options.values[t] = this._trimAlignValue(e), this._refreshValue(), void this._change(null, t);
                if (!arguments.length) return this._values();
                if (!x.isArray(t)) return this._hasMultipleValues() ? this._values(t) : this.value();
                for (i = this.options.values, n = t, s = 0; i.length > s; s += 1) i[s] = this._trimAlignValue(n[s]), this._change(null, s);
                this._refreshValue()
            },
            _setOption: function (t, e) {
                var i, n = 0;
                switch ("range" === t && !0 === this.options.range && ("min" === e ? (this.options.value = this._values(0), this.options.values = null) : "max" === e && (this.options.value = this._values(this.options.values.length - 1), this.options.values = null)), x.isArray(this.options.values) && (n = this.options.values.length), this._super(t, e), t) {
                    case "orientation":
                        this._detectOrientation(), this._removeClass("ui-slider-horizontal ui-slider-vertical")._addClass("ui-slider-" + this.orientation), this._refreshValue(), this.options.range && this._refreshRange(e), this.handles.css("horizontal" === e ? "bottom" : "left", "");
                        break;
                    case "value":
                        this._animateOff = !0, this._refreshValue(), this._change(null, 0), this._animateOff = !1;
                        break;
                    case "values":
                        for (this._animateOff = !0, this._refreshValue(), i = n - 1; 0 <= i; i--) this._change(null, i);
                        this._animateOff = !1;
                        break;
                    case "step":
                    case "min":
                    case "max":
                        this._animateOff = !0, this._calculateNewMax(), this._refreshValue(), this._animateOff = !1;
                        break;
                    case "range":
                        this._animateOff = !0, this._refresh(), this._animateOff = !1
                }
            },
            _setOptionDisabled: function (t) {
                this._super(t), this._toggleClass(null, "ui-state-disabled", !!t)
            },
            _value: function () {
                var t = this.options.value;
                return this._trimAlignValue(t)
            },
            _values: function (t) {
                var e, i, n;
                if (arguments.length) return e = this.options.values[t], this._trimAlignValue(e);
                if (this._hasMultipleValues()) {
                    for (i = this.options.values.slice(), n = 0; i.length > n; n += 1) i[n] = this._trimAlignValue(i[n]);
                    return i
                }
                return []
            },
            _trimAlignValue: function (t) {
                if (this._valueMin() >= t) return this._valueMin();
                if (t >= this._valueMax()) return this._valueMax();
                var e = 0 < this.options.step ? this.options.step : 1,
                    i = (t - this._valueMin()) % e,
                    n = t - i;
                return 2 * Math.abs(i) >= e && (n += 0 < i ? e : -e), parseFloat(n.toFixed(5))
            },
            _calculateNewMax: function () {
                var t = this.options.max,
                    e = this._valueMin(),
                    i = this.options.step;
                (t = Math.round((t - e) / i) * i + e) > this.options.max && (t -= i), this.max = parseFloat(t.toFixed(this._precision()))
            },
            _precision: function () {
                var t = this._precisionOf(this.options.step);
                return null !== this.options.min && (t = Math.max(t, this._precisionOf(this.options.min))), t
            },
            _precisionOf: function (t) {
                var e = "" + t,
                    i = e.indexOf(".");
                return -1 === i ? 0 : e.length - i - 1
            },
            _valueMin: function () {
                return this.options.min
            },
            _valueMax: function () {
                return this.max
            },
            _refreshRange: function (t) {
                "vertical" === t && this.range.css({
                    width: "",
                    left: ""
                }), "horizontal" === t && this.range.css({
                    height: "",
                    bottom: ""
                })
            },
            _refreshValue: function () {
                var e, i, t, n, s, o = this.options.range,
                    r = this.options,
                    a = this,
                    l = !this._animateOff && r.animate,
                    h = {};
                this._hasMultipleValues() ? this.handles.each(function (t) {
                    i = (a.values(t) - a._valueMin()) / (a._valueMax() - a._valueMin()) * 100, h["horizontal" === a.orientation ? "left" : "bottom"] = i + "%", x(this).stop(1, 1)[l ? "animate" : "css"](h, r.animate), !0 === a.options.range && ("horizontal" === a.orientation ? (0 === t && a.range.stop(1, 1)[l ? "animate" : "css"]({
                        left: i + "%"
                    }, r.animate), 1 === t && a.range[l ? "animate" : "css"]({
                        width: i - e + "%"
                    }, {
                        queue: !1,
                        duration: r.animate
                    })) : (0 === t && a.range.stop(1, 1)[l ? "animate" : "css"]({
                        bottom: i + "%"
                    }, r.animate), 1 === t && a.range[l ? "animate" : "css"]({
                        height: i - e + "%"
                    }, {
                        queue: !1,
                        duration: r.animate
                    }))), e = i
                }) : (t = this.value(), n = this._valueMin(), s = this._valueMax(), i = s !== n ? (t - n) / (s - n) * 100 : 0, h["horizontal" === this.orientation ? "left" : "bottom"] = i + "%", this.handle.stop(1, 1)[l ? "animate" : "css"](h, r.animate), "min" === o && "horizontal" === this.orientation && this.range.stop(1, 1)[l ? "animate" : "css"]({
                    width: i + "%"
                }, r.animate), "max" === o && "horizontal" === this.orientation && this.range.stop(1, 1)[l ? "animate" : "css"]({
                    width: 100 - i + "%"
                }, r.animate), "min" === o && "vertical" === this.orientation && this.range.stop(1, 1)[l ? "animate" : "css"]({
                    height: i + "%"
                }, r.animate), "max" === o && "vertical" === this.orientation && this.range.stop(1, 1)[l ? "animate" : "css"]({
                    height: 100 - i + "%"
                }, r.animate))
            },
            _handleEvents: {
                keydown: function (t) {
                    var e, i, n, s = x(t.target).data("ui-slider-handle-index");
                    switch (t.keyCode) {
                        case x.ui.keyCode.HOME:
                        case x.ui.keyCode.END:
                        case x.ui.keyCode.PAGE_UP:
                        case x.ui.keyCode.PAGE_DOWN:
                        case x.ui.keyCode.UP:
                        case x.ui.keyCode.RIGHT:
                        case x.ui.keyCode.DOWN:
                        case x.ui.keyCode.LEFT:
                            if (t.preventDefault(), !this._keySliding && (this._keySliding = !0, this._addClass(x(t.target), null, "ui-state-active"), !1 === this._start(t, s))) return
                    }
                    switch (n = this.options.step, e = i = this._hasMultipleValues() ? this.values(s) : this.value(), t.keyCode) {
                        case x.ui.keyCode.HOME:
                            i = this._valueMin();
                            break;
                        case x.ui.keyCode.END:
                            i = this._valueMax();
                            break;
                        case x.ui.keyCode.PAGE_UP:
                            i = this._trimAlignValue(e + (this._valueMax() - this._valueMin()) / this.numPages);
                            break;
                        case x.ui.keyCode.PAGE_DOWN:
                            i = this._trimAlignValue(e - (this._valueMax() - this._valueMin()) / this.numPages);
                            break;
                        case x.ui.keyCode.UP:
                        case x.ui.keyCode.RIGHT:
                            if (e === this._valueMax()) return;
                            i = this._trimAlignValue(e + n);
                            break;
                        case x.ui.keyCode.DOWN:
                        case x.ui.keyCode.LEFT:
                            if (e === this._valueMin()) return;
                            i = this._trimAlignValue(e - n)
                    }
                    this._slide(t, s, i)
                },
                keyup: function (t) {
                    var e = x(t.target).data("ui-slider-handle-index");
                    this._keySliding && (this._keySliding = !1, this._stop(t, e), this._change(t, e), this._removeClass(x(t.target), null, "ui-state-active"))
                }
            }
        }), x.widget("ui.sortable", x.ui.mouse, {
            version: "1.12.1",
            widgetEventPrefix: "sort",
            ready: !1,
            options: {
                appendTo: "parent",
                axis: !1,
                connectWith: !1,
                containment: !1,
                cursor: "auto",
                cursorAt: !1,
                dropOnEmpty: !0,
                forcePlaceholderSize: !1,
                forceHelperSize: !1,
                grid: !1,
                handle: !1,
                helper: "original",
                items: "> *",
                opacity: !1,
                placeholder: !1,
                revert: !1,
                scroll: !0,
                scrollSensitivity: 20,
                scrollSpeed: 20,
                scope: "default",
                tolerance: "intersect",
                zIndex: 1e3,
                activate: null,
                beforeStop: null,
                change: null,
                deactivate: null,
                out: null,
                over: null,
                receive: null,
                remove: null,
                sort: null,
                start: null,
                stop: null,
                update: null
            },
            _isOverAxis: function (t, e, i) {
                return e <= t && t < e + i
            },
            _isFloating: function (t) {
                return /left|right/.test(t.css("float")) || /inline|table-cell/.test(t.css("display"))
            },
            _create: function () {
                this.containerCache = {}, this._addClass("ui-sortable"), this.refresh(), this.offset = this.element.offset(), this._mouseInit(), this._setHandleClassName(), this.ready = !0
            },
            _setOption: function (t, e) {
                this._super(t, e), "handle" === t && this._setHandleClassName()
            },
            _setHandleClassName: function () {
                var t = this;
                this._removeClass(this.element.find(".ui-sortable-handle"), "ui-sortable-handle"), x.each(this.items, function () {
                    t._addClass(this.instance.options.handle ? this.item.find(this.instance.options.handle) : this.item, "ui-sortable-handle")
                })
            },
            _destroy: function () {
                this._mouseDestroy();
                for (var t = this.items.length - 1; 0 <= t; t--) this.items[t].item.removeData(this.widgetName + "-item");
                return this
            },
            _mouseCapture: function (t, e) {
                var i = null,
                    n = !1,
                    s = this;
                return !this.reverting && (!this.options.disabled && "static" !== this.options.type && (this._refreshItems(t), x(t.target).parents().each(function () {
                    return x.data(this, s.widgetName + "-item") === s ? (i = x(this), !1) : void 0
                }), x.data(t.target, s.widgetName + "-item") === s && (i = x(t.target)), !!i && (!(this.options.handle && !e && (x(this.options.handle, i).find("*").addBack().each(function () {
                    this === t.target && (n = !0)
                }), !n)) && (this.currentItem = i, this._removeCurrentsFromItems(), !0))))
            },
            _mouseStart: function (t, e, i) {
                var n, s, o = this.options;
                if ((this.currentContainer = this).refreshPositions(), this.helper = this._createHelper(t), this._cacheHelperProportions(), this._cacheMargins(), this.scrollParent = this.helper.scrollParent(), this.offset = this.currentItem.offset(), this.offset = {
                    top: this.offset.top - this.margins.top,
                    left: this.offset.left - this.margins.left
                }, x.extend(this.offset, {
                    click: {
                        left: t.pageX - this.offset.left,
                        top: t.pageY - this.offset.top
                    },
                    parent: this._getParentOffset(),
                    relative: this._getRelativeOffset()
                }), this.helper.css("position", "absolute"), this.cssPosition = this.helper.css("position"), this.originalPosition = this._generatePosition(t), this.originalPageX = t.pageX, this.originalPageY = t.pageY, o.cursorAt && this._adjustOffsetFromHelper(o.cursorAt), this.domPosition = {
                    prev: this.currentItem.prev()[0],
                    parent: this.currentItem.parent()[0]
                }, this.helper[0] !== this.currentItem[0] && this.currentItem.hide(), this._createPlaceholder(), o.containment && this._setContainment(), o.cursor && "auto" !== o.cursor && (s = this.document.find("body"), this.storedCursor = s.css("cursor"), s.css("cursor", o.cursor), this.storedStylesheet = x("<style>*{ cursor: " + o.cursor + " !important; }</style>").appendTo(s)), o.opacity && (this.helper.css("opacity") && (this._storedOpacity = this.helper.css("opacity")), this.helper.css("opacity", o.opacity)), o.zIndex && (this.helper.css("zIndex") && (this._storedZIndex = this.helper.css("zIndex")), this.helper.css("zIndex", o.zIndex)), this.scrollParent[0] !== this.document[0] && "HTML" !== this.scrollParent[0].tagName && (this.overflowOffset = this.scrollParent.offset()), this._trigger("start", t, this._uiHash()), this._preserveHelperProportions || this._cacheHelperProportions(), !i)
                    for (n = this.containers.length - 1; 0 <= n; n--) this.containers[n]._trigger("activate", t, this._uiHash(this));
                return x.ui.ddmanager && (x.ui.ddmanager.current = this), x.ui.ddmanager && !o.dropBehaviour && x.ui.ddmanager.prepareOffsets(this, t), this.dragging = !0, this._addClass(this.helper, "ui-sortable-helper"), this._mouseDrag(t), !0
            },
            _mouseDrag: function (t) {
                var e, i, n, s, o = this.options,
                    r = !1;
                for (this.position = this._generatePosition(t), this.positionAbs = this._convertPositionTo("absolute"), this.lastPositionAbs || (this.lastPositionAbs = this.positionAbs), this.options.scroll && (this.scrollParent[0] !== this.document[0] && "HTML" !== this.scrollParent[0].tagName ? (this.overflowOffset.top + this.scrollParent[0].offsetHeight - t.pageY < o.scrollSensitivity ? this.scrollParent[0].scrollTop = r = this.scrollParent[0].scrollTop + o.scrollSpeed : t.pageY - this.overflowOffset.top < o.scrollSensitivity && (this.scrollParent[0].scrollTop = r = this.scrollParent[0].scrollTop - o.scrollSpeed), this.overflowOffset.left + this.scrollParent[0].offsetWidth - t.pageX < o.scrollSensitivity ? this.scrollParent[0].scrollLeft = r = this.scrollParent[0].scrollLeft + o.scrollSpeed : t.pageX - this.overflowOffset.left < o.scrollSensitivity && (this.scrollParent[0].scrollLeft = r = this.scrollParent[0].scrollLeft - o.scrollSpeed)) : (t.pageY - this.document.scrollTop() < o.scrollSensitivity ? r = this.document.scrollTop(this.document.scrollTop() - o.scrollSpeed) : this.window.height() - (t.pageY - this.document.scrollTop()) < o.scrollSensitivity && (r = this.document.scrollTop(this.document.scrollTop() + o.scrollSpeed)), t.pageX - this.document.scrollLeft() < o.scrollSensitivity ? r = this.document.scrollLeft(this.document.scrollLeft() - o.scrollSpeed) : this.window.width() - (t.pageX - this.document.scrollLeft()) < o.scrollSensitivity && (r = this.document.scrollLeft(this.document.scrollLeft() + o.scrollSpeed))), !1 !== r && x.ui.ddmanager && !o.dropBehaviour && x.ui.ddmanager.prepareOffsets(this, t)), this.positionAbs = this._convertPositionTo("absolute"), this.options.axis && "y" === this.options.axis || (this.helper[0].style.left = this.position.left + "px"), this.options.axis && "x" === this.options.axis || (this.helper[0].style.top = this.position.top + "px"), e = this.items.length - 1; 0 <= e; e--)
                    if (n = (i = this.items[e]).item[0], (s = this._intersectsWithPointer(i)) && i.instance === this.currentContainer && n !== this.currentItem[0] && this.placeholder[1 === s ? "next" : "prev"]()[0] !== n && !x.contains(this.placeholder[0], n) && ("semi-dynamic" !== this.options.type || !x.contains(this.element[0], n))) {
                        if (this.direction = 1 === s ? "down" : "up", "pointer" !== this.options.tolerance && !this._intersectsWithSides(i)) break;
                        this._rearrange(t, i), this._trigger("change", t, this._uiHash());
                        break
                    }
                return this._contactContainers(t), x.ui.ddmanager && x.ui.ddmanager.drag(this, t), this._trigger("sort", t, this._uiHash()), this.lastPositionAbs = this.positionAbs, !1
            },
            _mouseStop: function (t, e) {
                if (t) {
                    if (x.ui.ddmanager && !this.options.dropBehaviour && x.ui.ddmanager.drop(this, t), this.options.revert) {
                        var i = this,
                            n = this.placeholder.offset(),
                            s = this.options.axis,
                            o = {};
                        s && "x" !== s || (o.left = n.left - this.offset.parent.left - this.margins.left + (this.offsetParent[0] === this.document[0].body ? 0 : this.offsetParent[0].scrollLeft)), s && "y" !== s || (o.top = n.top - this.offset.parent.top - this.margins.top + (this.offsetParent[0] === this.document[0].body ? 0 : this.offsetParent[0].scrollTop)), this.reverting = !0, x(this.helper).animate(o, parseInt(this.options.revert, 10) || 500, function () {
                            i._clear(t)
                        })
                    } else this._clear(t, e);
                    return !1
                }
            },
            cancel: function () {
                if (this.dragging) {
                    this._mouseUp(new x.Event("mouseup", {
                        target: null
                    })), "original" === this.options.helper ? (this.currentItem.css(this._storedCSS), this._removeClass(this.currentItem, "ui-sortable-helper")) : this.currentItem.show();
                    for (var t = this.containers.length - 1; 0 <= t; t--) this.containers[t]._trigger("deactivate", null, this._uiHash(this)), this.containers[t].containerCache.over && (this.containers[t]._trigger("out", null, this._uiHash(this)), this.containers[t].containerCache.over = 0)
                }
                return this.placeholder && (this.placeholder[0].parentNode && this.placeholder[0].parentNode.removeChild(this.placeholder[0]), "original" !== this.options.helper && this.helper && this.helper[0].parentNode && this.helper.remove(), x.extend(this, {
                    helper: null,
                    dragging: !1,
                    reverting: !1,
                    _noFinalSort: null
                }), this.domPosition.prev ? x(this.domPosition.prev).after(this.currentItem) : x(this.domPosition.parent).prepend(this.currentItem)), this
            },
            serialize: function (e) {
                var t = this._getItemsAsjQuery(e && e.connected),
                    i = [];
                return e = e || {}, x(t).each(function () {
                    var t = (x(e.item || this).attr(e.attribute || "id") || "").match(e.expression || /(.+)[\-=_](.+)/);
                    t && i.push((e.key || t[1] + "[]") + "=" + (e.key && e.expression ? t[1] : t[2]))
                }), !i.length && e.key && i.push(e.key + "="), i.join("&")
            },
            toArray: function (t) {
                var e = this._getItemsAsjQuery(t && t.connected),
                    i = [];
                return t = t || {}, e.each(function () {
                    i.push(x(t.item || this).attr(t.attribute || "id") || "")
                }), i
            },
            _intersectsWith: function (t) {
                var e = this.positionAbs.left,
                    i = e + this.helperProportions.width,
                    n = this.positionAbs.top,
                    s = n + this.helperProportions.height,
                    o = t.left,
                    r = o + t.width,
                    a = t.top,
                    l = a + t.height,
                    h = this.offset.click.top,
                    c = this.offset.click.left,
                    u = "x" === this.options.axis || a < n + h && n + h < l,
                    d = "y" === this.options.axis || o < e + c && e + c < r,
                    p = u && d;
                return "pointer" === this.options.tolerance || this.options.forcePointerForContainers || "pointer" !== this.options.tolerance && this.helperProportions[this.floating ? "width" : "height"] > t[this.floating ? "width" : "height"] ? p : e + this.helperProportions.width / 2 > o && r > i - this.helperProportions.width / 2 && n + this.helperProportions.height / 2 > a && l > s - this.helperProportions.height / 2
            },
            _intersectsWithPointer: function (t) {
                var e, i, n = "x" === this.options.axis || this._isOverAxis(this.positionAbs.top + this.offset.click.top, t.top, t.height),
                    s = "y" === this.options.axis || this._isOverAxis(this.positionAbs.left + this.offset.click.left, t.left, t.width);
                return !!(n && s) && (e = this._getDragVerticalDirection(), i = this._getDragHorizontalDirection(), this.floating ? "right" === i || "down" === e ? 2 : 1 : e && ("down" === e ? 2 : 1))
            },
            _intersectsWithSides: function (t) {
                var e = this._isOverAxis(this.positionAbs.top + this.offset.click.top, t.top + t.height / 2, t.height),
                    i = this._isOverAxis(this.positionAbs.left + this.offset.click.left, t.left + t.width / 2, t.width),
                    n = this._getDragVerticalDirection(),
                    s = this._getDragHorizontalDirection();
                return this.floating && s ? "right" === s && i || "left" === s && !i : n && ("down" === n && e || "up" === n && !e)
            },
            _getDragVerticalDirection: function () {
                var t = this.positionAbs.top - this.lastPositionAbs.top;
                return 0 != t && (0 < t ? "down" : "up")
            },
            _getDragHorizontalDirection: function () {
                var t = this.positionAbs.left - this.lastPositionAbs.left;
                return 0 != t && (0 < t ? "right" : "left")
            },
            refresh: function (t) {
                return this._refreshItems(t), this._setHandleClassName(), this.refreshPositions(), this
            },
            _connectWith: function () {
                var t = this.options;
                return t.connectWith.constructor === String ? [t.connectWith] : t.connectWith
            },
            _getItemsAsjQuery: function (t) {
                function e() {
                    r.push(this)
                }
                var i, n, s, o, r = [],
                    a = [],
                    l = this._connectWith();
                if (l && t)
                    for (i = l.length - 1; 0 <= i; i--)
                        for (n = (s = x(l[i], this.document[0])).length - 1; 0 <= n; n--)(o = x.data(s[n], this.widgetFullName)) && o !== this && !o.options.disabled && a.push([x.isFunction(o.options.items) ? o.options.items.call(o.element) : x(o.options.items, o.element).not(".ui-sortable-helper").not(".ui-sortable-placeholder"), o]);
                for (a.push([x.isFunction(this.options.items) ? this.options.items.call(this.element, null, {
                    options: this.options,
                    item: this.currentItem
                }) : x(this.options.items, this.element).not(".ui-sortable-helper").not(".ui-sortable-placeholder"), this]), i = a.length - 1; 0 <= i; i--) a[i][0].each(e);
                return x(r)
            },
            _removeCurrentsFromItems: function () {
                var i = this.currentItem.find(":data(" + this.widgetName + "-item)");
                this.items = x.grep(this.items, function (t) {
                    for (var e = 0; i.length > e; e++)
                        if (i[e] === t.item[0]) return !1;
                    return !0
                })
            },
            _refreshItems: function (t) {
                this.items = [], this.containers = [this];
                var e, i, n, s, o, r, a, l, h = this.items,
                    c = [
                        [x.isFunction(this.options.items) ? this.options.items.call(this.element[0], t, {
                            item: this.currentItem
                        }) : x(this.options.items, this.element), this]
                    ],
                    u = this._connectWith();
                if (u && this.ready)
                    for (e = u.length - 1; 0 <= e; e--)
                        for (i = (n = x(u[e], this.document[0])).length - 1; 0 <= i; i--)(s = x.data(n[i], this.widgetFullName)) && s !== this && !s.options.disabled && (c.push([x.isFunction(s.options.items) ? s.options.items.call(s.element[0], t, {
                            item: this.currentItem
                        }) : x(s.options.items, s.element), s]), this.containers.push(s));
                for (e = c.length - 1; 0 <= e; e--)
                    for (o = c[e][1], i = 0, l = (r = c[e][0]).length; i < l; i++)(a = x(r[i])).data(this.widgetName + "-item", o), h.push({
                        item: a,
                        instance: o,
                        width: 0,
                        height: 0,
                        left: 0,
                        top: 0
                    })
            },
            refreshPositions: function (t) {
                var e, i, n, s;
                for (this.floating = !!this.items.length && ("x" === this.options.axis || this._isFloating(this.items[0].item)), this.offsetParent && this.helper && (this.offset.parent = this._getParentOffset()), e = this.items.length - 1; 0 <= e; e--)(i = this.items[e]).instance !== this.currentContainer && this.currentContainer && i.item[0] !== this.currentItem[0] || (n = this.options.toleranceElement ? x(this.options.toleranceElement, i.item) : i.item, t || (i.width = n.outerWidth(), i.height = n.outerHeight()), s = n.offset(), i.left = s.left, i.top = s.top);
                if (this.options.custom && this.options.custom.refreshContainers) this.options.custom.refreshContainers.call(this);
                else
                    for (e = this.containers.length - 1; 0 <= e; e--) s = this.containers[e].element.offset(), this.containers[e].containerCache.left = s.left, this.containers[e].containerCache.top = s.top, this.containers[e].containerCache.width = this.containers[e].element.outerWidth(), this.containers[e].containerCache.height = this.containers[e].element.outerHeight();
                return this
            },
            _createPlaceholder: function (i) {
                var n, s = (i = i || this).options;
                s.placeholder && s.placeholder.constructor !== String || (n = s.placeholder, s.placeholder = {
                    element: function () {
                        var t = i.currentItem[0].nodeName.toLowerCase(),
                            e = x("<" + t + ">", i.document[0]);
                        return i._addClass(e, "ui-sortable-placeholder", n || i.currentItem[0].className)._removeClass(e, "ui-sortable-helper"), "tbody" === t ? i._createTrPlaceholder(i.currentItem.find("tr").eq(0), x("<tr>", i.document[0]).appendTo(e)) : "tr" === t ? i._createTrPlaceholder(i.currentItem, e) : "img" === t && e.attr("src", i.currentItem.attr("src")), n || e.css("visibility", "hidden"), e
                    },
                    update: function (t, e) {
                        n && !s.forcePlaceholderSize || (e.height() || e.height(i.currentItem.innerHeight() - parseInt(i.currentItem.css("paddingTop") || 0, 10) - parseInt(i.currentItem.css("paddingBottom") || 0, 10)), e.width() || e.width(i.currentItem.innerWidth() - parseInt(i.currentItem.css("paddingLeft") || 0, 10) - parseInt(i.currentItem.css("paddingRight") || 0, 10)))
                    }
                }), i.placeholder = x(s.placeholder.element.call(i.element, i.currentItem)), i.currentItem.after(i.placeholder), s.placeholder.update(i, i.placeholder)
            },
            _createTrPlaceholder: function (t, e) {
                var i = this;
                t.children().each(function () {
                    x("<td>&#160;</td>", i.document[0]).attr("colspan", x(this).attr("colspan") || 1).appendTo(e)
                })
            },
            _contactContainers: function (t) {
                var e, i, n, s, o, r, a, l, h, c, u = null,
                    d = null;
                for (e = this.containers.length - 1; 0 <= e; e--)
                    if (!x.contains(this.currentItem[0], this.containers[e].element[0]))
                        if (this._intersectsWith(this.containers[e].containerCache)) {
                            if (u && x.contains(this.containers[e].element[0], u.element[0])) continue;
                            u = this.containers[e], d = e
                        } else this.containers[e].containerCache.over && (this.containers[e]._trigger("out", t, this._uiHash(this)), this.containers[e].containerCache.over = 0);
                if (u)
                    if (1 === this.containers.length) this.containers[d].containerCache.over || (this.containers[d]._trigger("over", t, this._uiHash(this)), this.containers[d].containerCache.over = 1);
                    else {
                        for (n = 1e4, s = null, o = (h = u.floating || this._isFloating(this.currentItem)) ? "left" : "top", r = h ? "width" : "height", c = h ? "pageX" : "pageY", i = this.items.length - 1; 0 <= i; i--) x.contains(this.containers[d].element[0], this.items[i].item[0]) && this.items[i].item[0] !== this.currentItem[0] && (a = this.items[i].item.offset()[o], l = !1, t[c] - a > this.items[i][r] / 2 && (l = !0), n > Math.abs(t[c] - a) && (n = Math.abs(t[c] - a), s = this.items[i], this.direction = l ? "up" : "down"));
                        if (!s && !this.options.dropOnEmpty) return;
                        if (this.currentContainer === this.containers[d]) return void (this.currentContainer.containerCache.over || (this.containers[d]._trigger("over", t, this._uiHash()), this.currentContainer.containerCache.over = 1));
                        s ? this._rearrange(t, s, null, !0) : this._rearrange(t, null, this.containers[d].element, !0), this._trigger("change", t, this._uiHash()), this.containers[d]._trigger("change", t, this._uiHash(this)), this.currentContainer = this.containers[d], this.options.placeholder.update(this.currentContainer, this.placeholder), this.containers[d]._trigger("over", t, this._uiHash(this)), this.containers[d].containerCache.over = 1
                    }
            },
            _createHelper: function (t) {
                var e = this.options,
                    i = x.isFunction(e.helper) ? x(e.helper.apply(this.element[0], [t, this.currentItem])) : "clone" === e.helper ? this.currentItem.clone() : this.currentItem;
                return i.parents("body").length || x("parent" !== e.appendTo ? e.appendTo : this.currentItem[0].parentNode)[0].appendChild(i[0]), i[0] === this.currentItem[0] && (this._storedCSS = {
                    width: this.currentItem[0].style.width,
                    height: this.currentItem[0].style.height,
                    position: this.currentItem.css("position"),
                    top: this.currentItem.css("top"),
                    left: this.currentItem.css("left")
                }), i[0].style.width && !e.forceHelperSize || i.width(this.currentItem.width()), i[0].style.height && !e.forceHelperSize || i.height(this.currentItem.height()), i
            },
            _adjustOffsetFromHelper: function (t) {
                "string" == typeof t && (t = t.split(" ")), x.isArray(t) && (t = {
                    left: +t[0],
                    top: +t[1] || 0
                }), "left" in t && (this.offset.click.left = t.left + this.margins.left), "right" in t && (this.offset.click.left = this.helperProportions.width - t.right + this.margins.left), "top" in t && (this.offset.click.top = t.top + this.margins.top), "bottom" in t && (this.offset.click.top = this.helperProportions.height - t.bottom + this.margins.top)
            },
            _getParentOffset: function () {
                this.offsetParent = this.helper.offsetParent();
                var t = this.offsetParent.offset();
                return "absolute" === this.cssPosition && this.scrollParent[0] !== this.document[0] && x.contains(this.scrollParent[0], this.offsetParent[0]) && (t.left += this.scrollParent.scrollLeft(), t.top += this.scrollParent.scrollTop()), (this.offsetParent[0] === this.document[0].body || this.offsetParent[0].tagName && "html" === this.offsetParent[0].tagName.toLowerCase() && x.ui.ie) && (t = {
                    top: 0,
                    left: 0
                }), {
                    top: t.top + (parseInt(this.offsetParent.css("borderTopWidth"), 10) || 0),
                    left: t.left + (parseInt(this.offsetParent.css("borderLeftWidth"), 10) || 0)
                }
            },
            _getRelativeOffset: function () {
                if ("relative" !== this.cssPosition) return {
                    top: 0,
                    left: 0
                };
                var t = this.currentItem.position();
                return {
                    top: t.top - (parseInt(this.helper.css("top"), 10) || 0) + this.scrollParent.scrollTop(),
                    left: t.left - (parseInt(this.helper.css("left"), 10) || 0) + this.scrollParent.scrollLeft()
                }
            },
            _cacheMargins: function () {
                this.margins = {
                    left: parseInt(this.currentItem.css("marginLeft"), 10) || 0,
                    top: parseInt(this.currentItem.css("marginTop"), 10) || 0
                }
            },
            _cacheHelperProportions: function () {
                this.helperProportions = {
                    width: this.helper.outerWidth(),
                    height: this.helper.outerHeight()
                }
            },
            _setContainment: function () {
                var t, e, i, n = this.options;
                "parent" === n.containment && (n.containment = this.helper[0].parentNode), "document" !== n.containment && "window" !== n.containment || (this.containment = [0 - this.offset.relative.left - this.offset.parent.left, 0 - this.offset.relative.top - this.offset.parent.top, "document" === n.containment ? this.document.width() : this.window.width() - this.helperProportions.width - this.margins.left, ("document" === n.containment ? this.document.height() || document.body.parentNode.scrollHeight : this.window.height() || this.document[0].body.parentNode.scrollHeight) - this.helperProportions.height - this.margins.top]), /^(document|window|parent)$/.test(n.containment) || (t = x(n.containment)[0], e = x(n.containment).offset(), i = "hidden" !== x(t).css("overflow"), this.containment = [e.left + (parseInt(x(t).css("borderLeftWidth"), 10) || 0) + (parseInt(x(t).css("paddingLeft"), 10) || 0) - this.margins.left, e.top + (parseInt(x(t).css("borderTopWidth"), 10) || 0) + (parseInt(x(t).css("paddingTop"), 10) || 0) - this.margins.top, e.left + (i ? Math.max(t.scrollWidth, t.offsetWidth) : t.offsetWidth) - (parseInt(x(t).css("borderLeftWidth"), 10) || 0) - (parseInt(x(t).css("paddingRight"), 10) || 0) - this.helperProportions.width - this.margins.left, e.top + (i ? Math.max(t.scrollHeight, t.offsetHeight) : t.offsetHeight) - (parseInt(x(t).css("borderTopWidth"), 10) || 0) - (parseInt(x(t).css("paddingBottom"), 10) || 0) - this.helperProportions.height - this.margins.top])
            },
            _convertPositionTo: function (t, e) {
                e = e || this.position;
                var i = "absolute" === t ? 1 : -1,
                    n = "absolute" !== this.cssPosition || this.scrollParent[0] !== this.document[0] && x.contains(this.scrollParent[0], this.offsetParent[0]) ? this.scrollParent : this.offsetParent,
                    s = /(html|body)/i.test(n[0].tagName);
                return {
                    top: e.top + this.offset.relative.top * i + this.offset.parent.top * i - ("fixed" === this.cssPosition ? -this.scrollParent.scrollTop() : s ? 0 : n.scrollTop()) * i,
                    left: e.left + this.offset.relative.left * i + this.offset.parent.left * i - ("fixed" === this.cssPosition ? -this.scrollParent.scrollLeft() : s ? 0 : n.scrollLeft()) * i
                }
            },
            _generatePosition: function (t) {
                var e, i, n = this.options,
                    s = t.pageX,
                    o = t.pageY,
                    r = "absolute" !== this.cssPosition || this.scrollParent[0] !== this.document[0] && x.contains(this.scrollParent[0], this.offsetParent[0]) ? this.scrollParent : this.offsetParent,
                    a = /(html|body)/i.test(r[0].tagName);
                return "relative" !== this.cssPosition || this.scrollParent[0] !== this.document[0] && this.scrollParent[0] !== this.offsetParent[0] || (this.offset.relative = this._getRelativeOffset()), this.originalPosition && (this.containment && (t.pageX - this.offset.click.left < this.containment[0] && (s = this.containment[0] + this.offset.click.left), t.pageY - this.offset.click.top < this.containment[1] && (o = this.containment[1] + this.offset.click.top), t.pageX - this.offset.click.left > this.containment[2] && (s = this.containment[2] + this.offset.click.left), t.pageY - this.offset.click.top > this.containment[3] && (o = this.containment[3] + this.offset.click.top)), n.grid && (e = this.originalPageY + Math.round((o - this.originalPageY) / n.grid[1]) * n.grid[1], o = this.containment ? e - this.offset.click.top >= this.containment[1] && e - this.offset.click.top <= this.containment[3] ? e : e - this.offset.click.top >= this.containment[1] ? e - n.grid[1] : e + n.grid[1] : e, i = this.originalPageX + Math.round((s - this.originalPageX) / n.grid[0]) * n.grid[0], s = this.containment ? i - this.offset.click.left >= this.containment[0] && i - this.offset.click.left <= this.containment[2] ? i : i - this.offset.click.left >= this.containment[0] ? i - n.grid[0] : i + n.grid[0] : i)), {
                    top: o - this.offset.click.top - this.offset.relative.top - this.offset.parent.top + ("fixed" === this.cssPosition ? -this.scrollParent.scrollTop() : a ? 0 : r.scrollTop()),
                    left: s - this.offset.click.left - this.offset.relative.left - this.offset.parent.left + ("fixed" === this.cssPosition ? -this.scrollParent.scrollLeft() : a ? 0 : r.scrollLeft())
                }
            },
            _rearrange: function (t, e, i, n) {
                i ? i[0].appendChild(this.placeholder[0]) : e.item[0].parentNode.insertBefore(this.placeholder[0], "down" === this.direction ? e.item[0] : e.item[0].nextSibling), this.counter = this.counter ? ++this.counter : 1;
                var s = this.counter;
                this._delay(function () {
                    s === this.counter && this.refreshPositions(!n)
                })
            },
            _clear: function (t, e) {
                function i(e, i, n) {
                    return function (t) {
                        n._trigger(e, t, i._uiHash(i))
                    }
                }
                this.reverting = !1;
                var n, s = [];
                if (!this._noFinalSort && this.currentItem.parent().length && this.placeholder.before(this.currentItem), this._noFinalSort = null, this.helper[0] === this.currentItem[0]) {
                    for (n in this._storedCSS) "auto" !== this._storedCSS[n] && "static" !== this._storedCSS[n] || (this._storedCSS[n] = "");
                    this.currentItem.css(this._storedCSS), this._removeClass(this.currentItem, "ui-sortable-helper")
                } else this.currentItem.show();
                for (this.fromOutside && !e && s.push(function (t) {
                    this._trigger("receive", t, this._uiHash(this.fromOutside))
                }), !this.fromOutside && this.domPosition.prev === this.currentItem.prev().not(".ui-sortable-helper")[0] && this.domPosition.parent === this.currentItem.parent()[0] || e || s.push(function (t) {
                    this._trigger("update", t, this._uiHash())
                }), this !== this.currentContainer && (e || (s.push(function (t) {
                    this._trigger("remove", t, this._uiHash())
                }), s.push(function (e) {
                    return function (t) {
                        e._trigger("receive", t, this._uiHash(this))
                    }
                }.call(this, this.currentContainer)), s.push(function (e) {
                    return function (t) {
                        e._trigger("update", t, this._uiHash(this))
                    }
                }.call(this, this.currentContainer)))), n = this.containers.length - 1; 0 <= n; n--) e || s.push(i("deactivate", this, this.containers[n])), this.containers[n].containerCache.over && (s.push(i("out", this, this.containers[n])), this.containers[n].containerCache.over = 0);
                if (this.storedCursor && (this.document.find("body").css("cursor", this.storedCursor), this.storedStylesheet.remove()), this._storedOpacity && this.helper.css("opacity", this._storedOpacity), this._storedZIndex && this.helper.css("zIndex", "auto" === this._storedZIndex ? "" : this._storedZIndex), this.dragging = !1, e || this._trigger("beforeStop", t, this._uiHash()), this.placeholder[0].parentNode.removeChild(this.placeholder[0]), this.cancelHelperRemoval || (this.helper[0] !== this.currentItem[0] && this.helper.remove(), this.helper = null), !e) {
                    for (n = 0; s.length > n; n++) s[n].call(this, t);
                    this._trigger("stop", t, this._uiHash())
                }
                return this.fromOutside = !1, !this.cancelHelperRemoval
            },
            _trigger: function () {
                !1 === x.Widget.prototype._trigger.apply(this, arguments) && this.cancel()
            },
            _uiHash: function (t) {
                var e = t || this;
                return {
                    helper: e.helper,
                    placeholder: e.placeholder || x([]),
                    position: e.position,
                    originalPosition: e.originalPosition,
                    offset: e.positionAbs,
                    item: e.currentItem,
                    sender: t ? t.element : null
                }
            }
        }), x.widget("ui.spinner", {
            version: "1.12.1",
            defaultElement: "<input>",
            widgetEventPrefix: "spin",
            options: {
                classes: {
                    "ui-spinner": "ui-corner-all",
                    "ui-spinner-down": "ui-corner-br",
                    "ui-spinner-up": "ui-corner-tr"
                },
                culture: null,
                icons: {
                    down: "ui-icon-triangle-1-s",
                    up: "ui-icon-triangle-1-n"
                },
                incremental: !0,
                max: null,
                min: null,
                numberFormat: null,
                page: 10,
                step: 1,
                change: null,
                spin: null,
                start: null,
                stop: null
            },
            _create: function () {
                this._setOption("max", this.options.max), this._setOption("min", this.options.min), this._setOption("step", this.options.step), "" !== this.value() && this._value(this.element.val(), !0), this._draw(), this._on(this._events), this._refresh(), this._on(this.window, {
                    beforeunload: function () {
                        this.element.removeAttr("autocomplete")
                    }
                })
            },
            _getCreateOptions: function () {
                var n = this._super(),
                    s = this.element;
                return x.each(["min", "max", "step"], function (t, e) {
                    var i = s.attr(e);
                    null != i && i.length && (n[e] = i)
                }), n
            },
            _events: {
                keydown: function (t) {
                    this._start(t) && this._keydown(t) && t.preventDefault()
                },
                keyup: "_stop",
                focus: function () {
                    this.previous = this.element.val()
                },
                blur: function (t) {
                    return this.cancelBlur ? void delete this.cancelBlur : (this._stop(), this._refresh(), void (this.previous !== this.element.val() && this._trigger("change", t)))
                },
                mousewheel: function (t, e) {
                    if (e) {
                        if (!this.spinning && !this._start(t)) return !1;
                        this._spin((0 < e ? 1 : -1) * this.options.step, t), clearTimeout(this.mousewheelTimer), this.mousewheelTimer = this._delay(function () {
                            this.spinning && this._stop(t)
                        }, 100), t.preventDefault()
                    }
                },
                "mousedown .ui-spinner-button": function (t) {
                    function e() {
                        this.element[0] === x.ui.safeActiveElement(this.document[0]) || (this.element.trigger("focus"), this.previous = i, this._delay(function () {
                            this.previous = i
                        }))
                    }
                    var i;
                    i = this.element[0] === x.ui.safeActiveElement(this.document[0]) ? this.previous : this.element.val(), t.preventDefault(), e.call(this), this.cancelBlur = !0, this._delay(function () {
                        delete this.cancelBlur, e.call(this)
                    }), !1 !== this._start(t) && this._repeat(null, x(t.currentTarget).hasClass("ui-spinner-up") ? 1 : -1, t)
                },
                "mouseup .ui-spinner-button": "_stop",
                "mouseenter .ui-spinner-button": function (t) {
                    return x(t.currentTarget).hasClass("ui-state-active") ? !1 !== this._start(t) && void this._repeat(null, x(t.currentTarget).hasClass("ui-spinner-up") ? 1 : -1, t) : void 0
                },
                "mouseleave .ui-spinner-button": "_stop"
            },
            _enhance: function () {
                this.uiSpinner = this.element.attr("autocomplete", "off").wrap("<span>").parent().append("<a></a><a></a>")
            },
            _draw: function () {
                this._enhance(), this._addClass(this.uiSpinner, "ui-spinner", "ui-widget ui-widget-content"), this._addClass("ui-spinner-input"), this.element.attr("role", "spinbutton"), this.buttons = this.uiSpinner.children("a").attr("tabIndex", -1).attr("aria-hidden", !0).button({
                    classes: {
                        "ui-button": ""
                    }
                }), this._removeClass(this.buttons, "ui-corner-all"), this._addClass(this.buttons.first(), "ui-spinner-button ui-spinner-up"), this._addClass(this.buttons.last(), "ui-spinner-button ui-spinner-down"), this.buttons.first().button({
                    icon: this.options.icons.up,
                    showLabel: !1
                }), this.buttons.last().button({
                    icon: this.options.icons.down,
                    showLabel: !1
                }), this.buttons.height() > Math.ceil(.5 * this.uiSpinner.height()) && 0 < this.uiSpinner.height() && this.uiSpinner.height(this.uiSpinner.height())
            },
            _keydown: function (t) {
                var e = this.options,
                    i = x.ui.keyCode;
                switch (t.keyCode) {
                    case i.UP:
                        return this._repeat(null, 1, t), !0;
                    case i.DOWN:
                        return this._repeat(null, -1, t), !0;
                    case i.PAGE_UP:
                        return this._repeat(null, e.page, t), !0;
                    case i.PAGE_DOWN:
                        return this._repeat(null, -e.page, t), !0
                }
                return !1
            },
            _start: function (t) {
                return !(!this.spinning && !1 === this._trigger("start", t)) && (this.counter || (this.counter = 1), this.spinning = !0)
            },
            _repeat: function (t, e, i) {
                t = t || 500, clearTimeout(this.timer), this.timer = this._delay(function () {
                    this._repeat(40, e, i)
                }, t), this._spin(e * this.options.step, i)
            },
            _spin: function (t, e) {
                var i = this.value() || 0;
                this.counter || (this.counter = 1), i = this._adjustValue(i + t * this._increment(this.counter)), this.spinning && !1 === this._trigger("spin", e, {
                    value: i
                }) || (this._value(i), this.counter++)
            },
            _increment: function (t) {
                var e = this.options.incremental;
                return e ? x.isFunction(e) ? e(t) : Math.floor(t * t * t / 5e4 - t * t / 500 + 17 * t / 200 + 1) : 1
            },
            _precision: function () {
                var t = this._precisionOf(this.options.step);
                return null !== this.options.min && (t = Math.max(t, this._precisionOf(this.options.min))), t
            },
            _precisionOf: function (t) {
                var e = "" + t,
                    i = e.indexOf(".");
                return -1 === i ? 0 : e.length - i - 1
            },
            _adjustValue: function (t) {
                var e, i, n = this.options;
                return i = t - (e = null !== n.min ? n.min : 0), t = e + (i = Math.round(i / n.step) * n.step), t = parseFloat(t.toFixed(this._precision())), null !== n.max && t > n.max ? n.max : null !== n.min && n.min > t ? n.min : t
            },
            _stop: function (t) {
                this.spinning && (clearTimeout(this.timer), clearTimeout(this.mousewheelTimer), this.counter = 0, this.spinning = !1, this._trigger("stop", t))
            },
            _setOption: function (t, e) {
                var i, n, s;
                return "culture" === t || "numberFormat" === t ? (i = this._parse(this.element.val()), this.options[t] = e, void this.element.val(this._format(i))) : ("max" !== t && "min" !== t && "step" !== t || "string" != typeof e || (e = this._parse(e)), "icons" === t && (n = this.buttons.first().find(".ui-icon"), this._removeClass(n, null, this.options.icons.up), this._addClass(n, null, e.up), s = this.buttons.last().find(".ui-icon"), this._removeClass(s, null, this.options.icons.down), this._addClass(s, null, e.down)), void this._super(t, e))
            },
            _setOptionDisabled: function (t) {
                this._super(t), this._toggleClass(this.uiSpinner, null, "ui-state-disabled", !!t), this.element.prop("disabled", !!t), this.buttons.button(t ? "disable" : "enable")
            },
            _setOptions: e(function (t) {
                this._super(t)
            }),
            _parse: function (t) {
                return "string" == typeof t && "" !== t && (t = window.Globalize && this.options.numberFormat ? Globalize.parseFloat(t, 10, this.options.culture) : +t), "" === t || isNaN(t) ? null : t
            },
            _format: function (t) {
                return "" === t ? "" : window.Globalize && this.options.numberFormat ? Globalize.format(t, this.options.numberFormat, this.options.culture) : t
            },
            _refresh: function () {
                this.element.attr({
                    "aria-valuemin": this.options.min,
                    "aria-valuemax": this.options.max,
                    "aria-valuenow": this._parse(this.element.val())
                })
            },
            isValid: function () {
                var t = this.value();
                return null !== t && t === this._adjustValue(t)
            },
            _value: function (t, e) {
                var i;
                "" === t || null !== (i = this._parse(t)) && (e || (i = this._adjustValue(i)), t = this._format(i)), this.element.val(t), this._refresh()
            },
            _destroy: function () {
                this.element.prop("disabled", !1).removeAttr("autocomplete role aria-valuemin aria-valuemax aria-valuenow"), this.uiSpinner.replaceWith(this.element)
            },
            stepUp: e(function (t) {
                this._stepUp(t)
            }),
            _stepUp: function (t) {
                this._start() && (this._spin((t || 1) * this.options.step), this._stop())
            },
            stepDown: e(function (t) {
                this._stepDown(t)
            }),
            _stepDown: function (t) {
                this._start() && (this._spin((t || 1) * -this.options.step), this._stop())
            },
            pageUp: e(function (t) {
                this._stepUp((t || 1) * this.options.page)
            }),
            pageDown: e(function (t) {
                this._stepDown((t || 1) * this.options.page)
            }),
            value: function (t) {
                return arguments.length ? void e(this._value).call(this, t) : this._parse(this.element.val())
            },
            widget: function () {
                return this.uiSpinner
            }
        }), !1 !== x.uiBackCompat && x.widget("ui.spinner", x.ui.spinner, {
            _enhance: function () {
                this.uiSpinner = this.element.attr("autocomplete", "off").wrap(this._uiSpinnerHtml()).parent().append(this._buttonHtml())
            },
            _uiSpinnerHtml: function () {
                return "<span>"
            },
            _buttonHtml: function () {
                return "<a></a><a></a>"
            }
        }), x.ui.spinner, x.widget("ui.tabs", {
            version: "1.12.1",
            delay: 300,
            options: {
                active: null,
                classes: {
                    "ui-tabs": "ui-corner-all",
                    "ui-tabs-nav": "ui-corner-all",
                    "ui-tabs-panel": "ui-corner-bottom",
                    "ui-tabs-tab": "ui-corner-top"
                },
                collapsible: !1,
                event: "click",
                heightStyle: "content",
                hide: null,
                show: null,
                activate: null,
                beforeActivate: null,
                beforeLoad: null,
                load: null
            },
            _isLocal: (ot = /#.*$/, function (t) {
                var e, i;
                e = t.href.replace(ot, ""), i = location.href.replace(ot, "");
                try {
                    e = decodeURIComponent(e)
                } catch (t) { }
                try {
                    i = decodeURIComponent(i)
                } catch (t) { }
                return 1 < t.hash.length && e === i
            }),
            _create: function () {
                var e = this,
                    t = this.options;
                this.running = !1, this._addClass("ui-tabs", "ui-widget ui-widget-content"), this._toggleClass("ui-tabs-collapsible", null, t.collapsible), this._processTabs(), t.active = this._initialActive(), x.isArray(t.disabled) && (t.disabled = x.unique(t.disabled.concat(x.map(this.tabs.filter(".ui-state-disabled"), function (t) {
                    return e.tabs.index(t)
                }))).sort()), this.active = !1 !== this.options.active && this.anchors.length ? this._findActive(t.active) : x(), this._refresh(), this.active.length && this.load(t.active)
            },
            _initialActive: function () {
                var i = this.options.active,
                    t = this.options.collapsible,
                    n = location.hash.substring(1);
                return null === i && (n && this.tabs.each(function (t, e) {
                    return x(e).attr("aria-controls") === n ? (i = t, !1) : void 0
                }), null === i && (i = this.tabs.index(this.tabs.filter(".ui-tabs-active"))), null !== i && -1 !== i || (i = !!this.tabs.length && 0)), !1 !== i && (-1 === (i = this.tabs.index(this.tabs.eq(i))) && (i = !t && 0)), !t && !1 === i && this.anchors.length && (i = 0), i
            },
            _getCreateEventData: function () {
                return {
                    tab: this.active,
                    panel: this.active.length ? this._getPanelForTab(this.active) : x()
                }
            },
            _tabKeydown: function (t) {
                var e = x(x.ui.safeActiveElement(this.document[0])).closest("li"),
                    i = this.tabs.index(e),
                    n = !0;
                if (!this._handlePageNav(t)) {
                    switch (t.keyCode) {
                        case x.ui.keyCode.RIGHT:
                        case x.ui.keyCode.DOWN:
                            i++;
                            break;
                        case x.ui.keyCode.UP:
                        case x.ui.keyCode.LEFT:
                            n = !1, i--;
                            break;
                        case x.ui.keyCode.END:
                            i = this.anchors.length - 1;
                            break;
                        case x.ui.keyCode.HOME:
                            i = 0;
                            break;
                        case x.ui.keyCode.SPACE:
                            return t.preventDefault(), clearTimeout(this.activating), void this._activate(i);
                        case x.ui.keyCode.ENTER:
                            return t.preventDefault(), clearTimeout(this.activating), void this._activate(i !== this.options.active && i);
                        default:
                            return
                    }
                    t.preventDefault(), clearTimeout(this.activating), i = this._focusNextTab(i, n), t.ctrlKey || t.metaKey || (e.attr("aria-selected", "false"), this.tabs.eq(i).attr("aria-selected", "true"), this.activating = this._delay(function () {
                        this.option("active", i)
                    }, this.delay))
                }
            },
            _panelKeydown: function (t) {
                this._handlePageNav(t) || t.ctrlKey && t.keyCode === x.ui.keyCode.UP && (t.preventDefault(), this.active.trigger("focus"))
            },
            _handlePageNav: function (t) {
                return t.altKey && t.keyCode === x.ui.keyCode.PAGE_UP ? (this._activate(this._focusNextTab(this.options.active - 1, !1)), !0) : t.altKey && t.keyCode === x.ui.keyCode.PAGE_DOWN ? (this._activate(this._focusNextTab(this.options.active + 1, !0)), !0) : void 0
            },
            _findNextTab: function (t, e) {
                for (var i = this.tabs.length - 1; - 1 !== x.inArray((i < t && (t = 0), t < 0 && (t = i), t), this.options.disabled);) t = e ? t + 1 : t - 1;
                return t
            },
            _focusNextTab: function (t, e) {
                return t = this._findNextTab(t, e), this.tabs.eq(t).trigger("focus"), t
            },
            _setOption: function (t, e) {
                return "active" === t ? void this._activate(e) : (this._super(t, e), "collapsible" === t && (this._toggleClass("ui-tabs-collapsible", null, e), e || !1 !== this.options.active || this._activate(0)), "event" === t && this._setupEvents(e), void ("heightStyle" === t && this._setupHeightStyle(e)))
            },
            _sanitizeSelector: function (t) {
                return t ? t.replace(/[!"$%&'()*+,.\/:;<=>?@\[\]\^`{|}~]/g, "\\$&") : ""
            },
            refresh: function () {
                var t = this.options,
                    e = this.tablist.children(":has(a[href])");
                t.disabled = x.map(e.filter(".ui-state-disabled"), function (t) {
                    return e.index(t)
                }), this._processTabs(), !1 !== t.active && this.anchors.length ? this.active.length && !x.contains(this.tablist[0], this.active[0]) ? this.tabs.length === t.disabled.length ? (t.active = !1, this.active = x()) : this._activate(this._findNextTab(Math.max(0, t.active - 1), !1)) : t.active = this.tabs.index(this.active) : (t.active = !1, this.active = x()), this._refresh()
            },
            _refresh: function () {
                this._setOptionDisabled(this.options.disabled), this._setupEvents(this.options.event), this._setupHeightStyle(this.options.heightStyle), this.tabs.not(this.active).attr({
                    "aria-selected": "false",
                    "aria-expanded": "false",
                    tabIndex: -1
                }), this.panels.not(this._getPanelForTab(this.active)).hide().attr({
                    "aria-hidden": "true"
                }), this.active.length ? (this.active.attr({
                    "aria-selected": "true",
                    "aria-expanded": "true",
                    tabIndex: 0
                }), this._addClass(this.active, "ui-tabs-active", "ui-state-active"), this._getPanelForTab(this.active).show().attr({
                    "aria-hidden": "false"
                })) : this.tabs.eq(0).attr("tabIndex", 0)
            },
            _processTabs: function () {
                var l = this,
                    t = this.tabs,
                    e = this.anchors,
                    i = this.panels;
                this.tablist = this._getList().attr("role", "tablist"), this._addClass(this.tablist, "ui-tabs-nav", "ui-helper-reset ui-helper-clearfix ui-widget-header"), this.tablist.on("mousedown" + this.eventNamespace, "> li", function (t) {
                    x(this).is(".ui-state-disabled") && t.preventDefault()
                }).on("focus" + this.eventNamespace, ".ui-tabs-anchor", function () {
                    x(this).closest("li").is(".ui-state-disabled") && this.blur()
                }), this.tabs = this.tablist.find("> li:has(a[href])").attr({
                    role: "tab",
                    tabIndex: -1
                }), this._addClass(this.tabs, "ui-tabs-tab", "ui-state-default"), this.anchors = this.tabs.map(function () {
                    return x("a", this)[0]
                }).attr({
                    role: "presentation",
                    tabIndex: -1
                }), this._addClass(this.anchors, "ui-tabs-anchor"), this.panels = x(), this.anchors.each(function (t, e) {
                    var i, n, s, o = x(e).uniqueId().attr("id"),
                        r = x(e).closest("li"),
                        a = r.attr("aria-controls");
                    l._isLocal(e) ? (s = (i = e.hash).substring(1), n = l.element.find(l._sanitizeSelector(i))) : (i = "#" + (s = r.attr("aria-controls") || x({}).uniqueId()[0].id), (n = l.element.find(i)).length || (n = l._createPanel(s)).insertAfter(l.panels[t - 1] || l.tablist), n.attr("aria-live", "polite")), n.length && (l.panels = l.panels.add(n)), a && r.data("ui-tabs-aria-controls", a), r.attr({
                        "aria-controls": s,
                        "aria-labelledby": o
                    }), n.attr("aria-labelledby", o)
                }), this.panels.attr("role", "tabpanel"), this._addClass(this.panels, "ui-tabs-panel", "ui-widget-content"), t && (this._off(t.not(this.tabs)), this._off(e.not(this.anchors)), this._off(i.not(this.panels)))
            },
            _getList: function () {
                return this.tablist || this.element.find("ol, ul").eq(0)
            },
            _createPanel: function (t) {
                return x("<div>").attr("id", t).data("ui-tabs-destroy", !0)
            },
            _setOptionDisabled: function (t) {
                var e, i, n;
                for (x.isArray(t) && (t.length ? t.length === this.anchors.length && (t = !0) : t = !1), n = 0; i = this.tabs[n]; n++) e = x(i), !0 === t || -1 !== x.inArray(n, t) ? (e.attr("aria-disabled", "true"), this._addClass(e, null, "ui-state-disabled")) : (e.removeAttr("aria-disabled"), this._removeClass(e, null, "ui-state-disabled"));
                this.options.disabled = t, this._toggleClass(this.widget(), this.widgetFullName + "-disabled", null, !0 === t)
            },
            _setupEvents: function (t) {
                var i = {};
                t && x.each(t.split(" "), function (t, e) {
                    i[e] = "_eventHandler"
                }), this._off(this.anchors.add(this.tabs).add(this.panels)), this._on(!0, this.anchors, {
                    click: function (t) {
                        t.preventDefault()
                    }
                }), this._on(this.anchors, i), this._on(this.tabs, {
                    keydown: "_tabKeydown"
                }), this._on(this.panels, {
                    keydown: "_panelKeydown"
                }), this._focusable(this.tabs), this._hoverable(this.tabs)
            },
            _setupHeightStyle: function (t) {
                var i, e = this.element.parent();
                "fill" === t ? (i = e.height(), i -= this.element.outerHeight() - this.element.height(), this.element.siblings(":visible").each(function () {
                    var t = x(this),
                        e = t.css("position");
                    "absolute" !== e && "fixed" !== e && (i -= t.outerHeight(!0))
                }), this.element.children().not(this.panels).each(function () {
                    i -= x(this).outerHeight(!0)
                }), this.panels.each(function () {
                    x(this).height(Math.max(0, i - x(this).innerHeight() + x(this).height()))
                }).css("overflow", "auto")) : "auto" === t && (i = 0, this.panels.each(function () {
                    i = Math.max(i, x(this).height("").height())
                }).height(i))
            },
            _eventHandler: function (t) {
                var e = this.options,
                    i = this.active,
                    n = x(t.currentTarget).closest("li"),
                    s = n[0] === i[0],
                    o = s && e.collapsible,
                    r = o ? x() : this._getPanelForTab(n),
                    a = i.length ? this._getPanelForTab(i) : x(),
                    l = {
                        oldTab: i,
                        oldPanel: a,
                        newTab: o ? x() : n,
                        newPanel: r
                    };
                t.preventDefault(), n.hasClass("ui-state-disabled") || n.hasClass("ui-tabs-loading") || this.running || s && !e.collapsible || !1 === this._trigger("beforeActivate", t, l) || (e.active = !o && this.tabs.index(n), this.active = s ? x() : n, this.xhr && this.xhr.abort(), a.length || r.length || x.error("jQuery UI Tabs: Mismatching fragment identifier."), r.length && this.load(this.tabs.index(n), t), this._toggle(t, l))
            },
            _toggle: function (t, e) {
                function i() {
                    s.running = !1, s._trigger("activate", t, e)
                }

                function n() {
                    s._addClass(e.newTab.closest("li"), "ui-tabs-active", "ui-state-active"), o.length && s.options.show ? s._show(o, s.options.show, i) : (o.show(), i())
                }
                var s = this,
                    o = e.newPanel,
                    r = e.oldPanel;
                this.running = !0, r.length && this.options.hide ? this._hide(r, this.options.hide, function () {
                    s._removeClass(e.oldTab.closest("li"), "ui-tabs-active", "ui-state-active"), n()
                }) : (this._removeClass(e.oldTab.closest("li"), "ui-tabs-active", "ui-state-active"), r.hide(), n()), r.attr("aria-hidden", "true"), e.oldTab.attr({
                    "aria-selected": "false",
                    "aria-expanded": "false"
                }), o.length && r.length ? e.oldTab.attr("tabIndex", -1) : o.length && this.tabs.filter(function () {
                    return 0 === x(this).attr("tabIndex")
                }).attr("tabIndex", -1), o.attr("aria-hidden", "false"), e.newTab.attr({
                    "aria-selected": "true",
                    "aria-expanded": "true",
                    tabIndex: 0
                })
            },
            _activate: function (t) {
                var e, i = this._findActive(t);
                i[0] !== this.active[0] && (i.length || (i = this.active), e = i.find(".ui-tabs-anchor")[0], this._eventHandler({
                    target: e,
                    currentTarget: e,
                    preventDefault: x.noop
                }))
            },
            _findActive: function (t) {
                return !1 === t ? x() : this.tabs.eq(t)
            },
            _getIndex: function (t) {
                return "string" == typeof t && (t = this.anchors.index(this.anchors.filter("[href$='" + x.ui.escapeSelector(t) + "']"))), t
            },
            _destroy: function () {
                this.xhr && this.xhr.abort(), this.tablist.removeAttr("role").off(this.eventNamespace), this.anchors.removeAttr("role tabIndex").removeUniqueId(), this.tabs.add(this.panels).each(function () {
                    x.data(this, "ui-tabs-destroy") ? x(this).remove() : x(this).removeAttr("role tabIndex aria-live aria-busy aria-selected aria-labelledby aria-hidden aria-expanded")
                }), this.tabs.each(function () {
                    var t = x(this),
                        e = t.data("ui-tabs-aria-controls");
                    e ? t.attr("aria-controls", e).removeData("ui-tabs-aria-controls") : t.removeAttr("aria-controls")
                }), this.panels.show(), "content" !== this.options.heightStyle && this.panels.css("height", "")
            },
            enable: function (i) {
                var t = this.options.disabled;
                !1 !== t && (t = void 0 !== i && (i = this._getIndex(i), x.isArray(t) ? x.map(t, function (t) {
                    return t !== i ? t : null
                }) : x.map(this.tabs, function (t, e) {
                    return e !== i ? e : null
                })), this._setOptionDisabled(t))
            },
            disable: function (t) {
                var e = this.options.disabled;
                if (!0 !== e) {
                    if (void 0 === t) e = !0;
                    else {
                        if (t = this._getIndex(t), -1 !== x.inArray(t, e)) return;
                        e = x.isArray(e) ? x.merge([t], e).sort() : [t]
                    }
                    this._setOptionDisabled(e)
                }
            },
            load: function (t, n) {
                t = this._getIndex(t);

                function s(t, e) {
                    "abort" === e && o.panels.stop(!1, !0), o._removeClass(i, "ui-tabs-loading"), r.removeAttr("aria-busy"), t === o.xhr && delete o.xhr
                }
                var o = this,
                    i = this.tabs.eq(t),
                    e = i.find(".ui-tabs-anchor"),
                    r = this._getPanelForTab(i),
                    a = {
                        tab: i,
                        panel: r
                    };
                this._isLocal(e[0]) || (this.xhr = x.ajax(this._ajaxSettings(e, n, a)), this.xhr && "canceled" !== this.xhr.statusText && (this._addClass(i, "ui-tabs-loading"), r.attr("aria-busy", "true"), this.xhr.done(function (t, e, i) {
                    setTimeout(function () {
                        r.html(t), o._trigger("load", n, a), s(i, e)
                    }, 1)
                }).fail(function (t, e) {
                    setTimeout(function () {
                        s(t, e)
                    }, 1)
                })))
            },
            _ajaxSettings: function (t, i, n) {
                var s = this;
                return {
                    url: t.attr("href").replace(/#.*$/, ""),
                    beforeSend: function (t, e) {
                        return s._trigger("beforeLoad", i, x.extend({
                            jqXHR: t,
                            ajaxSettings: e
                        }, n))
                    }
                }
            },
            _getPanelForTab: function (t) {
                var e = x(t).attr("aria-controls");
                return this.element.find(this._sanitizeSelector("#" + e))
            }
        }), !1 !== x.uiBackCompat && x.widget("ui.tabs", x.ui.tabs, {
            _processTabs: function () {
                this._superApply(arguments), this._addClass(this.tabs, "ui-tab")
            }
        }), x.ui.tabs, x.widget("ui.tooltip", {
            version: "1.12.1",
            options: {
                classes: {
                    "ui-tooltip": "ui-corner-all ui-widget-shadow"
                },
                content: function () {
                    var t = x(this).attr("title") || "";
                    return x("<a>").text(t).html()
                },
                hide: !0,
                items: "[title]:not([disabled])",
                position: {
                    my: "left top+15",
                    at: "left bottom",
                    collision: "flipfit flip"
                },
                show: !0,
                track: !1,
                close: null,
                open: null
            },
            _addDescribedBy: function (t, e) {
                var i = (t.attr("aria-describedby") || "").split(/\s+/);
                i.push(e), t.data("ui-tooltip-id", e).attr("aria-describedby", x.trim(i.join(" ")))
            },
            _removeDescribedBy: function (t) {
                var e = t.data("ui-tooltip-id"),
                    i = (t.attr("aria-describedby") || "").split(/\s+/),
                    n = x.inArray(e, i); - 1 !== n && i.splice(n, 1), t.removeData("ui-tooltip-id"), (i = x.trim(i.join(" "))) ? t.attr("aria-describedby", i) : t.removeAttr("aria-describedby")
            },
            _create: function () {
                this._on({
                    mouseover: "open",
                    focusin: "open"
                }), this.tooltips = {}, this.parents = {}, this.liveRegion = x("<div>").attr({
                    role: "log",
                    "aria-live": "assertive",
                    "aria-relevant": "additions"
                }).appendTo(this.document[0].body), this._addClass(this.liveRegion, null, "ui-helper-hidden-accessible"), this.disabledTitles = x([])
            },
            _setOption: function (t, e) {
                var i = this;
                this._super(t, e), "content" === t && x.each(this.tooltips, function (t, e) {
                    i._updateContent(e.element)
                })
            },
            _setOptionDisabled: function (t) {
                this[t ? "_disable" : "_enable"]()
            },
            _disable: function () {
                var n = this;
                x.each(this.tooltips, function (t, e) {
                    var i = x.Event("blur");
                    i.target = i.currentTarget = e.element[0], n.close(i, !0)
                }), this.disabledTitles = this.disabledTitles.add(this.element.find(this.options.items).addBack().filter(function () {
                    var t = x(this);
                    return t.is("[title]") ? t.data("ui-tooltip-title", t.attr("title")).removeAttr("title") : void 0
                }))
            },
            _enable: function () {
                this.disabledTitles.each(function () {
                    var t = x(this);
                    t.data("ui-tooltip-title") && t.attr("title", t.data("ui-tooltip-title"))
                }), this.disabledTitles = x([])
            },
            open: function (t) {
                var i = this,
                    e = x(t ? t.target : this.element).closest(this.options.items);
                e.length && !e.data("ui-tooltip-id") && (e.attr("title") && e.data("ui-tooltip-title", e.attr("title")), e.data("ui-tooltip-open", !0), t && "mouseover" === t.type && e.parents().each(function () {
                    var t, e = x(this);
                    e.data("ui-tooltip-open") && ((t = x.Event("blur")).target = t.currentTarget = this, i.close(t, !0)), e.attr("title") && (e.uniqueId(), i.parents[this.id] = {
                        element: this,
                        title: e.attr("title")
                    }, e.attr("title", ""))
                }), this._registerCloseHandlers(t, e), this._updateContent(e, t))
            },
            _updateContent: function (e, i) {
                var t, n = this.options.content,
                    s = this,
                    o = i ? i.type : null;
                return "string" == typeof n || n.nodeType || n.jquery ? this._open(i, e, n) : void ((t = n.call(e[0], function (t) {
                    s._delay(function () {
                        e.data("ui-tooltip-open") && (i && (i.type = o), this._open(i, e, t))
                    })
                })) && this._open(i, e, t))
            },
            _open: function (t, e, i) {
                function n(t) {
                    l.of = t, o.is(":hidden") || o.position(l)
                }
                var s, o, r, a, l = x.extend({}, this.options.position);
                if (i) {
                    if (s = this._find(e)) return void s.tooltip.find(".ui-tooltip-content").html(i);
                    e.is("[title]") && (t && "mouseover" === t.type ? e.attr("title", "") : e.removeAttr("title")), s = this._tooltip(e), o = s.tooltip, this._addDescribedBy(e, o.attr("id")), o.find(".ui-tooltip-content").html(i), this.liveRegion.children().hide(), (a = x("<div>").html(o.find(".ui-tooltip-content").html())).removeAttr("name").find("[name]").removeAttr("name"), a.removeAttr("id").find("[id]").removeAttr("id"), a.appendTo(this.liveRegion), this.options.track && t && /^mouse/.test(t.type) ? (this._on(this.document, {
                        mousemove: n
                    }), n(t)) : o.position(x.extend({
                        of: e
                    }, this.options.position)), o.hide(), this._show(o, this.options.show), this.options.track && this.options.show && this.options.show.delay && (r = this.delayedShow = setInterval(function () {
                        o.is(":visible") && (n(l.of), clearInterval(r))
                    }, x.fx.interval)), this._trigger("open", t, {
                        tooltip: o
                    })
                }
            },
            _registerCloseHandlers: function (t, i) {
                var e = {
                    keyup: function (t) {
                        if (t.keyCode === x.ui.keyCode.ESCAPE) {
                            var e = x.Event(t);
                            e.currentTarget = i[0], this.close(e, !0)
                        }
                    }
                };
                i[0] !== this.element[0] && (e.remove = function () {
                    this._removeTooltip(this._find(i).tooltip)
                }), t && "mouseover" !== t.type || (e.mouseleave = "close"), t && "focusin" !== t.type || (e.focusout = "close"), this._on(!0, i, e)
            },
            close: function (t) {
                var e, i = this,
                    n = x(t ? t.currentTarget : this.element),
                    s = this._find(n);
                return s ? (e = s.tooltip, void (s.closing || (clearInterval(this.delayedShow), n.data("ui-tooltip-title") && !n.attr("title") && n.attr("title", n.data("ui-tooltip-title")), this._removeDescribedBy(n), s.hiding = !0, e.stop(!0), this._hide(e, this.options.hide, function () {
                    i._removeTooltip(x(this))
                }), n.removeData("ui-tooltip-open"), this._off(n, "mouseleave focusout keyup"), n[0] !== this.element[0] && this._off(n, "remove"), this._off(this.document, "mousemove"), t && "mouseleave" === t.type && x.each(this.parents, function (t, e) {
                    x(e.element).attr("title", e.title), delete i.parents[t]
                }), s.closing = !0, this._trigger("close", t, {
                    tooltip: e
                }), s.hiding || (s.closing = !1)))) : void n.removeData("ui-tooltip-open")
            },
            _tooltip: function (t) {
                var e = x("<div>").attr("role", "tooltip"),
                    i = x("<div>").appendTo(e),
                    n = e.uniqueId().attr("id");
                return this._addClass(i, "ui-tooltip-content"), this._addClass(e, "ui-tooltip", "ui-widget ui-widget-content"), e.appendTo(this._appendTo(t)), this.tooltips[n] = {
                    element: t,
                    tooltip: e
                }
            },
            _find: function (t) {
                var e = t.data("ui-tooltip-id");
                return e ? this.tooltips[e] : null
            },
            _removeTooltip: function (t) {
                t.remove(), delete this.tooltips[t.attr("id")]
            },
            _appendTo: function (t) {
                var e = t.closest(".ui-front, dialog");
                return e.length || (e = this.document[0].body), e
            },
            _destroy: function () {
                var s = this;
                x.each(this.tooltips, function (t, e) {
                    var i = x.Event("blur"),
                        n = e.element;
                    i.target = i.currentTarget = n[0], s.close(i, !0), x("#" + t).remove(), n.data("ui-tooltip-title") && (n.attr("title") || n.attr("title", n.data("ui-tooltip-title")), n.removeData("ui-tooltip-title"))
                }), this.liveRegion.remove()
            }
        }), !1 !== x.uiBackCompat && x.widget("ui.tooltip", x.ui.tooltip, {
            options: {
                tooltipClass: null
            },
            _tooltip: function () {
                var t = this._superApply(arguments);
                return this.options.tooltipClass && t.tooltip.addClass(this.options.tooltipClass), t
            }
        }), x.ui.tooltip
    }),
    function (t, e) {
        "object" == typeof exports && "undefined" != typeof module ? e(exports, require("jquery")) : "function" == typeof define && define.amd ? define(["exports", "jquery"], e) : e((t = t || self).bootstrap = {}, t.jQuery)
    }(this, function (t, f) {
        "use strict";

        function n(t, e) {
            for (var i = 0; i < e.length; i++) {
                var n = e[i];
                n.enumerable = n.enumerable || !1, n.configurable = !0, "value" in n && (n.writable = !0), Object.defineProperty(t, n.key, n)
            }
        }

        function o(t, e, i) {
            return e && n(t.prototype, e), i && n(t, i), t
        }

        function e(e, t) {
            var i = Object.keys(e);
            if (Object.getOwnPropertySymbols) {
                var n = Object.getOwnPropertySymbols(e);
                t && (n = n.filter(function (t) {
                    return Object.getOwnPropertyDescriptor(e, t).enumerable
                })), i.push.apply(i, n)
            }
            return i
        }

        function r(s) {
            for (var t = 1; t < arguments.length; t++) {
                var o = null != arguments[t] ? arguments[t] : {};
                t % 2 ? e(Object(o), !0).forEach(function (t) {
                    var e, i, n;
                    e = s, n = o[i = t], i in e ? Object.defineProperty(e, i, {
                        value: n,
                        enumerable: !0,
                        configurable: !0,
                        writable: !0
                    }) : e[i] = n
                }) : Object.getOwnPropertyDescriptors ? Object.defineProperties(s, Object.getOwnPropertyDescriptors(o)) : e(Object(o)).forEach(function (t) {
                    Object.defineProperty(s, t, Object.getOwnPropertyDescriptor(o, t))
                })
            }
            return s
        }
        f = f && f.hasOwnProperty("default") ? f.default : f;
        var i = "transitionend";
        var g = {
            TRANSITION_END: "bsTransitionEnd",
            getUID: function (t) {
                for (; t += ~~(1e6 * Math.random()), document.getElementById(t););
                return t
            },
            getSelectorFromElement: function (t) {
                var e = t.getAttribute("data-target");
                if (!e || "#" === e) {
                    var i = t.getAttribute("href");
                    e = i && "#" !== i ? i.trim() : ""
                }
                try {
                    return document.querySelector(e) ? e : null
                } catch (t) {
                    return null
                }
            },
            getTransitionDurationFromElement: function (t) {
                if (!t) return 0;
                var e = f(t).css("transition-duration"),
                    i = f(t).css("transition-delay"),
                    n = parseFloat(e),
                    s = parseFloat(i);
                return n || s ? (e = e.split(",")[0], i = i.split(",")[0], 1e3 * (parseFloat(e) + parseFloat(i))) : 0
            },
            reflow: function (t) {
                return t.offsetHeight
            },
            triggerTransitionEnd: function (t) {
                f(t).trigger(i)
            },
            supportsTransitionEnd: function () {
                return Boolean(i)
            },
            isElement: function (t) {
                return (t[0] || t).nodeType
            },
            typeCheckConfig: function (t, e, i) {
                for (var n in i)
                    if (Object.prototype.hasOwnProperty.call(i, n)) {
                        var s = i[n],
                            o = e[n],
                            r = o && g.isElement(o) ? "element" : {}.toString.call(o).match(/\s([a-z]+)/i)[1].toLowerCase();
                        if (!new RegExp(s).test(r)) throw new Error(t.toUpperCase() + ': Option "' + n + '" provided type "' + r + '" but expected type "' + s + '".')
                    }
            },
            findShadowRoot: function (t) {
                if (!document.documentElement.attachShadow) return null;
                if ("function" != typeof t.getRootNode) return t instanceof ShadowRoot ? t : t.parentNode ? g.findShadowRoot(t.parentNode) : null;
                var e = t.getRootNode();
                return e instanceof ShadowRoot ? e : null
            },
            jQueryDetection: function () {
                if (void 0 === f) throw new TypeError("Bootstrap's JavaScript requires jQuery. jQuery must be included before Bootstrap's JavaScript.");
                var t = f.fn.jquery.split(" ")[0].split(".");
                if (t[0] < 2 && t[1] < 9 || 1 === t[0] && 9 === t[1] && t[2] < 1 || 4 <= t[0]) throw new Error("Bootstrap's JavaScript requires at least jQuery v1.9.1 but less than v4.0.0")
            }
        };
        g.jQueryDetection(), f.fn.emulateTransitionEnd = function (t) {
            var e = this,
                i = !1;
            return f(this).one(g.TRANSITION_END, function () {
                i = !0
            }), setTimeout(function () {
                i || g.triggerTransitionEnd(e)
            }, t), this
        }, f.event.special[g.TRANSITION_END] = {
            bindType: i,
            delegateType: i,
            handle: function (t) {
                if (f(t.target).is(this)) return t.handleObj.handler.apply(this, arguments)
            }
        };
        var s, a = "alert",
            l = "bs.alert",
            h = "." + l,
            c = f.fn[a],
            u = {
                CLOSE: "close" + h,
                CLOSED: "closed" + h,
                CLICK_DATA_API: "click" + h + ".data-api"
            },
            d = ((s = p.prototype).close = function (t) {
                var e = this._element;
                t && (e = this._getRootElement(t)), this._triggerCloseEvent(e).isDefaultPrevented() || this._removeElement(e)
            }, s.dispose = function () {
                f.removeData(this._element, l), this._element = null
            }, s._getRootElement = function (t) {
                var e = g.getSelectorFromElement(t),
                    i = !1;
                return e && (i = document.querySelector(e)), i || f(t).closest(".alert")[0]
            }, s._triggerCloseEvent = function (t) {
                var e = f.Event(u.CLOSE);
                return f(t).trigger(e), e
            }, s._removeElement = function (e) {
                var i = this;
                if (f(e).removeClass("show"), f(e).hasClass("fade")) {
                    var t = g.getTransitionDurationFromElement(e);
                    f(e).one(g.TRANSITION_END, function (t) {
                        return i._destroyElement(e, t)
                    }).emulateTransitionEnd(t)
                } else this._destroyElement(e)
            }, s._destroyElement = function (t) {
                f(t).detach().trigger(u.CLOSED).remove()
            }, p._jQueryInterface = function (i) {
                return this.each(function () {
                    var t = f(this),
                        e = t.data(l);
                    e || (e = new p(this), t.data(l, e)), "close" === i && e[i](this)
                })
            }, p._handleDismiss = function (e) {
                return function (t) {
                    t && t.preventDefault(), e.close(this)
                }
            }, o(p, null, [{
                key: "VERSION",
                get: function () {
                    return "4.4.1"
                }
            }]), p);

        function p(t) {
            this._element = t
        }
        f(document).on(u.CLICK_DATA_API, '[data-dismiss="alert"]', d._handleDismiss(new d)), f.fn[a] = d._jQueryInterface, f.fn[a].Constructor = d, f.fn[a].noConflict = function () {
            return f.fn[a] = c, d._jQueryInterface
        };
        var m, v = "button",
            _ = "bs.button",
            b = "." + _,
            y = ".data-api",
            w = f.fn[v],
            C = "active",
            x = '[data-toggle^="button"]',
            k = 'input:not([type="hidden"])',
            D = {
                CLICK_DATA_API: "click" + b + y,
                FOCUS_BLUR_DATA_API: "focus" + b + y + " blur" + b + y,
                LOAD_DATA_API: "load" + b + y
            },
            T = ((m = S.prototype).toggle = function () {
                var t = !0,
                    e = !0,
                    i = f(this._element).closest('[data-toggle="buttons"]')[0];
                if (i) {
                    var n = this._element.querySelector(k);
                    if (n) {
                        if ("radio" === n.type)
                            if (n.checked && this._element.classList.contains(C)) t = !1;
                            else {
                                var s = i.querySelector(".active");
                                s && f(s).removeClass(C)
                            } else "checkbox" === n.type ? "LABEL" === this._element.tagName && n.checked === this._element.classList.contains(C) && (t = !1) : t = !1;
                        t && (n.checked = !this._element.classList.contains(C), f(n).trigger("change")), n.focus(), e = !1
                    }
                }
                this._element.hasAttribute("disabled") || this._element.classList.contains("disabled") || (e && this._element.setAttribute("aria-pressed", !this._element.classList.contains(C)), t && f(this._element).toggleClass(C))
            }, m.dispose = function () {
                f.removeData(this._element, _), this._element = null
            }, S._jQueryInterface = function (e) {
                return this.each(function () {
                    var t = f(this).data(_);
                    t || (t = new S(this), f(this).data(_, t)), "toggle" === e && t[e]()
                })
            }, o(S, null, [{
                key: "VERSION",
                get: function () {
                    return "4.4.1"
                }
            }]), S);

        function S(t) {
            this._element = t
        }
        f(document).on(D.CLICK_DATA_API, x, function (t) {
            var e = t.target;
            if (f(e).hasClass("btn") || (e = f(e).closest(".btn")[0]), !e || e.hasAttribute("disabled") || e.classList.contains("disabled")) t.preventDefault();
            else {
                var i = e.querySelector(k);
                if (i && (i.hasAttribute("disabled") || i.classList.contains("disabled"))) return void t.preventDefault();
                T._jQueryInterface.call(f(e), "toggle")
            }
        }).on(D.FOCUS_BLUR_DATA_API, x, function (t) {
            var e = f(t.target).closest(".btn")[0];
            f(e).toggleClass("focus", /^focus(in)?$/.test(t.type))
        }), f(window).on(D.LOAD_DATA_API, function () {
            for (var t = [].slice.call(document.querySelectorAll('[data-toggle="buttons"] .btn')), e = 0, i = t.length; e < i; e++) {
                var n = t[e],
                    s = n.querySelector(k);
                s.checked || s.hasAttribute("checked") ? n.classList.add(C) : n.classList.remove(C)
            }
            for (var o = 0, r = (t = [].slice.call(document.querySelectorAll('[data-toggle="button"]'))).length; o < r; o++) {
                var a = t[o];
                "true" === a.getAttribute("aria-pressed") ? a.classList.add(C) : a.classList.remove(C)
            }
        }), f.fn[v] = T._jQueryInterface, f.fn[v].Constructor = T, f.fn[v].noConflict = function () {
            return f.fn[v] = w, T._jQueryInterface
        };
        var E, I = "carousel",
            A = "bs.carousel",
            P = "." + A,
            N = f.fn[I],
            O = {
                interval: 5e3,
                keyboard: !0,
                slide: !1,
                pause: "hover",
                wrap: !0,
                touch: !0
            },
            M = {
                interval: "(number|boolean)",
                keyboard: "boolean",
                slide: "(boolean|string)",
                pause: "(string|boolean)",
                wrap: "boolean",
                touch: "boolean"
            },
            $ = "next",
            H = "prev",
            L = {
                SLIDE: "slide" + P,
                SLID: "slid" + P,
                KEYDOWN: "keydown" + P,
                MOUSEENTER: "mouseenter" + P,
                MOUSELEAVE: "mouseleave" + P,
                TOUCHSTART: "touchstart" + P,
                TOUCHMOVE: "touchmove" + P,
                TOUCHEND: "touchend" + P,
                POINTERDOWN: "pointerdown" + P,
                POINTERUP: "pointerup" + P,
                DRAG_START: "dragstart" + P,
                LOAD_DATA_API: "load" + P + ".data-api",
                CLICK_DATA_API: "click" + P + ".data-api"
            },
            R = "active",
            W = ".active.carousel-item",
            F = {
                TOUCH: "touch",
                PEN: "pen"
            },
            j = ((E = z.prototype).next = function () {
                this._isSliding || this._slide($)
            }, E.nextWhenVisible = function () {
                !document.hidden && f(this._element).is(":visible") && "hidden" !== f(this._element).css("visibility") && this.next()
            }, E.prev = function () {
                this._isSliding || this._slide(H)
            }, E.pause = function (t) {
                t || (this._isPaused = !0), this._element.querySelector(".carousel-item-next, .carousel-item-prev") && (g.triggerTransitionEnd(this._element), this.cycle(!0)), clearInterval(this._interval), this._interval = null
            }, E.cycle = function (t) {
                t || (this._isPaused = !1), this._interval && (clearInterval(this._interval), this._interval = null), this._config.interval && !this._isPaused && (this._interval = setInterval((document.visibilityState ? this.nextWhenVisible : this.next).bind(this), this._config.interval))
            }, E.to = function (t) {
                var e = this;
                this._activeElement = this._element.querySelector(W);
                var i = this._getItemIndex(this._activeElement);
                if (!(t > this._items.length - 1 || t < 0))
                    if (this._isSliding) f(this._element).one(L.SLID, function () {
                        return e.to(t)
                    });
                    else {
                        if (i === t) return this.pause(), void this.cycle();
                        var n = i < t ? $ : H;
                        this._slide(n, this._items[t])
                    }
            }, E.dispose = function () {
                f(this._element).off(P), f.removeData(this._element, A), this._items = null, this._config = null, this._element = null, this._interval = null, this._isPaused = null, this._isSliding = null, this._activeElement = null, this._indicatorsElement = null
            }, E._getConfig = function (t) {
                return t = r({}, O, {}, t), g.typeCheckConfig(I, t, M), t
            }, E._handleSwipe = function () {
                var t = Math.abs(this.touchDeltaX);
                if (!(t <= 40)) {
                    var e = t / this.touchDeltaX;
                    (this.touchDeltaX = 0) < e && this.prev(), e < 0 && this.next()
                }
            }, E._addEventListeners = function () {
                var e = this;
                this._config.keyboard && f(this._element).on(L.KEYDOWN, function (t) {
                    return e._keydown(t)
                }), "hover" === this._config.pause && f(this._element).on(L.MOUSEENTER, function (t) {
                    return e.pause(t)
                }).on(L.MOUSELEAVE, function (t) {
                    return e.cycle(t)
                }), this._config.touch && this._addTouchEventListeners()
            }, E._addTouchEventListeners = function () {
                var i = this;
                if (this._touchSupported) {
                    var e = function (t) {
                        i._pointerEvent && F[t.originalEvent.pointerType.toUpperCase()] ? i.touchStartX = t.originalEvent.clientX : i._pointerEvent || (i.touchStartX = t.originalEvent.touches[0].clientX)
                    },
                        n = function (t) {
                            i._pointerEvent && F[t.originalEvent.pointerType.toUpperCase()] && (i.touchDeltaX = t.originalEvent.clientX - i.touchStartX), i._handleSwipe(), "hover" === i._config.pause && (i.pause(), i.touchTimeout && clearTimeout(i.touchTimeout), i.touchTimeout = setTimeout(function (t) {
                                return i.cycle(t)
                            }, 500 + i._config.interval))
                        };
                    f(this._element.querySelectorAll(".carousel-item img")).on(L.DRAG_START, function (t) {
                        return t.preventDefault()
                    }), this._pointerEvent ? (f(this._element).on(L.POINTERDOWN, function (t) {
                        return e(t)
                    }), f(this._element).on(L.POINTERUP, function (t) {
                        return n(t)
                    }), this._element.classList.add("pointer-event")) : (f(this._element).on(L.TOUCHSTART, function (t) {
                        return e(t)
                    }), f(this._element).on(L.TOUCHMOVE, function (t) {
                        var e;
                        (e = t).originalEvent.touches && 1 < e.originalEvent.touches.length ? i.touchDeltaX = 0 : i.touchDeltaX = e.originalEvent.touches[0].clientX - i.touchStartX
                    }), f(this._element).on(L.TOUCHEND, function (t) {
                        return n(t)
                    }))
                }
            }, E._keydown = function (t) {
                if (!/input|textarea/i.test(t.target.tagName)) switch (t.which) {
                    case 37:
                        t.preventDefault(), this.prev();
                        break;
                    case 39:
                        t.preventDefault(), this.next()
                }
            }, E._getItemIndex = function (t) {
                return this._items = t && t.parentNode ? [].slice.call(t.parentNode.querySelectorAll(".carousel-item")) : [], this._items.indexOf(t)
            }, E._getItemByDirection = function (t, e) {
                var i = t === $,
                    n = t === H,
                    s = this._getItemIndex(e),
                    o = this._items.length - 1;
                if ((n && 0 === s || i && s === o) && !this._config.wrap) return e;
                var r = (s + (t === H ? -1 : 1)) % this._items.length;
                return -1 == r ? this._items[this._items.length - 1] : this._items[r]
            }, E._triggerSlideEvent = function (t, e) {
                var i = this._getItemIndex(t),
                    n = this._getItemIndex(this._element.querySelector(W)),
                    s = f.Event(L.SLIDE, {
                        relatedTarget: t,
                        direction: e,
                        from: n,
                        to: i
                    });
                return f(this._element).trigger(s), s
            }, E._setActiveIndicatorElement = function (t) {
                if (this._indicatorsElement) {
                    var e = [].slice.call(this._indicatorsElement.querySelectorAll(".active"));
                    f(e).removeClass(R);
                    var i = this._indicatorsElement.children[this._getItemIndex(t)];
                    i && f(i).addClass(R)
                }
            }, E._slide = function (t, e) {
                var i, n, s, o = this,
                    r = this._element.querySelector(W),
                    a = this._getItemIndex(r),
                    l = e || r && this._getItemByDirection(t, r),
                    h = this._getItemIndex(l),
                    c = Boolean(this._interval);
                if (s = t === $ ? (i = "carousel-item-left", n = "carousel-item-next", "left") : (i = "carousel-item-right", n = "carousel-item-prev", "right"), l && f(l).hasClass(R)) this._isSliding = !1;
                else if (!this._triggerSlideEvent(l, s).isDefaultPrevented() && r && l) {
                    this._isSliding = !0, c && this.pause(), this._setActiveIndicatorElement(l);
                    var u = f.Event(L.SLID, {
                        relatedTarget: l,
                        direction: s,
                        from: a,
                        to: h
                    });
                    if (f(this._element).hasClass("slide")) {
                        f(l).addClass(n), g.reflow(l), f(r).addClass(i), f(l).addClass(i);
                        var d = parseInt(l.getAttribute("data-interval"), 10);
                        d ? (this._config.defaultInterval = this._config.defaultInterval || this._config.interval, this._config.interval = d) : this._config.interval = this._config.defaultInterval || this._config.interval;
                        var p = g.getTransitionDurationFromElement(r);
                        f(r).one(g.TRANSITION_END, function () {
                            f(l).removeClass(i + " " + n).addClass(R), f(r).removeClass(R + " " + n + " " + i), o._isSliding = !1, setTimeout(function () {
                                return f(o._element).trigger(u)
                            }, 0)
                        }).emulateTransitionEnd(p)
                    } else f(r).removeClass(R), f(l).addClass(R), this._isSliding = !1, f(this._element).trigger(u);
                    c && this.cycle()
                }
            }, z._jQueryInterface = function (n) {
                return this.each(function () {
                    var t = f(this).data(A),
                        e = r({}, O, {}, f(this).data());
                    "object" == typeof n && (e = r({}, e, {}, n));
                    var i = "string" == typeof n ? n : e.slide;
                    if (t || (t = new z(this, e), f(this).data(A, t)), "number" == typeof n) t.to(n);
                    else if ("string" == typeof i) {
                        if (void 0 === t[i]) throw new TypeError('No method named "' + i + '"');
                        t[i]()
                    } else e.interval && e.ride && (t.pause(), t.cycle())
                })
            }, z._dataApiClickHandler = function (t) {
                var e = g.getSelectorFromElement(this);
                if (e) {
                    var i = f(e)[0];
                    if (i && f(i).hasClass("carousel")) {
                        var n = r({}, f(i).data(), {}, f(this).data()),
                            s = this.getAttribute("data-slide-to");
                        s && (n.interval = !1), z._jQueryInterface.call(f(i), n), s && f(i).data(A).to(s), t.preventDefault()
                    }
                }
            }, o(z, null, [{
                key: "VERSION",
                get: function () {
                    return "4.4.1"
                }
            }, {
                key: "Default",
                get: function () {
                    return O
                }
            }]), z);

        function z(t, e) {
            this._items = null, this._interval = null, this._activeElement = null, this._isPaused = !1, this._isSliding = !1, this.touchTimeout = null, this.touchStartX = 0, this.touchDeltaX = 0, this._config = this._getConfig(e), this._element = t, this._indicatorsElement = this._element.querySelector(".carousel-indicators"), this._touchSupported = "ontouchstart" in document.documentElement || 0 < navigator.maxTouchPoints, this._pointerEvent = Boolean(window.PointerEvent || window.MSPointerEvent), this._addEventListeners()
        }
        f(document).on(L.CLICK_DATA_API, "[data-slide], [data-slide-to]", j._dataApiClickHandler), f(window).on(L.LOAD_DATA_API, function () {
            for (var t = [].slice.call(document.querySelectorAll('[data-ride="carousel"]')), e = 0, i = t.length; e < i; e++) {
                var n = f(t[e]);
                j._jQueryInterface.call(n, n.data())
            }
        }), f.fn[I] = j._jQueryInterface, f.fn[I].Constructor = j, f.fn[I].noConflict = function () {
            return f.fn[I] = N, j._jQueryInterface
        };
        var q, B = "collapse",
            U = "bs.collapse",
            Y = "." + U,
            K = f.fn[B],
            V = {
                toggle: !0,
                parent: ""
            },
            X = {
                toggle: "boolean",
                parent: "(string|element)"
            },
            Q = {
                SHOW: "show" + Y,
                SHOWN: "shown" + Y,
                HIDE: "hide" + Y,
                HIDDEN: "hidden" + Y,
                CLICK_DATA_API: "click" + Y + ".data-api"
            },
            G = "show",
            J = "collapse",
            Z = "collapsing",
            tt = "collapsed",
            et = '[data-toggle="collapse"]',
            it = ((q = nt.prototype).toggle = function () {
                f(this._element).hasClass(G) ? this.hide() : this.show()
            }, q.show = function () {
                var t, e, i = this;
                if (!(this._isTransitioning || f(this._element).hasClass(G) || (this._parent && 0 === (t = [].slice.call(this._parent.querySelectorAll(".show, .collapsing")).filter(function (t) {
                    return "string" == typeof i._config.parent ? t.getAttribute("data-parent") === i._config.parent : t.classList.contains(J)
                })).length && (t = null), t && (e = f(t).not(this._selector).data(U)) && e._isTransitioning))) {
                    var n = f.Event(Q.SHOW);
                    if (f(this._element).trigger(n), !n.isDefaultPrevented()) {
                        t && (nt._jQueryInterface.call(f(t).not(this._selector), "hide"), e || f(t).data(U, null));
                        var s = this._getDimension();
                        f(this._element).removeClass(J).addClass(Z), this._element.style[s] = 0, this._triggerArray.length && f(this._triggerArray).removeClass(tt).attr("aria-expanded", !0), this.setTransitioning(!0);
                        var o = "scroll" + (s[0].toUpperCase() + s.slice(1)),
                            r = g.getTransitionDurationFromElement(this._element);
                        f(this._element).one(g.TRANSITION_END, function () {
                            f(i._element).removeClass(Z).addClass(J).addClass(G), i._element.style[s] = "", i.setTransitioning(!1), f(i._element).trigger(Q.SHOWN)
                        }).emulateTransitionEnd(r), this._element.style[s] = this._element[o] + "px"
                    }
                }
            }, q.hide = function () {
                var t = this;
                if (!this._isTransitioning && f(this._element).hasClass(G)) {
                    var e = f.Event(Q.HIDE);
                    if (f(this._element).trigger(e), !e.isDefaultPrevented()) {
                        var i = this._getDimension();
                        this._element.style[i] = this._element.getBoundingClientRect()[i] + "px", g.reflow(this._element), f(this._element).addClass(Z).removeClass(J).removeClass(G);
                        var n = this._triggerArray.length;
                        if (0 < n)
                            for (var s = 0; s < n; s++) {
                                var o = this._triggerArray[s],
                                    r = g.getSelectorFromElement(o);
                                null !== r && (f([].slice.call(document.querySelectorAll(r))).hasClass(G) || f(o).addClass(tt).attr("aria-expanded", !1))
                            }
                        this.setTransitioning(!0), this._element.style[i] = "";
                        var a = g.getTransitionDurationFromElement(this._element);
                        f(this._element).one(g.TRANSITION_END, function () {
                            t.setTransitioning(!1), f(t._element).removeClass(Z).addClass(J).trigger(Q.HIDDEN)
                        }).emulateTransitionEnd(a)
                    }
                }
            }, q.setTransitioning = function (t) {
                this._isTransitioning = t
            }, q.dispose = function () {
                f.removeData(this._element, U), this._config = null, this._parent = null, this._element = null, this._triggerArray = null, this._isTransitioning = null
            }, q._getConfig = function (t) {
                return (t = r({}, V, {}, t)).toggle = Boolean(t.toggle), g.typeCheckConfig(B, t, X), t
            }, q._getDimension = function () {
                return f(this._element).hasClass("width") ? "width" : "height"
            }, q._getParent = function () {
                var t, i = this;
                g.isElement(this._config.parent) ? (t = this._config.parent, void 0 !== this._config.parent.jquery && (t = this._config.parent[0])) : t = document.querySelector(this._config.parent);
                var e = '[data-toggle="collapse"][data-parent="' + this._config.parent + '"]',
                    n = [].slice.call(t.querySelectorAll(e));
                return f(n).each(function (t, e) {
                    i._addAriaAndCollapsedClass(nt._getTargetFromElement(e), [e])
                }), t
            }, q._addAriaAndCollapsedClass = function (t, e) {
                var i = f(t).hasClass(G);
                e.length && f(e).toggleClass(tt, !i).attr("aria-expanded", i)
            }, nt._getTargetFromElement = function (t) {
                var e = g.getSelectorFromElement(t);
                return e ? document.querySelector(e) : null
            }, nt._jQueryInterface = function (n) {
                return this.each(function () {
                    var t = f(this),
                        e = t.data(U),
                        i = r({}, V, {}, t.data(), {}, "object" == typeof n && n ? n : {});
                    if (!e && i.toggle && /show|hide/.test(n) && (i.toggle = !1), e || (e = new nt(this, i), t.data(U, e)), "string" == typeof n) {
                        if (void 0 === e[n]) throw new TypeError('No method named "' + n + '"');
                        e[n]()
                    }
                })
            }, o(nt, null, [{
                key: "VERSION",
                get: function () {
                    return "4.4.1"
                }
            }, {
                key: "Default",
                get: function () {
                    return V
                }
            }]), nt);

        function nt(e, t) {
            this._isTransitioning = !1, this._element = e, this._config = this._getConfig(t), this._triggerArray = [].slice.call(document.querySelectorAll('[data-toggle="collapse"][href="#' + e.id + '"],[data-toggle="collapse"][data-target="#' + e.id + '"]'));
            for (var i = [].slice.call(document.querySelectorAll(et)), n = 0, s = i.length; n < s; n++) {
                var o = i[n],
                    r = g.getSelectorFromElement(o),
                    a = [].slice.call(document.querySelectorAll(r)).filter(function (t) {
                        return t === e
                    });
                null !== r && 0 < a.length && (this._selector = r, this._triggerArray.push(o))
            }
            this._parent = this._config.parent ? this._getParent() : null, this._config.parent || this._addAriaAndCollapsedClass(this._element, this._triggerArray), this._config.toggle && this.toggle()
        }
        f(document).on(Q.CLICK_DATA_API, et, function (t) {
            "A" === t.currentTarget.tagName && t.preventDefault();
            var i = f(this),
                e = g.getSelectorFromElement(this),
                n = [].slice.call(document.querySelectorAll(e));
            f(n).each(function () {
                var t = f(this),
                    e = t.data(U) ? "toggle" : i.data();
                it._jQueryInterface.call(t, e)
            })
        }), f.fn[B] = it._jQueryInterface, f.fn[B].Constructor = it, f.fn[B].noConflict = function () {
            return f.fn[B] = K, it._jQueryInterface
        };
        var st = "undefined" != typeof window && "undefined" != typeof document && "undefined" != typeof navigator,
            ot = function () {
                for (var t = ["Edge", "Trident", "Firefox"], e = 0; e < t.length; e += 1)
                    if (st && 0 <= navigator.userAgent.indexOf(t[e])) return 1;
                return 0
            }(),
            rt = st && window.Promise ? function (t) {
                var e = !1;
                return function () {
                    e || (e = !0, window.Promise.resolve().then(function () {
                        e = !1, t()
                    }))
                }
            } : function (t) {
                var e = !1;
                return function () {
                    e || (e = !0, setTimeout(function () {
                        e = !1, t()
                    }, ot))
                }
            };

        function at(t) {
            return t && "[object Function]" === {}.toString.call(t)
        }

        function lt(t, e) {
            if (1 !== t.nodeType) return [];
            var i = t.ownerDocument.defaultView.getComputedStyle(t, null);
            return e ? i[e] : i
        }

        function ht(t) {
            return "HTML" === t.nodeName ? t : t.parentNode || t.host
        }

        function ct(t) {
            if (!t) return document.body;
            switch (t.nodeName) {
                case "HTML":
                case "BODY":
                    return t.ownerDocument.body;
                case "#document":
                    return t.body
            }
            var e = lt(t),
                i = e.overflow,
                n = e.overflowX,
                s = e.overflowY;
            return /(auto|scroll|overlay)/.test(i + s + n) ? t : ct(ht(t))
        }

        function ut(t) {
            return t && t.referenceNode ? t.referenceNode : t
        }
        var dt = st && !(!window.MSInputMethodContext || !document.documentMode),
            pt = st && /MSIE 10/.test(navigator.userAgent);

        function ft(t) {
            return 11 === t ? dt : 10 === t ? pt : dt || pt
        }

        function gt(t) {
            if (!t) return document.documentElement;
            for (var e = ft(10) ? document.body : null, i = t.offsetParent || null; i === e && t.nextElementSibling;) i = (t = t.nextElementSibling).offsetParent;
            var n = i && i.nodeName;
            return n && "BODY" !== n && "HTML" !== n ? -1 !== ["TH", "TD", "TABLE"].indexOf(i.nodeName) && "static" === lt(i, "position") ? gt(i) : i : t ? t.ownerDocument.documentElement : document.documentElement
        }

        function mt(t) {
            return null !== t.parentNode ? mt(t.parentNode) : t
        }

        function vt(t, e) {
            if (!(t && t.nodeType && e && e.nodeType)) return document.documentElement;
            var i = t.compareDocumentPosition(e) & Node.DOCUMENT_POSITION_FOLLOWING,
                n = i ? t : e,
                s = i ? e : t,
                o = document.createRange();
            o.setStart(n, 0), o.setEnd(s, 0);
            var r, a, l = o.commonAncestorContainer;
            if (t !== l && e !== l || n.contains(s)) return "BODY" === (a = (r = l).nodeName) || "HTML" !== a && gt(r.firstElementChild) !== r ? gt(l) : l;
            var h = mt(t);
            return h.host ? vt(h.host, e) : vt(t, mt(e).host)
        }

        function _t(t, e) {
            var i = "top" === (1 < arguments.length && void 0 !== e ? e : "top") ? "scrollTop" : "scrollLeft",
                n = t.nodeName;
            if ("BODY" !== n && "HTML" !== n) return t[i];
            var s = t.ownerDocument.documentElement;
            return (t.ownerDocument.scrollingElement || s)[i]
        }

        function bt(t, e) {
            var i = "x" === e ? "Left" : "Top",
                n = "Left" == i ? "Right" : "Bottom";
            return parseFloat(t["border" + i + "Width"], 10) + parseFloat(t["border" + n + "Width"], 10)
        }

        function yt(t, e, i, n) {
            return Math.max(e["offset" + t], e["scroll" + t], i["client" + t], i["offset" + t], i["scroll" + t], ft(10) ? parseInt(i["offset" + t]) + parseInt(n["margin" + ("Height" === t ? "Top" : "Left")]) + parseInt(n["margin" + ("Height" === t ? "Bottom" : "Right")]) : 0)
        }

        function wt(t) {
            var e = t.body,
                i = t.documentElement,
                n = ft(10) && getComputedStyle(i);
            return {
                height: yt("Height", e, i, n),
                width: yt("Width", e, i, n)
            }
        }

        function Ct(t, e) {
            for (var i = 0; i < e.length; i++) {
                var n = e[i];
                n.enumerable = n.enumerable || !1, n.configurable = !0, "value" in n && (n.writable = !0), Object.defineProperty(t, n.key, n)
            }
        }

        function xt(t, e, i) {
            return e in t ? Object.defineProperty(t, e, {
                value: i,
                enumerable: !0,
                configurable: !0,
                writable: !0
            }) : t[e] = i, t
        }
        var kt = Object.assign || function (t) {
            for (var e = 1; e < arguments.length; e++) {
                var i = arguments[e];
                for (var n in i) Object.prototype.hasOwnProperty.call(i, n) && (t[n] = i[n])
            }
            return t
        };

        function Dt(t) {
            return kt({}, t, {
                right: t.left + t.width,
                bottom: t.top + t.height
            })
        }

        function Tt(t) {
            var e = {};
            try {
                if (ft(10)) {
                    e = t.getBoundingClientRect();
                    var i = _t(t, "top"),
                        n = _t(t, "left");
                    e.top += i, e.left += n, e.bottom += i, e.right += n
                } else e = t.getBoundingClientRect()
            } catch (t) { }
            var s = {
                left: e.left,
                top: e.top,
                width: e.right - e.left,
                height: e.bottom - e.top
            },
                o = "HTML" === t.nodeName ? wt(t.ownerDocument) : {},
                r = o.width || t.clientWidth || s.width,
                a = o.height || t.clientHeight || s.height,
                l = t.offsetWidth - r,
                h = t.offsetHeight - a;
            if (l || h) {
                var c = lt(t);
                l -= bt(c, "x"), h -= bt(c, "y"), s.width -= l, s.height -= h
            }
            return Dt(s)
        }

        function St(t, e, i) {
            var n = 2 < arguments.length && void 0 !== i && i,
                s = ft(10),
                o = "HTML" === e.nodeName,
                r = Tt(t),
                a = Tt(e),
                l = ct(t),
                h = lt(e),
                c = parseFloat(h.borderTopWidth, 10),
                u = parseFloat(h.borderLeftWidth, 10);
            n && o && (a.top = Math.max(a.top, 0), a.left = Math.max(a.left, 0));
            var d = Dt({
                top: r.top - a.top - c,
                left: r.left - a.left - u,
                width: r.width,
                height: r.height
            });
            if (d.marginTop = 0, d.marginLeft = 0, !s && o) {
                var p = parseFloat(h.marginTop, 10),
                    f = parseFloat(h.marginLeft, 10);
                d.top -= c - p, d.bottom -= c - p, d.left -= u - f, d.right -= u - f, d.marginTop = p, d.marginLeft = f
            }
            return (s && !n ? e.contains(l) : e === l && "BODY" !== l.nodeName) && (d = function (t, e, i) {
                var n = 2 < arguments.length && !1,
                    s = _t(e, "top"),
                    o = _t(e, "left"),
                    r = n ? -1 : 1;
                return t.top += s * r, t.bottom += s * r, t.left += o * r, t.right += o * r, t
            }(d, e)), d
        }

        function Et(t) {
            if (!t || !t.parentElement || ft()) return document.documentElement;
            for (var e = t.parentElement; e && "none" === lt(e, "transform");) e = e.parentElement;
            return e || document.documentElement
        }

        function It(t, e, i, n, s) {
            var o = 4 < arguments.length && void 0 !== s && s,
                r = {
                    top: 0,
                    left: 0
                },
                a = o ? Et(t) : vt(t, ut(e));
            if ("viewport" === n) r = function (t, e) {
                var i = 1 < arguments.length && void 0 !== e && e,
                    n = t.ownerDocument.documentElement,
                    s = St(t, n),
                    o = Math.max(n.clientWidth, window.innerWidth || 0),
                    r = Math.max(n.clientHeight, window.innerHeight || 0),
                    a = i ? 0 : _t(n),
                    l = i ? 0 : _t(n, "left");
                return Dt({
                    top: a - s.top + s.marginTop,
                    left: l - s.left + s.marginLeft,
                    width: o,
                    height: r
                })
            }(a, o);
            else {
                var l = void 0;
                "scrollParent" === n ? "BODY" === (l = ct(ht(e))).nodeName && (l = t.ownerDocument.documentElement) : l = "window" === n ? t.ownerDocument.documentElement : n;
                var h = St(l, a, o);
                if ("HTML" !== l.nodeName || function t(e) {
                    var i = e.nodeName;
                    if ("BODY" === i || "HTML" === i) return !1;
                    if ("fixed" === lt(e, "position")) return !0;
                    var n = ht(e);
                    return !!n && t(n)
                }(a)) r = h;
                else {
                    var c = wt(t.ownerDocument),
                        u = c.height,
                        d = c.width;
                    r.top += h.top - h.marginTop, r.bottom = u + h.top, r.left += h.left - h.marginLeft, r.right = d + h.left
                }
            }
            var p = "number" == typeof (i = i || 0);
            return r.left += p ? i : i.left || 0, r.top += p ? i : i.top || 0, r.right -= p ? i : i.right || 0, r.bottom -= p ? i : i.bottom || 0, r
        }

        function At(t, e, n, i, s, o) {
            var r = 5 < arguments.length && void 0 !== o ? o : 0;
            if (-1 === t.indexOf("auto")) return t;
            var a = It(n, i, r, s),
                l = {
                    top: {
                        width: a.width,
                        height: e.top - a.top
                    },
                    right: {
                        width: a.right - e.right,
                        height: a.height
                    },
                    bottom: {
                        width: a.width,
                        height: a.bottom - e.bottom
                    },
                    left: {
                        width: e.left - a.left,
                        height: a.height
                    }
                },
                h = Object.keys(l).map(function (t) {
                    return kt({
                        key: t
                    }, l[t], {
                        area: (e = l[t]).width * e.height
                    });
                    var e
                }).sort(function (t, e) {
                    return e.area - t.area
                }),
                c = h.filter(function (t) {
                    var e = t.width,
                        i = t.height;
                    return e >= n.clientWidth && i >= n.clientHeight
                }),
                u = 0 < c.length ? c[0].key : h[0].key,
                d = t.split("-")[1];
            return u + (d ? "-" + d : "")
        }

        function Pt(t, e, i, n) {
            var s = 3 < arguments.length && void 0 !== n ? n : null;
            return St(i, s ? Et(e) : vt(e, ut(i)), s)
        }

        function Nt(t) {
            var e = t.ownerDocument.defaultView.getComputedStyle(t),
                i = parseFloat(e.marginTop || 0) + parseFloat(e.marginBottom || 0),
                n = parseFloat(e.marginLeft || 0) + parseFloat(e.marginRight || 0);
            return {
                width: t.offsetWidth + n,
                height: t.offsetHeight + i
            }
        }

        function Ot(t) {
            var e = {
                left: "right",
                right: "left",
                bottom: "top",
                top: "bottom"
            };
            return t.replace(/left|right|bottom|top/g, function (t) {
                return e[t]
            })
        }

        function Mt(t, e, i) {
            i = i.split("-")[0];
            var n = Nt(t),
                s = {
                    width: n.width,
                    height: n.height
                },
                o = -1 !== ["right", "left"].indexOf(i),
                r = o ? "top" : "left",
                a = o ? "left" : "top",
                l = o ? "height" : "width",
                h = o ? "width" : "height";
            return s[r] = e[r] + e[l] / 2 - n[l] / 2, s[a] = i === a ? e[a] - n[h] : e[Ot(a)], s
        }

        function $t(t, e) {
            return Array.prototype.find ? t.find(e) : t.filter(e)[0]
        }

        function Ht(t, i, e) {
            return (void 0 === e ? t : t.slice(0, function (t, e) {
                if (Array.prototype.findIndex) return t.findIndex(function (t) {
                    return t.name === e
                });
                var i = $t(t, function (t) {
                    return t.name === e
                });
                return t.indexOf(i)
            }(t, e))).forEach(function (t) {
                t.function && console.warn("`modifier.function` is deprecated, use `modifier.fn`!");
                var e = t.function || t.fn;
                t.enabled && at(e) && (i.offsets.popper = Dt(i.offsets.popper), i.offsets.reference = Dt(i.offsets.reference), i = e(i, t))
            }), i
        }

        function Lt(t, i) {
            return t.some(function (t) {
                var e = t.name;
                return t.enabled && e === i
            })
        }

        function Rt(t) {
            for (var e = [!1, "ms", "Webkit", "Moz", "O"], i = t.charAt(0).toUpperCase() + t.slice(1), n = 0; n < e.length; n++) {
                var s = e[n],
                    o = s ? "" + s + i : t;
                if (void 0 !== document.body.style[o]) return o
            }
            return null
        }

        function Wt(t) {
            var e = t.ownerDocument;
            return e ? e.defaultView : window
        }

        function Ft() {
            var t, e;
            this.state.eventsEnabled && (cancelAnimationFrame(this.scheduleUpdate), this.state = (t = this.reference, e = this.state, Wt(t).removeEventListener("resize", e.updateBound), e.scrollParents.forEach(function (t) {
                t.removeEventListener("scroll", e.updateBound)
            }), e.updateBound = null, e.scrollParents = [], e.scrollElement = null, e.eventsEnabled = !1, e))
        }

        function jt(t) {
            return "" !== t && !isNaN(parseFloat(t)) && isFinite(t)
        }

        function zt(i, n) {
            Object.keys(n).forEach(function (t) {
                var e = ""; - 1 !== ["width", "height", "top", "right", "bottom", "left"].indexOf(t) && jt(n[t]) && (e = "px"), i.style[t] = n[t] + e
            })
        }
        var qt = st && /Firefox/i.test(navigator.userAgent);

        function Bt(t, e, i) {
            var n = $t(t, function (t) {
                return t.name === e
            }),
                s = !!n && t.some(function (t) {
                    return t.name === i && t.enabled && t.order < n.order
                });
            if (!s) {
                var o = "`" + e + "`",
                    r = "`" + i + "`";
                console.warn(r + " modifier is required by " + o + " modifier in order to work, be sure to include it before " + o + "!")
            }
            return s
        }
        var Ut = ["auto-start", "auto", "auto-end", "top-start", "top", "top-end", "right-start", "right", "right-end", "bottom-end", "bottom", "bottom-start", "left-end", "left", "left-start"],
            Yt = Ut.slice(3);

        function Kt(t, e) {
            var i = 1 < arguments.length && void 0 !== e && e,
                n = Yt.indexOf(t),
                s = Yt.slice(n + 1).concat(Yt.slice(0, n));
            return i ? s.reverse() : s
        }
        var Vt, Xt, Qt, Gt = {
            placement: "bottom",
            positionFixed: !1,
            eventsEnabled: !0,
            removeOnDestroy: !1,
            onCreate: function () { },
            onUpdate: function () { },
            modifiers: {
                shift: {
                    order: 100,
                    enabled: !0,
                    fn: function (t) {
                        var e = t.placement,
                            i = e.split("-")[0],
                            n = e.split("-")[1];
                        if (n) {
                            var s = t.offsets,
                                o = s.reference,
                                r = s.popper,
                                a = -1 !== ["bottom", "top"].indexOf(i),
                                l = a ? "left" : "top",
                                h = a ? "width" : "height",
                                c = {
                                    start: xt({}, l, o[l]),
                                    end: xt({}, l, o[l] + o[h] - r[h])
                                };
                            t.offsets.popper = kt({}, r, c[n])
                        }
                        return t
                    }
                },
                offset: {
                    order: 200,
                    enabled: !0,
                    fn: function (t, e) {
                        var i, n = e.offset,
                            s = t.placement,
                            o = t.offsets,
                            r = o.popper,
                            a = o.reference,
                            l = s.split("-")[0];
                        return i = jt(+n) ? [+n, 0] : function (t, s, o, e) {
                            var r = [0, 0],
                                a = -1 !== ["right", "left"].indexOf(e),
                                i = t.split(/(\+|\-)/).map(function (t) {
                                    return t.trim()
                                }),
                                n = i.indexOf($t(i, function (t) {
                                    return -1 !== t.search(/,|\s/)
                                }));
                            i[n] && -1 === i[n].indexOf(",") && console.warn("Offsets separated by white space(s) are deprecated, use a comma (,) instead.");
                            var l = /\s*,\s*|\s+/,
                                h = -1 !== n ? [i.slice(0, n).concat([i[n].split(l)[0]]), [i[n].split(l)[1]].concat(i.slice(n + 1))] : [i];
                            return (h = h.map(function (t, e) {
                                var i = (1 === e ? !a : a) ? "height" : "width",
                                    n = !1;
                                return t.reduce(function (t, e) {
                                    return "" === t[t.length - 1] && -1 !== ["+", "-"].indexOf(e) ? (t[t.length - 1] = e, n = !0, t) : n ? (t[t.length - 1] += e, n = !1, t) : t.concat(e)
                                }, []).map(function (t) {
                                    return function (t, e, i, n) {
                                        var s = t.match(/((?:\-|\+)?\d*\.?\d*)(.*)/),
                                            o = +s[1],
                                            r = s[2];
                                        if (!o) return t;
                                        if (0 !== r.indexOf("%")) return "vh" !== r && "vw" !== r ? o : ("vh" === r ? Math.max(document.documentElement.clientHeight, window.innerHeight || 0) : Math.max(document.documentElement.clientWidth, window.innerWidth || 0)) / 100 * o;
                                        var a = void 0;
                                        switch (r) {
                                            case "%p":
                                                a = i;
                                                break;
                                            case "%":
                                            case "%r":
                                            default:
                                                a = n
                                        }
                                        return Dt(a)[e] / 100 * o
                                    }(t, i, s, o)
                                })
                            })).forEach(function (i, n) {
                                i.forEach(function (t, e) {
                                    jt(t) && (r[n] += t * ("-" === i[e - 1] ? -1 : 1))
                                })
                            }), r
                        }(n, r, a, l), "left" === l ? (r.top += i[0], r.left -= i[1]) : "right" === l ? (r.top += i[0], r.left += i[1]) : "top" === l ? (r.left += i[0], r.top -= i[1]) : "bottom" === l && (r.left += i[0], r.top += i[1]), t.popper = r, t
                    },
                    offset: 0
                },
                preventOverflow: {
                    order: 300,
                    enabled: !0,
                    fn: function (t, n) {
                        var e = n.boundariesElement || gt(t.instance.popper);
                        t.instance.reference === e && (e = gt(e));
                        var i = Rt("transform"),
                            s = t.instance.popper.style,
                            o = s.top,
                            r = s.left,
                            a = s[i];
                        s.top = "", s.left = "", s[i] = "";
                        var l = It(t.instance.popper, t.instance.reference, n.padding, e, t.positionFixed);
                        s.top = o, s.left = r, s[i] = a, n.boundaries = l;
                        var h = n.priority,
                            c = t.offsets.popper,
                            u = {
                                primary: function (t) {
                                    var e = c[t];
                                    return c[t] < l[t] && !n.escapeWithReference && (e = Math.max(c[t], l[t])), xt({}, t, e)
                                },
                                secondary: function (t) {
                                    var e = "right" === t ? "left" : "top",
                                        i = c[e];
                                    return c[t] > l[t] && !n.escapeWithReference && (i = Math.min(c[e], l[t] - ("right" === t ? c.width : c.height))), xt({}, e, i)
                                }
                            };
                        return h.forEach(function (t) {
                            var e = -1 !== ["left", "top"].indexOf(t) ? "primary" : "secondary";
                            c = kt({}, c, u[e](t))
                        }), t.offsets.popper = c, t
                    },
                    priority: ["left", "right", "top", "bottom"],
                    padding: 5,
                    boundariesElement: "scrollParent"
                },
                keepTogether: {
                    order: 400,
                    enabled: !0,
                    fn: function (t) {
                        var e = t.offsets,
                            i = e.popper,
                            n = e.reference,
                            s = t.placement.split("-")[0],
                            o = Math.floor,
                            r = -1 !== ["top", "bottom"].indexOf(s),
                            a = r ? "right" : "bottom",
                            l = r ? "left" : "top",
                            h = r ? "width" : "height";
                        return i[a] < o(n[l]) && (t.offsets.popper[l] = o(n[l]) - i[h]), i[l] > o(n[a]) && (t.offsets.popper[l] = o(n[a])), t
                    }
                },
                arrow: {
                    order: 500,
                    enabled: !0,
                    fn: function (t, e) {
                        var i;
                        if (!Bt(t.instance.modifiers, "arrow", "keepTogether")) return t;
                        var n = e.element;
                        if ("string" == typeof n) {
                            if (!(n = t.instance.popper.querySelector(n))) return t
                        } else if (!t.instance.popper.contains(n)) return console.warn("WARNING: `arrow.element` must be child of its popper element!"), t;
                        var s = t.placement.split("-")[0],
                            o = t.offsets,
                            r = o.popper,
                            a = o.reference,
                            l = -1 !== ["left", "right"].indexOf(s),
                            h = l ? "height" : "width",
                            c = l ? "Top" : "Left",
                            u = c.toLowerCase(),
                            d = l ? "left" : "top",
                            p = l ? "bottom" : "right",
                            f = Nt(n)[h];
                        a[p] - f < r[u] && (t.offsets.popper[u] -= r[u] - (a[p] - f)), a[u] + f > r[p] && (t.offsets.popper[u] += a[u] + f - r[p]), t.offsets.popper = Dt(t.offsets.popper);
                        var g = a[u] + a[h] / 2 - f / 2,
                            m = lt(t.instance.popper),
                            v = parseFloat(m["margin" + c], 10),
                            _ = parseFloat(m["border" + c + "Width"], 10),
                            b = g - t.offsets.popper[u] - v - _;
                        return b = Math.max(Math.min(r[h] - f, b), 0), t.arrowElement = n, t.offsets.arrow = (xt(i = {}, u, Math.round(b)), xt(i, d, ""), i), t
                    },
                    element: "[x-arrow]"
                },
                flip: {
                    order: 600,
                    enabled: !0,
                    fn: function (g, m) {
                        if (Lt(g.instance.modifiers, "inner")) return g;
                        if (g.flipped && g.placement === g.originalPlacement) return g;
                        var v = It(g.instance.popper, g.instance.reference, m.padding, m.boundariesElement, g.positionFixed),
                            _ = g.placement.split("-")[0],
                            b = Ot(_),
                            y = g.placement.split("-")[1] || "",
                            w = [];
                        switch (m.behavior) {
                            case "flip":
                                w = [_, b];
                                break;
                            case "clockwise":
                                w = Kt(_);
                                break;
                            case "counterclockwise":
                                w = Kt(_, !0);
                                break;
                            default:
                                w = m.behavior
                        }
                        return w.forEach(function (t, e) {
                            if (_ !== t || w.length === e + 1) return g;
                            _ = g.placement.split("-")[0], b = Ot(_);
                            var i = g.offsets.popper,
                                n = g.offsets.reference,
                                s = Math.floor,
                                o = "left" === _ && s(i.right) > s(n.left) || "right" === _ && s(i.left) < s(n.right) || "top" === _ && s(i.bottom) > s(n.top) || "bottom" === _ && s(i.top) < s(n.bottom),
                                r = s(i.left) < s(v.left),
                                a = s(i.right) > s(v.right),
                                l = s(i.top) < s(v.top),
                                h = s(i.bottom) > s(v.bottom),
                                c = "left" === _ && r || "right" === _ && a || "top" === _ && l || "bottom" === _ && h,
                                u = -1 !== ["top", "bottom"].indexOf(_),
                                d = !!m.flipVariations && (u && "start" === y && r || u && "end" === y && a || !u && "start" === y && l || !u && "end" === y && h),
                                p = !!m.flipVariationsByContent && (u && "start" === y && a || u && "end" === y && r || !u && "start" === y && h || !u && "end" === y && l),
                                f = d || p;
                            (o || c || f) && (g.flipped = !0, (o || c) && (_ = w[e + 1]), f && (y = "end" === y ? "start" : "start" === y ? "end" : y), g.placement = _ + (y ? "-" + y : ""), g.offsets.popper = kt({}, g.offsets.popper, Mt(g.instance.popper, g.offsets.reference, g.placement)), g = Ht(g.instance.modifiers, g, "flip"))
                        }), g
                    },
                    behavior: "flip",
                    padding: 5,
                    boundariesElement: "viewport",
                    flipVariations: !1,
                    flipVariationsByContent: !1
                },
                inner: {
                    order: 700,
                    enabled: !1,
                    fn: function (t) {
                        var e = t.placement,
                            i = e.split("-")[0],
                            n = t.offsets,
                            s = n.popper,
                            o = n.reference,
                            r = -1 !== ["left", "right"].indexOf(i),
                            a = -1 === ["top", "left"].indexOf(i);
                        return s[r ? "left" : "top"] = o[i] - (a ? s[r ? "width" : "height"] : 0), t.placement = Ot(e), t.offsets.popper = Dt(s), t
                    }
                },
                hide: {
                    order: 800,
                    enabled: !0,
                    fn: function (t) {
                        if (!Bt(t.instance.modifiers, "hide", "preventOverflow")) return t;
                        var e = t.offsets.reference,
                            i = $t(t.instance.modifiers, function (t) {
                                return "preventOverflow" === t.name
                            }).boundaries;
                        if (e.bottom < i.top || e.left > i.right || e.top > i.bottom || e.right < i.left) {
                            if (!0 === t.hide) return t;
                            t.hide = !0, t.attributes["x-out-of-boundaries"] = ""
                        } else {
                            if (!1 === t.hide) return t;
                            t.hide = !1, t.attributes["x-out-of-boundaries"] = !1
                        }
                        return t
                    }
                },
                computeStyle: {
                    order: 850,
                    enabled: !0,
                    fn: function (t, e) {
                        var i = e.x,
                            n = e.y,
                            s = t.offsets.popper,
                            o = $t(t.instance.modifiers, function (t) {
                                return "applyStyle" === t.name
                            }).gpuAcceleration;
                        void 0 !== o && console.warn("WARNING: `gpuAcceleration` option moved to `computeStyle` modifier and will not be supported in future versions of Popper.js!");
                        var r, a, l, h, c, u, d, p, f, g, m, v, _, b, y, w = void 0 !== o ? o : e.gpuAcceleration,
                            C = gt(t.instance.popper),
                            x = Tt(C),
                            k = {
                                position: s.position
                            },
                            D = (l = t, h = window.devicePixelRatio < 2 || !qt, c = l.offsets, u = c.popper, d = c.reference, p = Math.round, f = Math.floor, g = p(d.width), m = p(u.width), v = -1 !== ["left", "right"].indexOf(l.placement), _ = -1 !== l.placement.indexOf("-"), y = h ? p : I, {
                                left: (b = h ? v || _ || g % 2 == m % 2 ? p : f : I)(g % 2 == 1 && m % 2 == 1 && !_ && h ? u.left - 1 : u.left),
                                top: y(u.top),
                                bottom: y(u.bottom),
                                right: b(u.right)
                            }),
                            T = "bottom" === i ? "top" : "bottom",
                            S = "right" === n ? "left" : "right",
                            E = Rt("transform");

                        function I(t) {
                            return t
                        }
                        if (a = "bottom" == T ? "HTML" === C.nodeName ? -C.clientHeight + D.bottom : -x.height + D.bottom : D.top, r = "right" == S ? "HTML" === C.nodeName ? -C.clientWidth + D.right : -x.width + D.right : D.left, w && E) k[E] = "translate3d(" + r + "px, " + a + "px, 0)", k[T] = 0, k[S] = 0, k.willChange = "transform";
                        else {
                            var A = "bottom" == T ? -1 : 1,
                                P = "right" == S ? -1 : 1;
                            k[T] = a * A, k[S] = r * P, k.willChange = T + ", " + S
                        }
                        var N = {
                            "x-placement": t.placement
                        };
                        return t.attributes = kt({}, N, t.attributes), t.styles = kt({}, k, t.styles), t.arrowStyles = kt({}, t.offsets.arrow, t.arrowStyles), t
                    },
                    gpuAcceleration: !0,
                    x: "bottom",
                    y: "right"
                },
                applyStyle: {
                    order: 900,
                    enabled: !0,
                    fn: function (t) {
                        return zt(t.instance.popper, t.styles), e = t.instance.popper, i = t.attributes, Object.keys(i).forEach(function (t) {
                            !1 !== i[t] ? e.setAttribute(t, i[t]) : e.removeAttribute(t)
                        }), t.arrowElement && Object.keys(t.arrowStyles).length && zt(t.arrowElement, t.arrowStyles), t;
                        var e, i
                    },
                    onLoad: function (t, e, i, n, s) {
                        var o = Pt(s, e, t, i.positionFixed),
                            r = At(i.placement, o, e, t, i.modifiers.flip.boundariesElement, i.modifiers.flip.padding);
                        return e.setAttribute("x-placement", r), zt(e, {
                            position: i.positionFixed ? "fixed" : "absolute"
                        }), i
                    },
                    gpuAcceleration: void 0
                }
            }
        },
            Jt = (Vt = Zt, (Xt = [{
                key: "update",
                value: function () {
                    return function () {
                        if (!this.state.isDestroyed) {
                            var t = {
                                instance: this,
                                styles: {},
                                arrowStyles: {},
                                attributes: {},
                                flipped: !1,
                                offsets: {}
                            };
                            t.offsets.reference = Pt(this.state, this.popper, this.reference, this.options.positionFixed), t.placement = At(this.options.placement, t.offsets.reference, this.popper, this.reference, this.options.modifiers.flip.boundariesElement, this.options.modifiers.flip.padding), t.originalPlacement = t.placement, t.positionFixed = this.options.positionFixed, t.offsets.popper = Mt(this.popper, t.offsets.reference, t.placement), t.offsets.popper.position = this.options.positionFixed ? "fixed" : "absolute", t = Ht(this.modifiers, t), this.state.isCreated ? this.options.onUpdate(t) : (this.state.isCreated = !0, this.options.onCreate(t))
                        }
                    }.call(this)
                }
            }, {
                key: "destroy",
                value: function () {
                    return function () {
                        return this.state.isDestroyed = !0, Lt(this.modifiers, "applyStyle") && (this.popper.removeAttribute("x-placement"), this.popper.style.position = "", this.popper.style.top = "", this.popper.style.left = "", this.popper.style.right = "", this.popper.style.bottom = "", this.popper.style.willChange = "", this.popper.style[Rt("transform")] = ""), this.disableEventListeners(), this.options.removeOnDestroy && this.popper.parentNode.removeChild(this.popper), this
                    }.call(this)
                }
            }, {
                key: "enableEventListeners",
                value: function () {
                    return function () {
                        this.state.eventsEnabled || (this.state = function (t, e, i) {
                            e.updateBound = i, Wt(t).addEventListener("resize", e.updateBound, {
                                passive: !0
                            });
                            var n = ct(t);
                            return function t(e, i, n, s) {
                                var o = "BODY" === e.nodeName,
                                    r = o ? e.ownerDocument.defaultView : e;
                                r.addEventListener(i, n, {
                                    passive: !0
                                }), o || t(ct(r.parentNode), i, n, s), s.push(r)
                            }(n, "scroll", e.updateBound, e.scrollParents), e.scrollElement = n, e.eventsEnabled = !0, e
                        }(this.reference, (this.options, this.state), this.scheduleUpdate))
                    }.call(this)
                }
            }, {
                key: "disableEventListeners",
                value: function () {
                    return Ft.call(this)
                }
            }]) && Ct(Vt.prototype, Xt), Qt && Ct(Vt, Qt), Zt);

        function Zt(t, e) {
            var i = this,
                n = 2 < arguments.length && void 0 !== arguments[2] ? arguments[2] : {};
            ! function (t) {
                if (!(t instanceof Zt)) throw new TypeError("Cannot call a class as a function")
            }(this), this.scheduleUpdate = function () {
                return requestAnimationFrame(i.update)
            }, this.update = rt(this.update.bind(this)), this.options = kt({}, Zt.Defaults, n), this.state = {
                isDestroyed: !1,
                isCreated: !1,
                scrollParents: []
            }, this.reference = t && t.jquery ? t[0] : t, this.popper = e && e.jquery ? e[0] : e, this.options.modifiers = {}, Object.keys(kt({}, Zt.Defaults.modifiers, n.modifiers)).forEach(function (t) {
                i.options.modifiers[t] = kt({}, Zt.Defaults.modifiers[t] || {}, n.modifiers ? n.modifiers[t] : {})
            }), this.modifiers = Object.keys(this.options.modifiers).map(function (t) {
                return kt({
                    name: t
                }, i.options.modifiers[t])
            }).sort(function (t, e) {
                return t.order - e.order
            }), this.modifiers.forEach(function (t) {
                t.enabled && at(t.onLoad) && t.onLoad(i.reference, i.popper, i.options, t, i.state)
            }), this.update();
            var s = this.options.eventsEnabled;
            s && this.enableEventListeners(), this.state.eventsEnabled = s
        }
        Jt.Utils = ("undefined" != typeof window ? window : global).PopperUtils, Jt.placements = Ut, Jt.Defaults = Gt;
        var te, ee = "dropdown",
            ie = "bs.dropdown",
            ne = "." + ie,
            se = ".data-api",
            oe = f.fn[ee],
            re = new RegExp("38|40|27"),
            ae = {
                HIDE: "hide" + ne,
                HIDDEN: "hidden" + ne,
                SHOW: "show" + ne,
                SHOWN: "shown" + ne,
                CLICK: "click" + ne,
                CLICK_DATA_API: "click" + ne + se,
                KEYDOWN_DATA_API: "keydown" + ne + se,
                KEYUP_DATA_API: "keyup" + ne + se
            },
            le = "disabled",
            he = "show",
            ce = "dropdown-menu-right",
            ue = '[data-toggle="dropdown"]',
            de = ".dropdown-menu",
            pe = {
                offset: 0,
                flip: !0,
                boundary: "scrollParent",
                reference: "toggle",
                display: "dynamic",
                popperConfig: null
            },
            fe = {
                offset: "(number|string|function)",
                flip: "boolean",
                boundary: "(string|element)",
                reference: "(string|element)",
                display: "string",
                popperConfig: "(null|object)"
            },
            ge = ((te = me.prototype).toggle = function () {
                if (!this._element.disabled && !f(this._element).hasClass(le)) {
                    var t = f(this._menu).hasClass(he);
                    me._clearMenus(), t || this.show(!0)
                }
            }, te.show = function (t) {
                if (void 0 === t && (t = !1), !(this._element.disabled || f(this._element).hasClass(le) || f(this._menu).hasClass(he))) {
                    var e = {
                        relatedTarget: this._element
                    },
                        i = f.Event(ae.SHOW, e),
                        n = me._getParentFromElement(this._element);
                    if (f(n).trigger(i), !i.isDefaultPrevented()) {
                        if (!this._inNavbar && t) {
                            if (void 0 === Jt) throw new TypeError("Bootstrap's dropdowns require Popper.js (https://popper.js.org/)");
                            var s = this._element;
                            "parent" === this._config.reference ? s = n : g.isElement(this._config.reference) && (s = this._config.reference, void 0 !== this._config.reference.jquery && (s = this._config.reference[0])), "scrollParent" !== this._config.boundary && f(n).addClass("position-static"), this._popper = new Jt(s, this._menu, this._getPopperConfig())
                        }
                        "ontouchstart" in document.documentElement && 0 === f(n).closest(".navbar-nav").length && f(document.body).children().on("mouseover", null, f.noop), this._element.focus(), this._element.setAttribute("aria-expanded", !0), f(this._menu).toggleClass(he), f(n).toggleClass(he).trigger(f.Event(ae.SHOWN, e))
                    }
                }
            }, te.hide = function () {
                if (!this._element.disabled && !f(this._element).hasClass(le) && f(this._menu).hasClass(he)) {
                    var t = {
                        relatedTarget: this._element
                    },
                        e = f.Event(ae.HIDE, t),
                        i = me._getParentFromElement(this._element);
                    f(i).trigger(e), e.isDefaultPrevented() || (this._popper && this._popper.destroy(), f(this._menu).toggleClass(he), f(i).toggleClass(he).trigger(f.Event(ae.HIDDEN, t)))
                }
            }, te.dispose = function () {
                f.removeData(this._element, ie), f(this._element).off(ne), this._element = null, (this._menu = null) !== this._popper && (this._popper.destroy(), this._popper = null)
            }, te.update = function () {
                this._inNavbar = this._detectNavbar(), null !== this._popper && this._popper.scheduleUpdate()
            }, te._addEventListeners = function () {
                var e = this;
                f(this._element).on(ae.CLICK, function (t) {
                    t.preventDefault(), t.stopPropagation(), e.toggle()
                })
            }, te._getConfig = function (t) {
                return t = r({}, this.constructor.Default, {}, f(this._element).data(), {}, t), g.typeCheckConfig(ee, t, this.constructor.DefaultType), t
            }, te._getMenuElement = function () {
                if (!this._menu) {
                    var t = me._getParentFromElement(this._element);
                    t && (this._menu = t.querySelector(de))
                }
                return this._menu
            }, te._getPlacement = function () {
                var t = f(this._element.parentNode),
                    e = "bottom-start";
                return t.hasClass("dropup") ? (e = "top-start", f(this._menu).hasClass(ce) && (e = "top-end")) : t.hasClass("dropright") ? e = "right-start" : t.hasClass("dropleft") ? e = "left-start" : f(this._menu).hasClass(ce) && (e = "bottom-end"), e
            }, te._detectNavbar = function () {
                return 0 < f(this._element).closest(".navbar").length
            }, te._getOffset = function () {
                var e = this,
                    t = {};
                return "function" == typeof this._config.offset ? t.fn = function (t) {
                    return t.offsets = r({}, t.offsets, {}, e._config.offset(t.offsets, e._element) || {}), t
                } : t.offset = this._config.offset, t
            }, te._getPopperConfig = function () {
                var t = {
                    placement: this._getPlacement(),
                    modifiers: {
                        offset: this._getOffset(),
                        flip: {
                            enabled: this._config.flip
                        },
                        preventOverflow: {
                            boundariesElement: this._config.boundary
                        }
                    }
                };
                return "static" === this._config.display && (t.modifiers.applyStyle = {
                    enabled: !1
                }), r({}, t, {}, this._config.popperConfig)
            }, me._jQueryInterface = function (e) {
                return this.each(function () {
                    var t = f(this).data(ie);
                    if (t || (t = new me(this, "object" == typeof e ? e : null), f(this).data(ie, t)), "string" == typeof e) {
                        if (void 0 === t[e]) throw new TypeError('No method named "' + e + '"');
                        t[e]()
                    }
                })
            }, me._clearMenus = function (t) {
                if (!t || 3 !== t.which && ("keyup" !== t.type || 9 === t.which))
                    for (var e = [].slice.call(document.querySelectorAll(ue)), i = 0, n = e.length; i < n; i++) {
                        var s = me._getParentFromElement(e[i]),
                            o = f(e[i]).data(ie),
                            r = {
                                relatedTarget: e[i]
                            };
                        if (t && "click" === t.type && (r.clickEvent = t), o) {
                            var a = o._menu;
                            if (f(s).hasClass(he) && !(t && ("click" === t.type && /input|textarea/i.test(t.target.tagName) || "keyup" === t.type && 9 === t.which) && f.contains(s, t.target))) {
                                var l = f.Event(ae.HIDE, r);
                                f(s).trigger(l), l.isDefaultPrevented() || ("ontouchstart" in document.documentElement && f(document.body).children().off("mouseover", null, f.noop), e[i].setAttribute("aria-expanded", "false"), o._popper && o._popper.destroy(), f(a).removeClass(he), f(s).removeClass(he).trigger(f.Event(ae.HIDDEN, r)))
                            }
                        }
                    }
            }, me._getParentFromElement = function (t) {
                var e, i = g.getSelectorFromElement(t);
                return i && (e = document.querySelector(i)), e || t.parentNode
            }, me._dataApiKeydownHandler = function (t) {
                if ((/input|textarea/i.test(t.target.tagName) ? !(32 === t.which || 27 !== t.which && (40 !== t.which && 38 !== t.which || f(t.target).closest(de).length)) : re.test(t.which)) && (t.preventDefault(), t.stopPropagation(), !this.disabled && !f(this).hasClass(le))) {
                    var e = me._getParentFromElement(this),
                        i = f(e).hasClass(he);
                    if (i || 27 !== t.which)
                        if (i && (!i || 27 !== t.which && 32 !== t.which)) {
                            var n = [].slice.call(e.querySelectorAll(".dropdown-menu .dropdown-item:not(.disabled):not(:disabled)")).filter(function (t) {
                                return f(t).is(":visible")
                            });
                            if (0 !== n.length) {
                                var s = n.indexOf(t.target);
                                38 === t.which && 0 < s && s-- , 40 === t.which && s < n.length - 1 && s++ , s < 0 && (s = 0), n[s].focus()
                            }
                        } else {
                            if (27 === t.which) {
                                var o = e.querySelector(ue);
                                f(o).trigger("focus")
                            }
                            f(this).trigger("click")
                        }
                }
            }, o(me, null, [{
                key: "VERSION",
                get: function () {
                    return "4.4.1"
                }
            }, {
                key: "Default",
                get: function () {
                    return pe
                }
            }, {
                key: "DefaultType",
                get: function () {
                    return fe
                }
            }]), me);

        function me(t, e) {
            this._element = t, this._popper = null, this._config = this._getConfig(e), this._menu = this._getMenuElement(), this._inNavbar = this._detectNavbar(), this._addEventListeners()
        }
        f(document).on(ae.KEYDOWN_DATA_API, ue, ge._dataApiKeydownHandler).on(ae.KEYDOWN_DATA_API, de, ge._dataApiKeydownHandler).on(ae.CLICK_DATA_API + " " + ae.KEYUP_DATA_API, ge._clearMenus).on(ae.CLICK_DATA_API, ue, function (t) {
            t.preventDefault(), t.stopPropagation(), ge._jQueryInterface.call(f(this), "toggle")
        }).on(ae.CLICK_DATA_API, ".dropdown form", function (t) {
            t.stopPropagation()
        }), f.fn[ee] = ge._jQueryInterface, f.fn[ee].Constructor = ge, f.fn[ee].noConflict = function () {
            return f.fn[ee] = oe, ge._jQueryInterface
        };
        var ve, _e = "modal",
            be = "bs.modal",
            ye = "." + be,
            we = f.fn[_e],
            Ce = {
                backdrop: !0,
                keyboard: !0,
                focus: !0,
                show: !0
            },
            xe = {
                backdrop: "(boolean|string)",
                keyboard: "boolean",
                focus: "boolean",
                show: "boolean"
            },
            ke = {
                HIDE: "hide" + ye,
                HIDE_PREVENTED: "hidePrevented" + ye,
                HIDDEN: "hidden" + ye,
                SHOW: "show" + ye,
                SHOWN: "shown" + ye,
                FOCUSIN: "focusin" + ye,
                RESIZE: "resize" + ye,
                CLICK_DISMISS: "click.dismiss" + ye,
                KEYDOWN_DISMISS: "keydown.dismiss" + ye,
                MOUSEUP_DISMISS: "mouseup.dismiss" + ye,
                MOUSEDOWN_DISMISS: "mousedown.dismiss" + ye,
                CLICK_DATA_API: "click" + ye + ".data-api"
            },
            De = "modal-open",
            Te = "fade",
            Se = "show",
            Ee = "modal-static",
            Ie = ".fixed-top, .fixed-bottom, .is-fixed, .sticky-top",
            Ae = ".sticky-top",
            Pe = ((ve = Ne.prototype).toggle = function (t) {
                return this._isShown ? this.hide() : this.show(t)
            }, ve.show = function (t) {
                var e = this;
                if (!this._isShown && !this._isTransitioning) {
                    f(this._element).hasClass(Te) && (this._isTransitioning = !0);
                    var i = f.Event(ke.SHOW, {
                        relatedTarget: t
                    });
                    f(this._element).trigger(i), this._isShown || i.isDefaultPrevented() || (this._isShown = !0, this._checkScrollbar(), this._setScrollbar(), this._adjustDialog(), this._setEscapeEvent(), this._setResizeEvent(), f(this._element).on(ke.CLICK_DISMISS, '[data-dismiss="modal"]', function (t) {
                        return e.hide(t)
                    }), f(this._dialog).on(ke.MOUSEDOWN_DISMISS, function () {
                        f(e._element).one(ke.MOUSEUP_DISMISS, function (t) {
                            f(t.target).is(e._element) && (e._ignoreBackdropClick = !0)
                        })
                    }), this._showBackdrop(function () {
                        return e._showElement(t)
                    }))
                }
            }, ve.hide = function (t) {
                var e = this;
                if (t && t.preventDefault(), this._isShown && !this._isTransitioning) {
                    var i = f.Event(ke.HIDE);
                    if (f(this._element).trigger(i), this._isShown && !i.isDefaultPrevented()) {
                        this._isShown = !1;
                        var n = f(this._element).hasClass(Te);
                        if (n && (this._isTransitioning = !0), this._setEscapeEvent(), this._setResizeEvent(), f(document).off(ke.FOCUSIN), f(this._element).removeClass(Se), f(this._element).off(ke.CLICK_DISMISS), f(this._dialog).off(ke.MOUSEDOWN_DISMISS), n) {
                            var s = g.getTransitionDurationFromElement(this._element);
                            f(this._element).one(g.TRANSITION_END, function (t) {
                                return e._hideModal(t)
                            }).emulateTransitionEnd(s)
                        } else this._hideModal()
                    }
                }
            }, ve.dispose = function () {
                [window, this._element, this._dialog].forEach(function (t) {
                    return f(t).off(ye)
                }), f(document).off(ke.FOCUSIN), f.removeData(this._element, be), this._config = null, this._element = null, this._dialog = null, this._backdrop = null, this._isShown = null, this._isBodyOverflowing = null, this._ignoreBackdropClick = null, this._isTransitioning = null, this._scrollbarWidth = null
            }, ve.handleUpdate = function () {
                this._adjustDialog()
            }, ve._getConfig = function (t) {
                return t = r({}, Ce, {}, t), g.typeCheckConfig(_e, t, xe), t
            }, ve._triggerBackdropTransition = function () {
                var t = this;
                if ("static" === this._config.backdrop) {
                    var e = f.Event(ke.HIDE_PREVENTED);
                    if (f(this._element).trigger(e), e.defaultPrevented) return;
                    this._element.classList.add(Ee);
                    var i = g.getTransitionDurationFromElement(this._element);
                    f(this._element).one(g.TRANSITION_END, function () {
                        t._element.classList.remove(Ee)
                    }).emulateTransitionEnd(i), this._element.focus()
                } else this.hide()
            }, ve._showElement = function (t) {
                var e = this,
                    i = f(this._element).hasClass(Te),
                    n = this._dialog ? this._dialog.querySelector(".modal-body") : null;

                function s() {
                    e._config.focus && e._element.focus(), e._isTransitioning = !1, f(e._element).trigger(o)
                }
                this._element.parentNode && this._element.parentNode.nodeType === Node.ELEMENT_NODE || document.body.appendChild(this._element), this._element.style.display = "block", this._element.removeAttribute("aria-hidden"), this._element.setAttribute("aria-modal", !0), f(this._dialog).hasClass("modal-dialog-scrollable") && n ? n.scrollTop = 0 : this._element.scrollTop = 0, i && g.reflow(this._element), f(this._element).addClass(Se), this._config.focus && this._enforceFocus();
                var o = f.Event(ke.SHOWN, {
                    relatedTarget: t
                });
                if (i) {
                    var r = g.getTransitionDurationFromElement(this._dialog);
                    f(this._dialog).one(g.TRANSITION_END, s).emulateTransitionEnd(r)
                } else s()
            }, ve._enforceFocus = function () {
                var e = this;
                f(document).off(ke.FOCUSIN).on(ke.FOCUSIN, function (t) {
                    document !== t.target && e._element !== t.target && 0 === f(e._element).has(t.target).length && e._element.focus()
                })
            }, ve._setEscapeEvent = function () {
                var e = this;
                this._isShown && this._config.keyboard ? f(this._element).on(ke.KEYDOWN_DISMISS, function (t) {
                    27 === t.which && e._triggerBackdropTransition()
                }) : this._isShown || f(this._element).off(ke.KEYDOWN_DISMISS)
            }, ve._setResizeEvent = function () {
                var e = this;
                this._isShown ? f(window).on(ke.RESIZE, function (t) {
                    return e.handleUpdate(t)
                }) : f(window).off(ke.RESIZE)
            }, ve._hideModal = function () {
                var t = this;
                this._element.style.display = "none", this._element.setAttribute("aria-hidden", !0), this._element.removeAttribute("aria-modal"), this._isTransitioning = !1, this._showBackdrop(function () {
                    f(document.body).removeClass(De), t._resetAdjustments(), t._resetScrollbar(), f(t._element).trigger(ke.HIDDEN)
                })
            }, ve._removeBackdrop = function () {
                this._backdrop && (f(this._backdrop).remove(), this._backdrop = null)
            }, ve._showBackdrop = function (t) {
                var e = this,
                    i = f(this._element).hasClass(Te) ? Te : "";
                if (this._isShown && this._config.backdrop) {
                    if (this._backdrop = document.createElement("div"), this._backdrop.className = "modal-backdrop", i && this._backdrop.classList.add(i), f(this._backdrop).appendTo(document.body), f(this._element).on(ke.CLICK_DISMISS, function (t) {
                        e._ignoreBackdropClick ? e._ignoreBackdropClick = !1 : t.target === t.currentTarget && e._triggerBackdropTransition()
                    }), i && g.reflow(this._backdrop), f(this._backdrop).addClass(Se), !t) return;
                    if (!i) return void t();
                    var n = g.getTransitionDurationFromElement(this._backdrop);
                    f(this._backdrop).one(g.TRANSITION_END, t).emulateTransitionEnd(n)
                } else if (!this._isShown && this._backdrop) {
                    f(this._backdrop).removeClass(Se);
                    var s = function () {
                        e._removeBackdrop(), t && t()
                    };
                    if (f(this._element).hasClass(Te)) {
                        var o = g.getTransitionDurationFromElement(this._backdrop);
                        f(this._backdrop).one(g.TRANSITION_END, s).emulateTransitionEnd(o)
                    } else s()
                } else t && t()
            }, ve._adjustDialog = function () {
                var t = this._element.scrollHeight > document.documentElement.clientHeight;
                !this._isBodyOverflowing && t && (this._element.style.paddingLeft = this._scrollbarWidth + "px"), this._isBodyOverflowing && !t && (this._element.style.paddingRight = this._scrollbarWidth + "px")
            }, ve._resetAdjustments = function () {
                this._element.style.paddingLeft = "", this._element.style.paddingRight = ""
            }, ve._checkScrollbar = function () {
                var t = document.body.getBoundingClientRect();
                this._isBodyOverflowing = t.left + t.right < window.innerWidth, this._scrollbarWidth = this._getScrollbarWidth()
            }, ve._setScrollbar = function () {
                var s = this;
                if (this._isBodyOverflowing) {
                    var t = [].slice.call(document.querySelectorAll(Ie)),
                        e = [].slice.call(document.querySelectorAll(Ae));
                    f(t).each(function (t, e) {
                        var i = e.style.paddingRight,
                            n = f(e).css("padding-right");
                        f(e).data("padding-right", i).css("padding-right", parseFloat(n) + s._scrollbarWidth + "px")
                    }), f(e).each(function (t, e) {
                        var i = e.style.marginRight,
                            n = f(e).css("margin-right");
                        f(e).data("margin-right", i).css("margin-right", parseFloat(n) - s._scrollbarWidth + "px")
                    });
                    var i = document.body.style.paddingRight,
                        n = f(document.body).css("padding-right");
                    f(document.body).data("padding-right", i).css("padding-right", parseFloat(n) + this._scrollbarWidth + "px")
                }
                f(document.body).addClass(De)
            }, ve._resetScrollbar = function () {
                var t = [].slice.call(document.querySelectorAll(Ie));
                f(t).each(function (t, e) {
                    var i = f(e).data("padding-right");
                    f(e).removeData("padding-right"), e.style.paddingRight = i || ""
                });
                var e = [].slice.call(document.querySelectorAll(Ae));
                f(e).each(function (t, e) {
                    var i = f(e).data("margin-right");
                    void 0 !== i && f(e).css("margin-right", i).removeData("margin-right")
                });
                var i = f(document.body).data("padding-right");
                f(document.body).removeData("padding-right"), document.body.style.paddingRight = i || ""
            }, ve._getScrollbarWidth = function () {
                var t = document.createElement("div");
                t.className = "modal-scrollbar-measure", document.body.appendChild(t);
                var e = t.getBoundingClientRect().width - t.clientWidth;
                return document.body.removeChild(t), e
            }, Ne._jQueryInterface = function (i, n) {
                return this.each(function () {
                    var t = f(this).data(be),
                        e = r({}, Ce, {}, f(this).data(), {}, "object" == typeof i && i ? i : {});
                    if (t || (t = new Ne(this, e), f(this).data(be, t)), "string" == typeof i) {
                        if (void 0 === t[i]) throw new TypeError('No method named "' + i + '"');
                        t[i](n)
                    } else e.show && t.show(n)
                })
            }, o(Ne, null, [{
                key: "VERSION",
                get: function () {
                    return "4.4.1"
                }
            }, {
                key: "Default",
                get: function () {
                    return Ce
                }
            }]), Ne);

        function Ne(t, e) {
            this._config = this._getConfig(e), this._element = t, this._dialog = t.querySelector(".modal-dialog"), this._backdrop = null, this._isShown = !1, this._isBodyOverflowing = !1, this._ignoreBackdropClick = !1, this._isTransitioning = !1, this._scrollbarWidth = 0
        }
        f(document).on(ke.CLICK_DATA_API, '[data-toggle="modal"]', function (t) {
            var e, i = this,
                n = g.getSelectorFromElement(this);
            n && (e = document.querySelector(n));
            var s = f(e).data(be) ? "toggle" : r({}, f(e).data(), {}, f(this).data());
            "A" !== this.tagName && "AREA" !== this.tagName || t.preventDefault();
            var o = f(e).one(ke.SHOW, function (t) {
                t.isDefaultPrevented() || o.one(ke.HIDDEN, function () {
                    f(i).is(":visible") && i.focus()
                })
            });
            Pe._jQueryInterface.call(f(e), s, this)
        }), f.fn[_e] = Pe._jQueryInterface, f.fn[_e].Constructor = Pe, f.fn[_e].noConflict = function () {
            return f.fn[_e] = we, Pe._jQueryInterface
        };
        var Oe = ["background", "cite", "href", "itemtype", "longdesc", "poster", "src", "xlink:href"],
            Me = /^(?:(?:https?|mailto|ftp|tel|file):|[^&:/?#]*(?:[/?#]|$))/gi,
            $e = /^data:(?:image\/(?:bmp|gif|jpeg|jpg|png|tiff|webp)|video\/(?:mpeg|mp4|ogg|webm)|audio\/(?:mp3|oga|ogg|opus));base64,[a-z0-9+/]+=*$/i;

        function He(t, o, e) {
            if (0 === t.length) return t;
            if (e && "function" == typeof e) return e(t);
            for (var i = (new window.DOMParser).parseFromString(t, "text/html"), r = Object.keys(o), a = [].slice.call(i.body.querySelectorAll("*")), n = function (t) {
                var e = a[t],
                    i = e.nodeName.toLowerCase();
                if (-1 === r.indexOf(e.nodeName.toLowerCase())) return e.parentNode.removeChild(e), "continue";
                var n = [].slice.call(e.attributes),
                    s = [].concat(o["*"] || [], o[i] || []);
                n.forEach(function (t) {
                    ! function (t, e) {
                        var i = t.nodeName.toLowerCase();
                        if (-1 !== e.indexOf(i)) return -1 === Oe.indexOf(i) || Boolean(t.nodeValue.match(Me) || t.nodeValue.match($e));
                        for (var n = e.filter(function (t) {
                            return t instanceof RegExp
                        }), s = 0, o = n.length; s < o; s++)
                            if (i.match(n[s])) return 1
                    }(t, s) && e.removeAttribute(t.nodeName)
                })
            }, s = 0, l = a.length; s < l; s++) n(s);
            return i.body.innerHTML
        }
        var Le, Re = "tooltip",
            We = "bs.tooltip",
            Fe = "." + We,
            je = f.fn[Re],
            ze = "bs-tooltip",
            qe = new RegExp("(^|\\s)" + ze + "\\S+", "g"),
            Be = ["sanitize", "whiteList", "sanitizeFn"],
            Ue = {
                animation: "boolean",
                template: "string",
                title: "(string|element|function)",
                trigger: "string",
                delay: "(number|object)",
                html: "boolean",
                selector: "(string|boolean)",
                placement: "(string|function)",
                offset: "(number|string|function)",
                container: "(string|element|boolean)",
                fallbackPlacement: "(string|array)",
                boundary: "(string|element)",
                sanitize: "boolean",
                sanitizeFn: "(null|function)",
                whiteList: "object",
                popperConfig: "(null|object)"
            },
            Ye = {
                AUTO: "auto",
                TOP: "top",
                RIGHT: "right",
                BOTTOM: "bottom",
                LEFT: "left"
            },
            Ke = {
                animation: !0,
                template: '<div class="tooltip" role="tooltip"><div class="arrow"></div><div class="tooltip-inner"></div></div>',
                trigger: "hover focus",
                title: "",
                delay: 0,
                html: !1,
                selector: !1,
                placement: "top",
                offset: 0,
                container: !1,
                fallbackPlacement: "flip",
                boundary: "scrollParent",
                sanitize: !0,
                sanitizeFn: null,
                whiteList: {
                    "*": ["class", "dir", "id", "lang", "role", /^aria-[\w-]*$/i],
                    a: ["target", "href", "title", "rel"],
                    area: [],
                    b: [],
                    br: [],
                    col: [],
                    code: [],
                    div: [],
                    em: [],
                    hr: [],
                    h1: [],
                    h2: [],
                    h3: [],
                    h4: [],
                    h5: [],
                    h6: [],
                    i: [],
                    img: ["src", "alt", "title", "width", "height"],
                    li: [],
                    ol: [],
                    p: [],
                    pre: [],
                    s: [],
                    small: [],
                    span: [],
                    sub: [],
                    sup: [],
                    strong: [],
                    u: [],
                    ul: []
                },
                popperConfig: null
            },
            Ve = "show",
            Xe = {
                HIDE: "hide" + Fe,
                HIDDEN: "hidden" + Fe,
                SHOW: "show" + Fe,
                SHOWN: "shown" + Fe,
                INSERTED: "inserted" + Fe,
                CLICK: "click" + Fe,
                FOCUSIN: "focusin" + Fe,
                FOCUSOUT: "focusout" + Fe,
                MOUSEENTER: "mouseenter" + Fe,
                MOUSELEAVE: "mouseleave" + Fe
            },
            Qe = "fade",
            Ge = "show",
            Je = "hover",
            Ze = ((Le = ti.prototype).enable = function () {
                this._isEnabled = !0
            }, Le.disable = function () {
                this._isEnabled = !1
            }, Le.toggleEnabled = function () {
                this._isEnabled = !this._isEnabled
            }, Le.toggle = function (t) {
                if (this._isEnabled)
                    if (t) {
                        var e = this.constructor.DATA_KEY,
                            i = f(t.currentTarget).data(e);
                        i || (i = new this.constructor(t.currentTarget, this._getDelegateConfig()), f(t.currentTarget).data(e, i)), i._activeTrigger.click = !i._activeTrigger.click, i._isWithActiveTrigger() ? i._enter(null, i) : i._leave(null, i)
                    } else {
                        if (f(this.getTipElement()).hasClass(Ge)) return void this._leave(null, this);
                        this._enter(null, this)
                    }
            }, Le.dispose = function () {
                clearTimeout(this._timeout), f.removeData(this.element, this.constructor.DATA_KEY), f(this.element).off(this.constructor.EVENT_KEY), f(this.element).closest(".modal").off("hide.bs.modal", this._hideModalHandler), this.tip && f(this.tip).remove(), this._isEnabled = null, this._timeout = null, this._hoverState = null, this._activeTrigger = null, this._popper && this._popper.destroy(), this._popper = null, this.element = null, this.config = null, this.tip = null
            }, Le.show = function () {
                var e = this;
                if ("none" === f(this.element).css("display")) throw new Error("Please use show on visible elements");
                var t = f.Event(this.constructor.Event.SHOW);
                if (this.isWithContent() && this._isEnabled) {
                    f(this.element).trigger(t);
                    var i = g.findShadowRoot(this.element),
                        n = f.contains(null !== i ? i : this.element.ownerDocument.documentElement, this.element);
                    if (t.isDefaultPrevented() || !n) return;
                    var s = this.getTipElement(),
                        o = g.getUID(this.constructor.NAME);
                    s.setAttribute("id", o), this.element.setAttribute("aria-describedby", o), this.setContent(), this.config.animation && f(s).addClass(Qe);
                    var r = "function" == typeof this.config.placement ? this.config.placement.call(this, s, this.element) : this.config.placement,
                        a = this._getAttachment(r);
                    this.addAttachmentClass(a);
                    var l = this._getContainer();
                    f(s).data(this.constructor.DATA_KEY, this), f.contains(this.element.ownerDocument.documentElement, this.tip) || f(s).appendTo(l), f(this.element).trigger(this.constructor.Event.INSERTED), this._popper = new Jt(this.element, s, this._getPopperConfig(a)), f(s).addClass(Ge), "ontouchstart" in document.documentElement && f(document.body).children().on("mouseover", null, f.noop);
                    var h = function () {
                        e.config.animation && e._fixTransition();
                        var t = e._hoverState;
                        e._hoverState = null, f(e.element).trigger(e.constructor.Event.SHOWN), "out" === t && e._leave(null, e)
                    };
                    if (f(this.tip).hasClass(Qe)) {
                        var c = g.getTransitionDurationFromElement(this.tip);
                        f(this.tip).one(g.TRANSITION_END, h).emulateTransitionEnd(c)
                    } else h()
                }
            }, Le.hide = function (t) {
                function e() {
                    i._hoverState !== Ve && n.parentNode && n.parentNode.removeChild(n), i._cleanTipClass(), i.element.removeAttribute("aria-describedby"), f(i.element).trigger(i.constructor.Event.HIDDEN), null !== i._popper && i._popper.destroy(), t && t()
                }
                var i = this,
                    n = this.getTipElement(),
                    s = f.Event(this.constructor.Event.HIDE);
                if (f(this.element).trigger(s), !s.isDefaultPrevented()) {
                    if (f(n).removeClass(Ge), "ontouchstart" in document.documentElement && f(document.body).children().off("mouseover", null, f.noop), this._activeTrigger.click = !1, this._activeTrigger.focus = !1, this._activeTrigger[Je] = !1, f(this.tip).hasClass(Qe)) {
                        var o = g.getTransitionDurationFromElement(n);
                        f(n).one(g.TRANSITION_END, e).emulateTransitionEnd(o)
                    } else e();
                    this._hoverState = ""
                }
            }, Le.update = function () {
                null !== this._popper && this._popper.scheduleUpdate()
            }, Le.isWithContent = function () {
                return Boolean(this.getTitle())
            }, Le.addAttachmentClass = function (t) {
                f(this.getTipElement()).addClass(ze + "-" + t)
            }, Le.getTipElement = function () {
                return this.tip = this.tip || f(this.config.template)[0], this.tip
            }, Le.setContent = function () {
                var t = this.getTipElement();
                this.setElementContent(f(t.querySelectorAll(".tooltip-inner")), this.getTitle()), f(t).removeClass("fade show")
            }, Le.setElementContent = function (t, e) {
                "object" != typeof e || !e.nodeType && !e.jquery ? this.config.html ? (this.config.sanitize && (e = He(e, this.config.whiteList, this.config.sanitizeFn)), t.html(e)) : t.text(e) : this.config.html ? f(e).parent().is(t) || t.empty().append(e) : t.text(f(e).text())
            }, Le.getTitle = function () {
                var t = this.element.getAttribute("data-original-title");
                return t || ("function" == typeof this.config.title ? this.config.title.call(this.element) : this.config.title)
            }, Le._getPopperConfig = function (t) {
                var e = this;
                return r({}, {
                    placement: t,
                    modifiers: {
                        offset: this._getOffset(),
                        flip: {
                            behavior: this.config.fallbackPlacement
                        },
                        arrow: {
                            element: ".arrow"
                        },
                        preventOverflow: {
                            boundariesElement: this.config.boundary
                        }
                    },
                    onCreate: function (t) {
                        t.originalPlacement !== t.placement && e._handlePopperPlacementChange(t)
                    },
                    onUpdate: function (t) {
                        return e._handlePopperPlacementChange(t)
                    }
                }, {}, this.config.popperConfig)
            }, Le._getOffset = function () {
                var e = this,
                    t = {};
                return "function" == typeof this.config.offset ? t.fn = function (t) {
                    return t.offsets = r({}, t.offsets, {}, e.config.offset(t.offsets, e.element) || {}), t
                } : t.offset = this.config.offset, t
            }, Le._getContainer = function () {
                return !1 === this.config.container ? document.body : g.isElement(this.config.container) ? f(this.config.container) : f(document).find(this.config.container)
            }, Le._getAttachment = function (t) {
                return Ye[t.toUpperCase()]
            }, Le._setListeners = function () {
                var n = this;
                this.config.trigger.split(" ").forEach(function (t) {
                    if ("click" === t) f(n.element).on(n.constructor.Event.CLICK, n.config.selector, function (t) {
                        return n.toggle(t)
                    });
                    else if ("manual" !== t) {
                        var e = t === Je ? n.constructor.Event.MOUSEENTER : n.constructor.Event.FOCUSIN,
                            i = t === Je ? n.constructor.Event.MOUSELEAVE : n.constructor.Event.FOCUSOUT;
                        f(n.element).on(e, n.config.selector, function (t) {
                            return n._enter(t)
                        }).on(i, n.config.selector, function (t) {
                            return n._leave(t)
                        })
                    }
                }), this._hideModalHandler = function () {
                    n.element && n.hide()
                }, f(this.element).closest(".modal").on("hide.bs.modal", this._hideModalHandler), this.config.selector ? this.config = r({}, this.config, {
                    trigger: "manual",
                    selector: ""
                }) : this._fixTitle()
            }, Le._fixTitle = function () {
                var t = typeof this.element.getAttribute("data-original-title");
                !this.element.getAttribute("title") && "string" == t || (this.element.setAttribute("data-original-title", this.element.getAttribute("title") || ""), this.element.setAttribute("title", ""))
            }, Le._enter = function (t, e) {
                var i = this.constructor.DATA_KEY;
                (e = e || f(t.currentTarget).data(i)) || (e = new this.constructor(t.currentTarget, this._getDelegateConfig()), f(t.currentTarget).data(i, e)), t && (e._activeTrigger["focusin" === t.type ? "focus" : Je] = !0), f(e.getTipElement()).hasClass(Ge) || e._hoverState === Ve ? e._hoverState = Ve : (clearTimeout(e._timeout), e._hoverState = Ve, e.config.delay && e.config.delay.show ? e._timeout = setTimeout(function () {
                    e._hoverState === Ve && e.show()
                }, e.config.delay.show) : e.show())
            }, Le._leave = function (t, e) {
                var i = this.constructor.DATA_KEY;
                (e = e || f(t.currentTarget).data(i)) || (e = new this.constructor(t.currentTarget, this._getDelegateConfig()), f(t.currentTarget).data(i, e)), t && (e._activeTrigger["focusout" === t.type ? "focus" : Je] = !1), e._isWithActiveTrigger() || (clearTimeout(e._timeout), e._hoverState = "out", e.config.delay && e.config.delay.hide ? e._timeout = setTimeout(function () {
                    "out" === e._hoverState && e.hide()
                }, e.config.delay.hide) : e.hide())
            }, Le._isWithActiveTrigger = function () {
                for (var t in this._activeTrigger)
                    if (this._activeTrigger[t]) return !0;
                return !1
            }, Le._getConfig = function (t) {
                var e = f(this.element).data();
                return Object.keys(e).forEach(function (t) {
                    -1 !== Be.indexOf(t) && delete e[t]
                }), "number" == typeof (t = r({}, this.constructor.Default, {}, e, {}, "object" == typeof t && t ? t : {})).delay && (t.delay = {
                    show: t.delay,
                    hide: t.delay
                }), "number" == typeof t.title && (t.title = t.title.toString()), "number" == typeof t.content && (t.content = t.content.toString()), g.typeCheckConfig(Re, t, this.constructor.DefaultType), t.sanitize && (t.template = He(t.template, t.whiteList, t.sanitizeFn)), t
            }, Le._getDelegateConfig = function () {
                var t = {};
                if (this.config)
                    for (var e in this.config) this.constructor.Default[e] !== this.config[e] && (t[e] = this.config[e]);
                return t
            }, Le._cleanTipClass = function () {
                var t = f(this.getTipElement()),
                    e = t.attr("class").match(qe);
                null !== e && e.length && t.removeClass(e.join(""))
            }, Le._handlePopperPlacementChange = function (t) {
                var e = t.instance;
                this.tip = e.popper, this._cleanTipClass(), this.addAttachmentClass(this._getAttachment(t.placement))
            }, Le._fixTransition = function () {
                var t = this.getTipElement(),
                    e = this.config.animation;
                null === t.getAttribute("x-placement") && (f(t).removeClass(Qe), this.config.animation = !1, this.hide(), this.show(), this.config.animation = e)
            }, ti._jQueryInterface = function (i) {
                return this.each(function () {
                    var t = f(this).data(We),
                        e = "object" == typeof i && i;
                    if ((t || !/dispose|hide/.test(i)) && (t || (t = new ti(this, e), f(this).data(We, t)), "string" == typeof i)) {
                        if (void 0 === t[i]) throw new TypeError('No method named "' + i + '"');
                        t[i]()
                    }
                })
            }, o(ti, null, [{
                key: "VERSION",
                get: function () {
                    return "4.4.1"
                }
            }, {
                key: "Default",
                get: function () {
                    return Ke
                }
            }, {
                key: "NAME",
                get: function () {
                    return Re
                }
            }, {
                key: "DATA_KEY",
                get: function () {
                    return We
                }
            }, {
                key: "Event",
                get: function () {
                    return Xe
                }
            }, {
                key: "EVENT_KEY",
                get: function () {
                    return Fe
                }
            }, {
                key: "DefaultType",
                get: function () {
                    return Ue
                }
            }]), ti);

        function ti(t, e) {
            if (void 0 === Jt) throw new TypeError("Bootstrap's tooltips require Popper.js (https://popper.js.org/)");
            this._isEnabled = !0, this._timeout = 0, this._hoverState = "", this._activeTrigger = {}, this._popper = null, this.element = t, this.config = this._getConfig(e), this.tip = null, this._setListeners()
        }
        f.fn[Re] = Ze._jQueryInterface, f.fn[Re].Constructor = Ze, f.fn[Re].noConflict = function () {
            return f.fn[Re] = je, Ze._jQueryInterface
        };
        var ei = "popover",
            ii = "bs.popover",
            ni = "." + ii,
            si = f.fn[ei],
            oi = "bs-popover",
            ri = new RegExp("(^|\\s)" + oi + "\\S+", "g"),
            ai = r({}, Ze.Default, {
                placement: "right",
                trigger: "click",
                content: "",
                template: '<div class="popover" role="tooltip"><div class="arrow"></div><h3 class="popover-header"></h3><div class="popover-body"></div></div>'
            }),
            li = r({}, Ze.DefaultType, {
                content: "(string|element|function)"
            }),
            hi = {
                HIDE: "hide" + ni,
                HIDDEN: "hidden" + ni,
                SHOW: "show" + ni,
                SHOWN: "shown" + ni,
                INSERTED: "inserted" + ni,
                CLICK: "click" + ni,
                FOCUSIN: "focusin" + ni,
                FOCUSOUT: "focusout" + ni,
                MOUSEENTER: "mouseenter" + ni,
                MOUSELEAVE: "mouseleave" + ni
            },
            ci = function (t) {
                function n() {
                    return t.apply(this, arguments) || this
                }
                var e, i;
                i = t, (e = n).prototype = Object.create(i.prototype), (e.prototype.constructor = e).__proto__ = i;
                var s = n.prototype;
                return s.isWithContent = function () {
                    return this.getTitle() || this._getContent()
                }, s.addAttachmentClass = function (t) {
                    f(this.getTipElement()).addClass(oi + "-" + t)
                }, s.getTipElement = function () {
                    return this.tip = this.tip || f(this.config.template)[0], this.tip
                }, s.setContent = function () {
                    var t = f(this.getTipElement());
                    this.setElementContent(t.find(".popover-header"), this.getTitle());
                    var e = this._getContent();
                    "function" == typeof e && (e = e.call(this.element)), this.setElementContent(t.find(".popover-body"), e), t.removeClass("fade show")
                }, s._getContent = function () {
                    return this.element.getAttribute("data-content") || this.config.content
                }, s._cleanTipClass = function () {
                    var t = f(this.getTipElement()),
                        e = t.attr("class").match(ri);
                    null !== e && 0 < e.length && t.removeClass(e.join(""))
                }, n._jQueryInterface = function (i) {
                    return this.each(function () {
                        var t = f(this).data(ii),
                            e = "object" == typeof i ? i : null;
                        if ((t || !/dispose|hide/.test(i)) && (t || (t = new n(this, e), f(this).data(ii, t)), "string" == typeof i)) {
                            if (void 0 === t[i]) throw new TypeError('No method named "' + i + '"');
                            t[i]()
                        }
                    })
                }, o(n, null, [{
                    key: "VERSION",
                    get: function () {
                        return "4.4.1"
                    }
                }, {
                    key: "Default",
                    get: function () {
                        return ai
                    }
                }, {
                    key: "NAME",
                    get: function () {
                        return ei
                    }
                }, {
                    key: "DATA_KEY",
                    get: function () {
                        return ii
                    }
                }, {
                    key: "Event",
                    get: function () {
                        return hi
                    }
                }, {
                    key: "EVENT_KEY",
                    get: function () {
                        return ni
                    }
                }, {
                    key: "DefaultType",
                    get: function () {
                        return li
                    }
                }]), n
            }(Ze);
        f.fn[ei] = ci._jQueryInterface, f.fn[ei].Constructor = ci, f.fn[ei].noConflict = function () {
            return f.fn[ei] = si, ci._jQueryInterface
        };
        var ui, di = "scrollspy",
            pi = "bs.scrollspy",
            fi = "." + pi,
            gi = f.fn[di],
            mi = {
                offset: 10,
                method: "auto",
                target: ""
            },
            vi = {
                offset: "number",
                method: "string",
                target: "(string|element)"
            },
            _i = {
                ACTIVATE: "activate" + fi,
                SCROLL: "scroll" + fi,
                LOAD_DATA_API: "load" + fi + ".data-api"
            },
            bi = "active",
            yi = ".nav, .list-group",
            wi = ".nav-link",
            Ci = ".list-group-item",
            xi = ((ui = ki.prototype).refresh = function () {
                var e = this,
                    t = this._scrollElement === this._scrollElement.window ? "offset" : "position",
                    s = "auto" === this._config.method ? t : this._config.method,
                    o = "position" === s ? this._getScrollTop() : 0;
                this._offsets = [], this._targets = [], this._scrollHeight = this._getScrollHeight(), [].slice.call(document.querySelectorAll(this._selector)).map(function (t) {
                    var e, i = g.getSelectorFromElement(t);
                    if (i && (e = document.querySelector(i)), e) {
                        var n = e.getBoundingClientRect();
                        if (n.width || n.height) return [f(e)[s]().top + o, i]
                    }
                    return null
                }).filter(function (t) {
                    return t
                }).sort(function (t, e) {
                    return t[0] - e[0]
                }).forEach(function (t) {
                    e._offsets.push(t[0]), e._targets.push(t[1])
                })
            }, ui.dispose = function () {
                f.removeData(this._element, pi), f(this._scrollElement).off(fi), this._element = null, this._scrollElement = null, this._config = null, this._selector = null, this._offsets = null, this._targets = null, this._activeTarget = null, this._scrollHeight = null
            }, ui._getConfig = function (t) {
                if ("string" != typeof (t = r({}, mi, {}, "object" == typeof t && t ? t : {})).target) {
                    var e = f(t.target).attr("id");
                    e || (e = g.getUID(di), f(t.target).attr("id", e)), t.target = "#" + e
                }
                return g.typeCheckConfig(di, t, vi), t
            }, ui._getScrollTop = function () {
                return this._scrollElement === window ? this._scrollElement.pageYOffset : this._scrollElement.scrollTop
            }, ui._getScrollHeight = function () {
                return this._scrollElement.scrollHeight || Math.max(document.body.scrollHeight, document.documentElement.scrollHeight)
            }, ui._getOffsetHeight = function () {
                return this._scrollElement === window ? window.innerHeight : this._scrollElement.getBoundingClientRect().height
            }, ui._process = function () {
                var t = this._getScrollTop() + this._config.offset,
                    e = this._getScrollHeight(),
                    i = this._config.offset + e - this._getOffsetHeight();
                if (this._scrollHeight !== e && this.refresh(), i <= t) {
                    var n = this._targets[this._targets.length - 1];
                    this._activeTarget !== n && this._activate(n)
                } else {
                    if (this._activeTarget && t < this._offsets[0] && 0 < this._offsets[0]) return this._activeTarget = null, void this._clear();
                    for (var s = this._offsets.length; s--;) this._activeTarget !== this._targets[s] && t >= this._offsets[s] && (void 0 === this._offsets[s + 1] || t < this._offsets[s + 1]) && this._activate(this._targets[s])
                }
            }, ui._activate = function (e) {
                this._activeTarget = e, this._clear();
                var t = this._selector.split(",").map(function (t) {
                    return t + '[data-target="' + e + '"],' + t + '[href="' + e + '"]'
                }),
                    i = f([].slice.call(document.querySelectorAll(t.join(","))));
                i.hasClass("dropdown-item") ? (i.closest(".dropdown").find(".dropdown-toggle").addClass(bi), i.addClass(bi)) : (i.addClass(bi), i.parents(yi).prev(wi + ", " + Ci).addClass(bi), i.parents(yi).prev(".nav-item").children(wi).addClass(bi)), f(this._scrollElement).trigger(_i.ACTIVATE, {
                    relatedTarget: e
                })
            }, ui._clear = function () {
                [].slice.call(document.querySelectorAll(this._selector)).filter(function (t) {
                    return t.classList.contains(bi)
                }).forEach(function (t) {
                    return t.classList.remove(bi)
                })
            }, ki._jQueryInterface = function (e) {
                return this.each(function () {
                    var t = f(this).data(pi);
                    if (t || (t = new ki(this, "object" == typeof e && e), f(this).data(pi, t)), "string" == typeof e) {
                        if (void 0 === t[e]) throw new TypeError('No method named "' + e + '"');
                        t[e]()
                    }
                })
            }, o(ki, null, [{
                key: "VERSION",
                get: function () {
                    return "4.4.1"
                }
            }, {
                key: "Default",
                get: function () {
                    return mi
                }
            }]), ki);

        function ki(t, e) {
            var i = this;
            this._element = t, this._scrollElement = "BODY" === t.tagName ? window : t, this._config = this._getConfig(e), this._selector = this._config.target + " " + wi + "," + this._config.target + " " + Ci + "," + this._config.target + " .dropdown-item", this._offsets = [], this._targets = [], this._activeTarget = null, this._scrollHeight = 0, f(this._scrollElement).on(_i.SCROLL, function (t) {
                return i._process(t)
            }), this.refresh(), this._process()
        }
        f(window).on(_i.LOAD_DATA_API, function () {
            for (var t = [].slice.call(document.querySelectorAll('[data-spy="scroll"]')), e = t.length; e--;) {
                var i = f(t[e]);
                xi._jQueryInterface.call(i, i.data())
            }
        }), f.fn[di] = xi._jQueryInterface, f.fn[di].Constructor = xi, f.fn[di].noConflict = function () {
            return f.fn[di] = gi, xi._jQueryInterface
        };
        var Di, Ti = "bs.tab",
            Si = "." + Ti,
            Ei = f.fn.tab,
            Ii = {
                HIDE: "hide" + Si,
                HIDDEN: "hidden" + Si,
                SHOW: "show" + Si,
                SHOWN: "shown" + Si,
                CLICK_DATA_API: "click.bs.tab.data-api"
            },
            Ai = "active",
            Pi = "> li > .active",
            Ni = ((Di = Oi.prototype).show = function () {
                var i = this;
                if (!(this._element.parentNode && this._element.parentNode.nodeType === Node.ELEMENT_NODE && f(this._element).hasClass(Ai) || f(this._element).hasClass("disabled"))) {
                    var t, n, e = f(this._element).closest(".nav, .list-group")[0],
                        s = g.getSelectorFromElement(this._element);
                    if (e) {
                        var o = "UL" === e.nodeName || "OL" === e.nodeName ? Pi : ".active";
                        n = (n = f.makeArray(f(e).find(o)))[n.length - 1]
                    }
                    var r = f.Event(Ii.HIDE, {
                        relatedTarget: this._element
                    }),
                        a = f.Event(Ii.SHOW, {
                            relatedTarget: n
                        });
                    if (n && f(n).trigger(r), f(this._element).trigger(a), !a.isDefaultPrevented() && !r.isDefaultPrevented()) {
                        s && (t = document.querySelector(s)), this._activate(this._element, e);
                        var l = function () {
                            var t = f.Event(Ii.HIDDEN, {
                                relatedTarget: i._element
                            }),
                                e = f.Event(Ii.SHOWN, {
                                    relatedTarget: n
                                });
                            f(n).trigger(t), f(i._element).trigger(e)
                        };
                        t ? this._activate(t, t.parentNode, l) : l()
                    }
                }
            }, Di.dispose = function () {
                f.removeData(this._element, Ti), this._element = null
            }, Di._activate = function (t, e, i) {
                function n() {
                    return s._transitionComplete(t, o, i)
                }
                var s = this,
                    o = (!e || "UL" !== e.nodeName && "OL" !== e.nodeName ? f(e).children(".active") : f(e).find(Pi))[0],
                    r = i && o && f(o).hasClass("fade");
                if (o && r) {
                    var a = g.getTransitionDurationFromElement(o);
                    f(o).removeClass("show").one(g.TRANSITION_END, n).emulateTransitionEnd(a)
                } else n()
            }, Di._transitionComplete = function (t, e, i) {
                if (e) {
                    f(e).removeClass(Ai);
                    var n = f(e.parentNode).find("> .dropdown-menu .active")[0];
                    n && f(n).removeClass(Ai), "tab" === e.getAttribute("role") && e.setAttribute("aria-selected", !1)
                }
                if (f(t).addClass(Ai), "tab" === t.getAttribute("role") && t.setAttribute("aria-selected", !0), g.reflow(t), t.classList.contains("fade") && t.classList.add("show"), t.parentNode && f(t.parentNode).hasClass("dropdown-menu")) {
                    var s = f(t).closest(".dropdown")[0];
                    if (s) {
                        var o = [].slice.call(s.querySelectorAll(".dropdown-toggle"));
                        f(o).addClass(Ai)
                    }
                    t.setAttribute("aria-expanded", !0)
                }
                i && i()
            }, Oi._jQueryInterface = function (i) {
                return this.each(function () {
                    var t = f(this),
                        e = t.data(Ti);
                    if (e || (e = new Oi(this), t.data(Ti, e)), "string" == typeof i) {
                        if (void 0 === e[i]) throw new TypeError('No method named "' + i + '"');
                        e[i]()
                    }
                })
            }, o(Oi, null, [{
                key: "VERSION",
                get: function () {
                    return "4.4.1"
                }
            }]), Oi);

        function Oi(t) {
            this._element = t
        }
        f(document).on(Ii.CLICK_DATA_API, '[data-toggle="tab"], [data-toggle="pill"], [data-toggle="list"]', function (t) {
            t.preventDefault(), Ni._jQueryInterface.call(f(this), "show")
        }), f.fn.tab = Ni._jQueryInterface, f.fn.tab.Constructor = Ni, f.fn.tab.noConflict = function () {
            return f.fn.tab = Ei, Ni._jQueryInterface
        };
        var Mi, $i = "toast",
            Hi = "bs.toast",
            Li = "." + Hi,
            Ri = f.fn[$i],
            Wi = {
                CLICK_DISMISS: "click.dismiss" + Li,
                HIDE: "hide" + Li,
                HIDDEN: "hidden" + Li,
                SHOW: "show" + Li,
                SHOWN: "shown" + Li
            },
            Fi = "show",
            ji = {
                animation: "boolean",
                autohide: "boolean",
                delay: "number"
            },
            zi = {
                animation: !0,
                autohide: !0,
                delay: 500
            },
            qi = ((Mi = Bi.prototype).show = function () {
                var t = this,
                    e = f.Event(Wi.SHOW);
                if (f(this._element).trigger(e), !e.isDefaultPrevented()) {
                    this._config.animation && this._element.classList.add("fade");
                    var i = function () {
                        t._element.classList.remove("showing"), t._element.classList.add(Fi), f(t._element).trigger(Wi.SHOWN), t._config.autohide && (t._timeout = setTimeout(function () {
                            t.hide()
                        }, t._config.delay))
                    };
                    if (this._element.classList.remove("hide"), g.reflow(this._element), this._element.classList.add("showing"), this._config.animation) {
                        var n = g.getTransitionDurationFromElement(this._element);
                        f(this._element).one(g.TRANSITION_END, i).emulateTransitionEnd(n)
                    } else i()
                }
            }, Mi.hide = function () {
                if (this._element.classList.contains(Fi)) {
                    var t = f.Event(Wi.HIDE);
                    f(this._element).trigger(t), t.isDefaultPrevented() || this._close()
                }
            }, Mi.dispose = function () {
                clearTimeout(this._timeout), this._timeout = null, this._element.classList.contains(Fi) && this._element.classList.remove(Fi), f(this._element).off(Wi.CLICK_DISMISS), f.removeData(this._element, Hi), this._element = null, this._config = null
            }, Mi._getConfig = function (t) {
                return t = r({}, zi, {}, f(this._element).data(), {}, "object" == typeof t && t ? t : {}), g.typeCheckConfig($i, t, this.constructor.DefaultType), t
            }, Mi._setListeners = function () {
                var t = this;
                f(this._element).on(Wi.CLICK_DISMISS, '[data-dismiss="toast"]', function () {
                    return t.hide()
                })
            }, Mi._close = function () {
                function t() {
                    e._element.classList.add("hide"), f(e._element).trigger(Wi.HIDDEN)
                }
                var e = this;
                if (this._element.classList.remove(Fi), this._config.animation) {
                    var i = g.getTransitionDurationFromElement(this._element);
                    f(this._element).one(g.TRANSITION_END, t).emulateTransitionEnd(i)
                } else t()
            }, Bi._jQueryInterface = function (i) {
                return this.each(function () {
                    var t = f(this),
                        e = t.data(Hi);
                    if (e || (e = new Bi(this, "object" == typeof i && i), t.data(Hi, e)), "string" == typeof i) {
                        if (void 0 === e[i]) throw new TypeError('No method named "' + i + '"');
                        e[i](this)
                    }
                })
            }, o(Bi, null, [{
                key: "VERSION",
                get: function () {
                    return "4.4.1"
                }
            }, {
                key: "DefaultType",
                get: function () {
                    return ji
                }
            }, {
                key: "Default",
                get: function () {
                    return zi
                }
            }]), Bi);

        function Bi(t, e) {
            this._element = t, this._config = this._getConfig(e), this._timeout = null, this._setListeners()
        }
        f.fn[$i] = qi._jQueryInterface, f.fn[$i].Constructor = qi, f.fn[$i].noConflict = function () {
            return f.fn[$i] = Ri, qi._jQueryInterface
        }, t.Alert = d, t.Button = T, t.Carousel = j, t.Collapse = it, t.Dropdown = ge, t.Modal = Pe, t.Popover = ci, t.Scrollspy = xi, t.Tab = Ni, t.Toast = qi, t.Tooltip = Ze, t.Util = g, Object.defineProperty(t, "__esModule", {
            value: !0
        })
    }),
    function (C) {
        C.fn.extend({
            slimScroll: function (y) {
                var w = C.extend({
                    width: "auto",
                    height: "250px",
                    size: "7px",
                    color: "#000",
                    position: "right",
                    distance: "1px",
                    start: "top",
                    opacity: .4,
                    alwaysVisible: !1,
                    disableFadeOut: !1,
                    railVisible: !1,
                    railColor: "#333",
                    railOpacity: .2,
                    railDraggable: !0,
                    railClass: "slimScrollRail",
                    barClass: "slimScrollBar",
                    wrapperClass: "slimScrollDiv",
                    allowPageScroll: !1,
                    wheelStep: 20,
                    touchScrollStep: 200,
                    borderRadius: "7px",
                    railBorderRadius: "7px"
                }, y);
                return this.each(function () {
                    function e(t) {
                        if (r) {
                            var e = 0;
                            (t = t || window.event).wheelDelta && (e = -t.wheelDelta / 120), t.detail && (e = t.detail / 3), C(t.target || t.srcTarget || t.srcElement).closest("." + w.wrapperClass).is(g.parent()) && n(e, !0), t.preventDefault && !f && t.preventDefault(), f || (t.returnValue = !1)
                        }
                    }

                    function n(t, e, i) {
                        f = !1;
                        var n = g.outerHeight() - v.outerHeight();
                        e && (e = parseInt(v.css("top")) + t * parseInt(w.wheelStep) / 100 * v.outerHeight(), e = Math.min(Math.max(e, 0), n), e = 0 < t ? Math.ceil(e) : Math.floor(e), v.css({
                            top: e + "px"
                        })), e = (d = parseInt(v.css("top")) / (g.outerHeight() - v.outerHeight())) * (g[0].scrollHeight - g.outerHeight()), i && (t = (e = t) / g[0].scrollHeight * g.outerHeight(), t = Math.min(Math.max(t, 0), n), v.css({
                            top: t + "px"
                        })), g.scrollTop(e), g.trigger("slimscrolling", ~~e), s(), o()
                    }

                    function i() {
                        u = Math.max(g.outerHeight() / g[0].scrollHeight * g.outerHeight(), 30), v.css({
                            height: u + "px"
                        });
                        var t = u == g.outerHeight() ? "none" : "block";
                        v.css({
                            display: t
                        })
                    }

                    function s() {
                        i(), clearTimeout(h), d == ~~d ? (f = w.allowPageScroll, p != d && g.trigger("slimscroll", 0 == ~~d ? "top" : "bottom")) : f = !1, p = d, u >= g.outerHeight() ? f = !0 : (v.stop(!0, !0).fadeIn("fast"), w.railVisible && _.stop(!0, !0).fadeIn("fast"))
                    }

                    function o() {
                        w.alwaysVisible || (h = setTimeout(function () {
                            w.disableFadeOut && r || a || l || (v.fadeOut("slow"), _.fadeOut("slow"))
                        }, 1e3))
                    }
                    var r, a, l, h, c, u, d, p, f = !1,
                        g = C(this);
                    if (g.parent().hasClass(w.wrapperClass)) {
                        var m = g.scrollTop(),
                            v = g.siblings("." + w.barClass),
                            _ = g.siblings("." + w.railClass);
                        if (i(), C.isPlainObject(y)) {
                            if ("height" in y && "auto" == y.height) {
                                g.parent().css("height", "auto"), g.css("height", "auto");
                                var b = g.parent().parent().height();
                                g.parent().css("height", b), g.css("height", b)
                            } else "height" in y && (b = y.height, g.parent().css("height", b), g.css("height", b));
                            if ("scrollTo" in y) m = parseInt(w.scrollTo);
                            else if ("scrollBy" in y) m += parseInt(w.scrollBy);
                            else if ("destroy" in y) return v.remove(), _.remove(), void g.unwrap();
                            n(m, !1, !0)
                        }
                    } else if (!(C.isPlainObject(y) && "destroy" in y)) {
                        w.height = "auto" == w.height ? g.parent().height() : w.height, m = C("<div></div>").addClass(w.wrapperClass).css({
                            position: "relative",
                            overflow: "hidden",
                            width: w.width,
                            height: w.height
                        }), g.css({
                            overflow: "hidden",
                            width: w.width,
                            height: w.height
                        });
                        _ = C("<div></div>").addClass(w.railClass).css({
                            width: w.size,
                            height: "100%",
                            position: "absolute",
                            top: 0,
                            display: w.alwaysVisible && w.railVisible ? "block" : "none",
                            "border-radius": w.railBorderRadius,
                            background: w.railColor,
                            opacity: w.railOpacity,
                            zIndex: 90
                        }), v = C("<div></div>").addClass(w.barClass).css({
                            background: w.color,
                            width: w.size,
                            position: "absolute",
                            top: 0,
                            opacity: w.opacity,
                            display: w.alwaysVisible ? "block" : "none",
                            "border-radius": w.borderRadius,
                            BorderRadius: w.borderRadius,
                            MozBorderRadius: w.borderRadius,
                            WebkitBorderRadius: w.borderRadius,
                            zIndex: 99
                        }), b = "right" == w.position ? {
                            right: w.distance
                        } : {
                                left: w.distance
                            };
                        _.css(b), v.css(b), g.wrap(m), g.parent().append(v), g.parent().append(_), w.railDraggable && v.bind("mousedown", function (e) {
                            var i = C(document);
                            return l = !0, t = parseFloat(v.css("top")), pageY = e.pageY, i.bind("mousemove.slimscroll", function (e) {
                                currTop = t + e.pageY - pageY, v.css("top", currTop), n(0, v.position().top, !1)
                            }), i.bind("mouseup.slimscroll", function (t) {
                                l = !1, o(), i.unbind(".slimscroll")
                            }), !1
                        }).bind("selectstart.slimscroll", function (t) {
                            return t.stopPropagation(), t.preventDefault(), !1
                        }), _.hover(function () {
                            s()
                        }, function () {
                            o()
                        }), v.hover(function () {
                            a = !0
                        }, function () {
                            a = !1
                        }), g.hover(function () {
                            r = !0, s(), o()
                        }, function () {
                            r = !1, o()
                        }), g.bind("touchstart", function (t, e) {
                            t.originalEvent.touches.length && (c = t.originalEvent.touches[0].pageY)
                        }), g.bind("touchmove", function (t) {
                            f || t.originalEvent.preventDefault(), t.originalEvent.touches.length && (n((c - t.originalEvent.touches[0].pageY) / w.touchScrollStep, !0), c = t.originalEvent.touches[0].pageY)
                        }), i(), "bottom" === w.start ? (v.css({
                            top: g.outerHeight() - v.outerHeight()
                        }), n(0, !0)) : "top" !== w.start && (n(C(w.start).position().top, null, !0), w.alwaysVisible || v.hide()), window.addEventListener ? (this.addEventListener("DOMMouseScroll", e, !1), this.addEventListener("mousewheel", e, !1)) : document.attachEvent("onmousewheel", e)
                    }
                }), this
            }
        }), C.fn.extend({
            slimscroll: C.fn.slimScroll
        })
    }(jQuery),
    function (t) {
        var e;
        if ("function" == typeof define && define.amd && (define(t), e = !0), "object" == typeof exports && (module.exports = t(), e = !0), !e) {
            var i = window.Cookies,
                n = window.Cookies = t();
            n.noConflict = function () {
                return window.Cookies = i, n
            }
        }
    }(function () {
        function a() {
            for (var t = 0, e = {}; t < arguments.length; t++) {
                var i = arguments[t];
                for (var n in i) e[n] = i[n]
            }
            return e
        }

        function h(t) {
            return t.replace(/(%[0-9A-Z]{2})+/g, decodeURIComponent)
        }
        return function t(l) {
            function r() { }

            function i(t, e, i) {
                if ("undefined" != typeof document) {
                    "number" == typeof (i = a({
                        path: "/"
                    }, r.defaults, i)).expires && (i.expires = new Date(+new Date + 864e5 * i.expires)), i.expires = i.expires ? i.expires.toUTCString() : "";
                    try {
                        var n = JSON.stringify(e);
                        /^[\{\[]/.test(n) && (e = n)
                    } catch (t) { }
                    e = l.write ? l.write(e, t) : encodeURIComponent(String(e)).replace(/%(23|24|26|2B|3A|3C|3E|3D|2F|3F|40|5B|5D|5E|60|7B|7D|7C)/g, decodeURIComponent), t = encodeURIComponent(String(t)).replace(/%(23|24|26|2B|5E|60|7C)/g, decodeURIComponent).replace(/[\(\)]/g, escape);
                    var s = "";
                    for (var o in i) i[o] && (s += "; " + o, !0 !== i[o] && (s += "=" + i[o].split(";")[0]));
                    return document.cookie = t + "=" + e + s
                }
            }

            function e(t, e) {
                if ("undefined" != typeof document) {
                    for (var i = {}, n = document.cookie ? document.cookie.split("; ") : [], s = 0; s < n.length; s++) {
                        var o = n[s].split("="),
                            r = o.slice(1).join("=");
                        e || '"' !== r.charAt(0) || (r = r.slice(1, -1));
                        try {
                            var a = h(o[0]);
                            if (r = (l.read || l)(r, a) || h(r), e) try {
                                r = JSON.parse(r)
                            } catch (t) { }
                            if (i[a] = r, t === a) break
                        } catch (t) { }
                    }
                    return t ? i[t] : i
                }
            }
            return r.set = i, r.get = function (t) {
                return e(t, !1)
            }, r.getJSON = function (t) {
                return e(t, !0)
            }, r.remove = function (t, e) {
                i(t, "", a(e, {
                    expires: -1
                }))
            }, r.defaults = {}, r.withConverter = t, r
        }(function () { })
    });
var floatSubMenuTimeout, targetFloatMenu, handleSlimScroll = function () {
    "use strict";
    $.when($("[data-scrollbar=true]").each(function () {
        generateSlimScroll($(this))
    })).done(function () {
        $('[data-scrollbar="true"]').mouseover()
    })
},
    generateSlimScroll = function (t) {
        if (!$(t).attr("data-init")) {
            var e = $(t).attr("data-height"),
                i = {
                    height: e = e || $(t).height()
                };
            /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) ? ($(t).css("height", e), $(t).css("overflow-x", "scroll")) : $(t).slimScroll(i), $(t).attr("data-init", !0), $(".slimScrollBar").hide()
        }
    },
    handleSidebarMenu = function () {
        "use strict";
        var i = $(".sidebar").attr("data-disable-slide-animation") ? 0 : 250;
        $(document).on("click", ".sidebar .nav > .has-sub > a", function () {
            var e = $(this).next(".sub-menu"),
                t = $(".sidebar .nav > li.has-sub > .sub-menu").not(e);
            0 === $(".page-sidebar-minified").length && ($(t).closest("li").addClass("closing"), $(t).slideUp(i, function () {
                $(t).closest("li").addClass("closed").removeClass("expand closing")
            }), $(e).is(":visible") ? $(e).closest("li").addClass("closing").removeClass("expand") : $(e).closest("li").addClass("expanding").removeClass("closed"), $(e).slideToggle(i, function () {
                var t = $(this).closest("li");
                $(e).is(":visible") ? ($(t).addClass("expand"), $(t).removeClass("closed")) : ($(t).addClass("closed"), $(t).removeClass("expand")), $(t).removeClass("expanding closing")
            }))
        }), $(document).on("click", ".sidebar .nav > .has-sub .sub-menu li.has-sub > a", function () {
            if (0 === $(".page-sidebar-minified").length) {
                var e = $(this).next(".sub-menu");
                $(e).is(":visible") ? $(e).closest("li").addClass("closing").removeClass("expand") : $(e).closest("li").addClass("expanding").removeClass("closed"), $(e).slideToggle(i, function () {
                    var t = $(this).closest("li");
                    $(e).is(":visible") ? ($(t).addClass("expand"), $(t).removeClass("closed")) : ($(t).addClass("closed"), $(t).removeClass("expand")), $(t).removeClass("expanding closing")
                })
            }
        })
    },
    handleMobileSidebarToggle = function () {
        var n = !1;
        $(document).on("click touchstart", ".sidebar", function (t) {
            0 !== $(t.target).closest(".sidebar").length ? n = !0 : (n = !1, t.stopPropagation())
        }), $(document).on("click touchstart", function (t) {
            0 === $(t.target).closest(".sidebar").length && (n = !1), 0 !== $(t.target).closest("#float-sub-menu").length && (n = !0), t.isPropagationStopped() || !0 === n || ($("#page-container").hasClass("page-sidebar-toggled") && (n = !0, $("#page-container").removeClass("page-sidebar-toggled")), $(window).width() <= 767 && $("#page-container").hasClass("page-right-sidebar-toggled") && (n = !0, $("#page-container").removeClass("page-right-sidebar-toggled")))
        }), $(document).on("click", "[data-click=right-sidebar-toggled]", function (t) {
            t.stopPropagation();
            var e = "#page-container",
                i = "page-right-sidebar-collapsed";
            i = $(window).width() < 768 ? "page-right-sidebar-toggled" : i, $(e).hasClass(i) ? $(e).removeClass(i) : !0 !== n ? $(e).addClass(i) : n = !1, $(window).width() < 480 && $("#page-container").removeClass("page-sidebar-toggled"), $(window).trigger("resize")
        }), $(document).on("click", "[data-click=sidebar-toggled]", function (t) {
            t.stopPropagation();
            var e = "page-sidebar-toggled",
                i = "#page-container";
            $(i).hasClass(e) ? $(i).removeClass(e) : !0 !== n ? $(i).addClass(e) : n = !1, $(window).width() < 480 && $("#page-container").removeClass("page-right-sidebar-toggled")
        })
    },
    handleSidebarMinify = function () {
        $(document).on("click", '[data-click="sidebar-minify"]', function (t) {
            t.preventDefault();
            var e = "page-sidebar-minified",
                i = "#page-container",
                n = !1;
            $(i).hasClass(e) ? $(i).removeClass(e) : ($(i).addClass(e), /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) && ($('#sidebar [data-scrollbar="true"]').css("margin-top", "0"), $('#sidebar [data-scrollbar="true"]').css("overflow-x", "scroll")), n = !0), $(window).trigger("resize"), Cookies && Cookies.set("sidebar-minified", n)
        }), !Cookies || "true" == Cookies.get("sidebar-minified") && $("#page-container").addClass("page-sidebar-minified")
    },
    handlePageContentView = function () {
        "use strict";
        var t = "",
            e = "",
            i = handleCheckBootstrapVersion();
        3 <= i && i < 4 ? (t = "hide", e = "in") : 4 <= i && i < 5 && (t = "d-none", e = "show"), $(window).on("load", function () {
            $.when($("#page-loader").addClass(t)).done(function () {
                $("#page-container").addClass(e)
            })
        })
    },
    panelActionRunning = !1,
    handlePanelAction = function () {
        "use strict";
        if (panelActionRunning) return !1;
        panelActionRunning = !0, $(document).on("hover", "[data-click=panel-remove]", function (t) {
            $(this).attr("data-init") || ($(this).tooltip({
                title: "Remove",
                placement: "bottom",
                trigger: "hover",
                container: "body"
            }), $(this).tooltip("show"), $(this).attr("data-init", !0))
        }), $(document).on("click", "[data-click=panel-remove]", function (t) {
            t.preventDefault();
            var e = handleCheckBootstrapVersion();
            4 <= e && e < 5 ? $(this).tooltip("dispose") : $(this).tooltip("destroy"), $(this).closest(".panel").remove()
        }), $(document).on("hover", "[data-click=panel-collapse]", function (t) {
            $(this).attr("data-init") || ($(this).tooltip({
                title: "Collapse / Expand",
                placement: "bottom",
                trigger: "hover",
                container: "body"
            }), $(this).tooltip("show"), $(this).attr("data-init", !0))
        }), $(document).on("click", "[data-click=panel-collapse]", function (t) {
            t.preventDefault(), $(this).closest(".panel").find(".panel-body").slideToggle()
        }), $(document).on("hover", "[data-click=panel-reload]", function (t) {
            $(this).attr("data-init") || ($(this).tooltip({
                title: "Reload",
                placement: "bottom",
                trigger: "hover",
                container: "body"
            }), $(this).tooltip("show"), $(this).attr("data-init", !0))
        }), $(document).on("click", "[data-click=panel-reload]", function (t) {
            t.preventDefault();
            var e = $(this).closest(".panel");
            if (!$(e).hasClass("panel-loading")) {
                var i = $(e).find(".panel-body");
                $(e).addClass("panel-loading"), $(i).prepend('<div class="panel-loader"><span class="spinner-small"></span></div>'), setTimeout(function () {
                    $(e).removeClass("panel-loading"), $(e).find(".panel-loader").remove()
                }, 2e3)
            }
        }), $(document).on("hover", "[data-click=panel-expand]", function (t) {
            $(this).attr("data-init") || ($(this).tooltip({
                title: "Expand / Compress",
                placement: "bottom",
                trigger: "hover",
                container: "body"
            }), $(this).tooltip("show"), $(this).attr("data-init", !0))
        }), $(document).on("click", "[data-click=panel-expand]", function (t) {
            t.preventDefault();
            var e = $(this).closest(".panel"),
                i = $(e).find(".panel-body"),
                n = 40;
            if (0 !== $(i).length) {
                var s = $(e).offset().top;
                n = $(i).offset().top - s
            }
            if ($("body").hasClass("panel-expand") && $(e).hasClass("panel-expand")) $("body, .panel").removeClass("panel-expand"), $(".panel").removeAttr("style"), $(i).removeAttr("style");
            else if ($("body").addClass("panel-expand"), $(this).closest(".panel").addClass("panel-expand"), 0 !== $(i).length && 40 != n) {
                var o = 40;
                $(e).find(" > *").each(function () {
                    var t = $(this).attr("class");
                    "panel-heading" != t && "panel-body" != t && (o += $(this).height() + 30)
                }), 40 != o && $(i).css("top", o + "px")
            }
            $(window).trigger("resize")
        })
    },
    handleDraggablePanel = function () {
        "use strict";
        var t = $('.panel:not([data-sortable="false"])').parent("[class*=col]");
        $(t).sortable({
            handle: ".panel-heading",
            connectWith: ".row > [class*=col]",
            stop: function (t, e) {
                e.item.find(".panel-title").append('<i class="fa fa-refresh fa-spin m-l-5" data-id="title-spinner"></i>'), handleSavePanelPosition(e.item)
            }
        })
    },
    handelTooltipPopoverActivation = function () {
        "use strict";
        0 !== $('[data-toggle="tooltip"]').length && $("[data-toggle=tooltip]").tooltip(), 0 !== $('[data-toggle="popover"]').length && $("[data-toggle=popover]").popover()
    },
    handleScrollToTopButton = function () {
        "use strict";
        var t = handleCheckBootstrapVersion(),
            e = "";
        3 <= t && t < 4 ? e = "in" : 4 <= t && t < 5 && (e = "show"), $(document).scroll(function () {
            200 <= $(document).scrollTop() ? $("[data-click=scroll-top]").addClass(e) : $("[data-click=scroll-top]").removeClass(e)
        }), $("[data-click=scroll-top]").click(function (t) {
            t.preventDefault(), $("html, body").animate({
                scrollTop: $("body").offset().top
            }, 500)
        })
    },
    handleThemePageStructureControl = function () {
        if ($(document).on("click", '.theme-panel [data-click="theme-selector"]', function () {
            var t = $(this).attr("data-theme-file"),
                e = $(this).attr("data-theme");
            0 === $("#theme-css-link").length ? $("head").append('<link href="' + t + '" rel="stylesheet" id="theme-css-link" />') : $("#theme-css-link").attr("href", t), $('.theme-panel [data-click="theme-selector"]').not(this).closest("li").removeClass("active"), $(this).closest("li").addClass("active"), Cookies && Cookies.set("page-theme", e)
        }), $(document).on("change", '.theme-panel [name="header-inverse"]', function () {
            var t = $(this).is(":checked"),
                e = t ? "navbar-inverse" : "navbar-default",
                i = t ? "navbar-default" : "navbar-inverse";
            $("#header").removeClass(i).addClass(e), Cookies && Cookies.set("header-theme", e)
        }), $(document).on("change", '.theme-panel [name="sidebar-grid"]', function () {
            var t = !1;
            $(this).is(":checked") ? ($("#sidebar").addClass("sidebar-grid"), t = !0) : $("#sidebar").removeClass("sidebar-grid"), Cookies && Cookies.set("sidebar-grid", t)
        }), $(document).on("change", '.theme-panel [name="sidebar-gradient"]', function () {
            var t = !1;
            $(this).is(":checked") ? ($("#page-container").addClass("gradient-enabled"), t = !0) : $("#page-container").removeClass("gradient-enabled"), Cookies && Cookies.set("sidebar-gradient", t)
        }), $(document).on("change", '.theme-panel [name="sidebar-fixed"]', function () {
            var t = !1;
            $(this).is(":checked") ? ($('.theme-panel [name="header-fixed"]').is(":checked") || (alert("Default Header with Fixed Sidebar option is not supported. Proceed with Fixed Header with Fixed Sidebar."), $('.theme-panel [name="header-fixed"]').prop("checked", !0), $("#page-container").addClass("page-header-fixed")), $("#page-container").addClass("page-sidebar-fixed"), $("#page-container").hasClass("page-sidebar-minified") || generateSlimScroll($('.sidebar [data-scrollbar="true"]')), t = !0) : ($("#page-container").removeClass("page-sidebar-fixed"), 0 !== $(".sidebar .slimScrollDiv").length && ($(window).width() <= 979 ? $(".sidebar").each(function () {
                if (!$("#page-container").hasClass("page-with-two-sidebar") || !$(this).hasClass("sidebar-right")) {
                    $(this).find(".slimScrollBar").remove(), $(this).find(".slimScrollRail").remove(), $(this).find('[data-scrollbar="true"]').removeAttr("style");
                    var t = $(this).find('[data-scrollbar="true"]').parent(),
                        e = $(t).html();
                    $(t).replaceWith(e)
                }
            }) : 979 < $(window).width() && ($('.sidebar [data-scrollbar="true"]').slimScroll({
                destroy: !0
            }), $('.sidebar [data-scrollbar="true"]').removeAttr("style"), $('.sidebar [data-scrollbar="true"]').removeAttr("data-init"))), 0 === $("#page-container .sidebar-bg").length && $("#page-container").append('<div class="sidebar-bg"></div>')), Cookies && Cookies.set("sidebar-fixed", t)
        }), $(document).on("change", '.theme-panel [name="header-fixed"]', function () {
            var t = !1;
            $(this).is(":checked") ? ($("#header").addClass("navbar-fixed-top"), $("#page-container").addClass("page-header-fixed"), t = !0) : ($('.theme-panel [name="sidebar-fixed"]').is(":checked") && (alert("Default Header with Fixed Sidebar option is not supported. Proceed with Default Header with Default Sidebar."), $('.theme-panel [name="sidebar-fixed"]').prop("checked", !1), $('.theme-panel [name="sidebar-fixed"]').trigger("change"), 0 === $("#page-container .sidebar-bg").length && $("#page-container").append('<div class="sidebar-bg"></div>')), $("#header").removeClass("navbar-fixed-top"), $("#page-container").removeClass("page-header-fixed")), Cookies && Cookies.set("header-fixed", t)
        }), Cookies) {
            var t = Cookies.get("page-theme"),
                e = Cookies.get("header-theme"),
                i = Cookies.get("sidebar-grid"),
                n = Cookies.get("sidebar-gradient"),
                s = Cookies.get("sidebar-fixed"),
                o = Cookies.get("header-fixed");
            t && $('.theme-panel [data-click="theme-selector"][data-theme="' + t + '"]').trigger("click"), e && "navbar-inverse" == e && $('.theme-panel [name="header-inverse"]').prop("checked", !0).trigger("change"), "true" == i && $('.theme-panel [name="sidebar-grid"]').prop("checked", !0).trigger("change"), "true" == n && $('.theme-panel [name="sidebar-gradient"]').prop("checked", !0).trigger("change"), "false" == s && $('.theme-panel [name="sidebar-fixed"]').prop("checked", !1).trigger("change"), "false" == o && $('.theme-panel [name="header-fixed"]').prop("checked", !1).trigger("change")
        }
    },
    handleThemePanelExpand = function () {
        $(document).on("click", '[data-click="theme-panel-expand"]', function () {
            var t = ".theme-panel",
                e = "active",
                i = !1;
            $(t).hasClass(e) ? $(t).removeClass(e) : ($(t).addClass(e), i = !0), Cookies && Cookies.set("theme-panel-expand", i)
        }), !Cookies || "true" == Cookies.get("theme-panel-expand") && $('[data-click="theme-panel-expand"]').trigger("click")
    },
    handleAfterPageLoadAddClass = function () {
        0 !== $("[data-pageload-addclass]").length && $(window).on("load", function () {
            $("[data-pageload-addclass]").each(function () {
                var t = $(this).attr("data-pageload-addclass");
                $(this).addClass(t)
            })
        })
    },
    handleSavePanelPosition = function (e) {
        "use strict";
        if (0 !== $(".ui-sortable").length) {
            var i = [];
            $.when($(".ui-sortable").each(function () {
                var t = $(this).find("[data-sortable-id]");
                if (0 !== t.length) {
                    var e = [];
                    $(t).each(function () {
                        var t = $(this).attr("data-sortable-id");
                        e.push({
                            id: t
                        })
                    }), i.push(e)
                } else i.push([]);
                0
            })).done(function () {
                var t = window.location.href;
                t = (t = t.split("?"))[0], localStorage.setItem(t, JSON.stringify(i)), $(e).find('[data-id="title-spinner"]').delay(500).fadeOut(500, function () {
                    $(this).remove()
                })
            })
        }
    },
    handleLocalStorage = function () {
        "use strict";
        try {
            if ("undefined" != typeof Storage && "undefined" != typeof localStorage) {
                var t = window.location.href;
                t = (t = t.split("?"))[0];
                var e = localStorage.getItem(t);
                if (e) {
                    e = JSON.parse(e);
                    var i = 0;
                    $.when($('.panel:not([data-sortable="false"])').parent('[class*="col-"]').each(function () {
                        var t = e[i],
                            s = $(this);
                        t && $.each(t, function (t, e) {
                            var i = $('[data-sortable-id="' + e.id + '"]').not('[data-init="true"]');
                            if (0 !== $(i).length) {
                                var n = $(i).clone();
                                $(i).remove(), $(s).append(n), $('[data-sortable-id="' + e.id + '"]').attr("data-init", "true")
                            }
                        }), i++
                    })).done(function () {
                        window.dispatchEvent(new CustomEvent("localstorage-position-loaded"))
                    })
                }
            } else alert("Your browser is not supported with the local storage")
        } catch (t) {
            console.log(t)
        }
    },
    handleResetLocalStorage = function () {
        "use strict";
        $(document).on("click", "[data-click=reset-local-storage]", function (t) {
            t.preventDefault();
            $("body").append('<div class="modal fade" data-modal-id="reset-local-storage-confirmation">    <div class="modal-dialog">        <div class="modal-content">            <div class="modal-header">                <h4 class="modal-title"><i class="fa fa-redo m-r-5"></i> Reset Local Storage Confirmation</h4>                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>            </div>            <div class="modal-body">                <div class="alert alert-info m-b-0">Would you like to RESET all your saved widgets and clear Local Storage?</div>            </div>            <div class="modal-footer">                <a href="javascript:;" class="btn btn-sm btn-default" data-dismiss="modal"><i class="fa fa-times"></i> No</a>                <a href="javascript:;" class="btn btn-sm btn-inverse" data-click="confirm-reset-local-storage"><i class="fa fa-check"></i> Yes</a>            </div>        </div>    </div></div>'), $('[data-modal-id="reset-local-storage-confirmation"]').modal("show")
        }), $(document).on("hidden.bs.modal", '[data-modal-id="reset-local-storage-confirmation"]', function (t) {
            $('[data-modal-id="reset-local-storage-confirmation"]').remove()
        }), $(document).on("click", "[data-click=confirm-reset-local-storage]", function (t) {
            t.preventDefault();
            var e = window.location.href;
            e = (e = e.split("?"))[0], localStorage.removeItem(e), location.reload()
        })
    },
    handleIEFullHeightContent = function () {
        0 < window.navigator.userAgent.indexOf("MSIE ") && $('.vertical-box-row [data-scrollbar="true"][data-height="100%"]').each(function () {
            var t = $(this).closest(".vertical-box-row"),
                e = $(t).height();
            $(t).find(".vertical-box-cell").height(e)
        })
    },
    handleUnlimitedTabsRender = function () {
        function e(t, e) {
            var i = $(t).closest(".tab-overflow"),
                n = "rtl" == $("body").css("direction") ? "margin-right" : "margin-left",
                s = parseInt($(i).find(".nav.nav-tabs").css(n)),
                o = $(i).width(),
                r = 0,
                a = 0;
            switch ($(i).find("li").each(function () {
                $(this).hasClass("next-button") || $(this).hasClass("prev-button") || (r += $(this).width())
            }), e) {
                case "next":
                    (l = r + s - o) <= o ? (a = l - s, setTimeout(function () {
                        $(i).removeClass("overflow-right")
                    }, 150)) : a = o - s - 80, 0 !== a && ("rtl" != $("body").css("direction") ? $(i).find(".nav.nav-tabs").animate({
                        marginLeft: "-" + a + "px"
                    }, 150, function () {
                        $(i).addClass("overflow-left")
                    }) : $(i).find(".nav.nav-tabs").animate({
                        marginRight: "-" + a + "px"
                    }, 150, function () {
                        $(i).addClass("overflow-left")
                    }));
                    break;
                case "prev":
                    var l;
                    a = (l = -s) <= o ? ($(i).removeClass("overflow-left"), 0) : l - o + 80, "rtl" != $("body").css("direction") ? $(i).find(".nav.nav-tabs").animate({
                        marginLeft: "-" + a + "px"
                    }, 150, function () {
                        $(i).addClass("overflow-right")
                    }) : $(i).find(".nav.nav-tabs").animate({
                        marginRight: "-" + a + "px"
                    }, 150, function () {
                        $(i).addClass("overflow-right")
                    })
            }
        }

        function t() {
            $(".tab-overflow").each(function () {
                ! function (t, e) {
                    var i = "li.active";
                    $(t).find("li").first().hasClass("nav-item") && (i = $(t).find(".nav-item .active").closest("li"));
                    var n = "rtl" == $("body").css("direction") ? "margin-right" : "margin-left",
                        s = (parseInt($(t).css(n)), $(t).width()),
                        o = $(t).find(i).width(),
                        r = -1 < e ? e : 150,
                        a = 0;
                    if ($(t).find(i).prevAll().each(function () {
                        o += $(this).width()
                    }), $(t).find("li").each(function () {
                        a += $(this).width()
                    }), s <= o) {
                        var l = o - s;
                        a != o && (l += 40), "rtl" == $("body").css("direction") ? $(t).find(".nav.nav-tabs").animate({
                            marginRight: "-" + l + "px"
                        }, r) : $(t).find(".nav.nav-tabs").animate({
                            marginLeft: "-" + l + "px"
                        }, r)
                    }
                    o != a && s <= a ? $(t).addClass("overflow-right") : $(t).removeClass("overflow-right"), s <= o && s <= a ? $(t).addClass("overflow-left") : $(t).removeClass("overflow-left")
                }(this, 0)
            })
        }
        $('[data-click="next-tab"]').click(function (t) {
            t.preventDefault(), e(this, "next")
        }), $('[data-click="prev-tab"]').click(function (t) {
            t.preventDefault(), e(this, "prev")
        }), $(window).resize(function () {
            $(".tab-overflow .nav.nav-tabs").removeAttr("style"), t()
        }), t()
    },
    handleUnlimitedTopMenuRender = function () {
        "use strict";

        function e(t, e) {
            var i = $(t).closest(".nav"),
                n = "rtl" == $("body").css("direction") ? "margin-right" : "margin-left",
                s = parseInt($(i).css(n)),
                o = $(".top-menu").width() - 88,
                r = 0,
                a = 0;
            switch ($(i).find("li").each(function () {
                $(this).hasClass("menu-control") || (r += $(this).width())
            }), e) {
                case "next":
                    (l = r + s - o) <= o ? (a = l - s + 128, setTimeout(function () {
                        $(i).find(".menu-control.menu-control-right").removeClass("show")
                    }, 150)) : a = o - s - 128, 0 !== a && ("rtl" != $("body").css("direction") ? $(i).animate({
                        marginLeft: "-" + a + "px"
                    }, 150, function () {
                        $(i).find(".menu-control.menu-control-left").addClass("show")
                    }) : $(i).animate({
                        marginRight: "-" + a + "px"
                    }, 150, function () {
                        $(i).find(".menu-control.menu-control-left").addClass("show")
                    }));
                    break;
                case "prev":
                    var l;
                    a = (l = -s) <= o ? ($(i).find(".menu-control.menu-control-left").removeClass("show"), 0) : l - o + 88, "rtl" != $("body").css("direction") ? $(i).animate({
                        marginLeft: "-" + a + "px"
                    }, 150, function () {
                        $(i).find(".menu-control.menu-control-right").addClass("show")
                    }) : $(i).animate({
                        marginRight: "-" + a + "px"
                    }, 150, function () {
                        $(i).find(".menu-control.menu-control-right").addClass("show")
                    })
            }
        }

        function t() {
            var t = $(".top-menu .nav"),
                e = $(".top-menu .nav > li"),
                i = $(".top-menu .nav > li.active"),
                n = $(".top-menu"),
                s = "rtl" == $("body").css("direction") ? "margin-right" : "margin-left",
                o = (parseInt($(t).css(s)), $(n).width() - 128),
                r = $(".top-menu .nav > li.active").width(),
                a = 0;
            if ($(i).prevAll().each(function () {
                r += $(this).width()
            }), $(e).each(function () {
                $(this).hasClass("menu-control") || (a += $(this).width())
            }), o <= r) {
                var l = r - o + 128;
                "rtl" != $("body").css("direction") ? $(t).animate({
                    marginLeft: "-" + l + "px"
                }, 0) : $(t).animate({
                    marginRight: "-" + l + "px"
                }, 0)
            }
            r != a && o <= a ? $(t).find(".menu-control.menu-control-right").addClass("show") : $(t).find(".menu-control.menu-control-right").removeClass("show"), o <= r && o <= a ? $(t).find(".menu-control.menu-control-left").addClass("show") : $(t).find(".menu-control.menu-control-left").removeClass("show")
        }
        $('[data-click="next-menu"]').click(function (t) {
            t.preventDefault(), e(this, "next")
        }), $('[data-click="prev-menu"]').click(function (t) {
            t.preventDefault(), e(this, "prev")
        }), $(window).resize(function () {
            $(".top-menu .nav").removeAttr("style"), t()
        }), t()
    },
    handleTopMenuSubMenu = function () {
        "use strict";
        $(document).on("click", ".top-menu .sub-menu .has-sub > a", function () {
            var t = $(this).closest("li").find(".sub-menu").first(),
                e = $(this).closest("ul").find(".sub-menu").not(t);
            $(e).not(t).slideUp(250, function () {
                $(this).closest("li").removeClass("expand")
            }), $(t).slideToggle(250, function () {
                var t = $(this).closest("li");
                $(t).hasClass("expand") ? $(t).removeClass("expand") : $(t).addClass("expand")
            })
        })
    },
    handleMobileTopMenuSubMenu = function () {
        "use strict";
        $(document).on("click", ".top-menu .nav > li.has-sub > a", function () {
            if ($(window).width() <= 767) {
                var t = $(this).closest("li").find(".sub-menu").first(),
                    e = $(this).closest("ul").find(".sub-menu").not(t);
                $(e).not(t).slideUp(250, function () {
                    $(this).closest("li").removeClass("expand")
                }), $(t).slideToggle(250, function () {
                    var t = $(this).closest("li");
                    $(t).hasClass("expand") ? $(t).removeClass("expand") : $(t).addClass("expand")
                })
            }
        })
    },
    handleTopMenuMobileToggle = function () {
        "use strict";
        $(document).on("click", '[data-click="top-menu-toggled"]', function () {
            $(".top-menu").slideToggle(250)
        })
    },
    handleClearSidebarSelection = function () {
        $(".sidebar .nav > li, .sidebar .nav .sub-menu").removeClass("expand").removeAttr("style")
    },
    handleClearSidebarMobileSelection = function () {
        $("#page-container").removeClass("page-sidebar-toggled")
    },
    handleCheckBootstrapVersion = function () {
        return parseInt($.fn.tooltip.Constructor.VERSION)
    },
    handleCheckScrollClass = function () {
        0 < $(window).scrollTop() ? $("#page-container").addClass("has-scroll") : $("#page-container").removeClass("has-scroll")
    },
    handlePageScrollClass = function () {
        $(window).on("scroll", function () {
            handleCheckScrollClass()
        }), handleCheckScrollClass()
    },
    handleToggleNavProfile = function () {
        var n = $(".sidebar").attr("data-disable-slide-animation") ? 0 : 250;
        $(document).on("click", '[data-toggle="nav-profile"]', function (t) {
            t.preventDefault();
            var e = $(this).closest("li"),
                i = $(".sidebar .nav.nav-profile");
            $(i).is(":visible") ? ($(e).removeClass("active"), $(i).removeClass("closing")) : ($(e).addClass("active"), $(i).addClass("expanding")), $(i).slideToggle(n, function () {
                $(i).is(":visible") ? ($(i).addClass("expand"), $(i).removeClass("closed")) : ($(i).addClass("closed"), $(i).removeClass("expand")), $(i).removeClass("expanding closing")
            })
        })
    },
    handleSidebarScrollMemory = function () {
        if (!/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)) try {
            if ("undefined" != typeof Storage && "undefined" != typeof localStorage) {
                $('.sidebar [data-scrollbar="true"]').slimScroll().bind("slimscrolling", function (t, e) {
                    localStorage.setItem("sidebarScrollPosition", e + "px")
                });
                var t = localStorage.getItem("sidebarScrollPosition");
                t && $('.sidebar [data-scrollbar="true"]').slimScroll({
                    scrollTo: t
                })
            }
        } catch (t) {
            console.log(t)
        }
    },
    handleMouseoverFloatSubMenu = function (t) {
        clearTimeout(floatSubMenuTimeout)
    },
    handleMouseoutFloatSubMenu = function (t) {
        floatSubMenuTimeout = setTimeout(function () {
            $("#float-sub-menu").remove()
        }, 150)
    },
    handleSidebarMinifyFloatMenu = function () {
        $(document).on("click", "#float-sub-menu li.has-sub > a", function (t) {
            var e = $(this).next(".sub-menu"),
                i = $(e).closest("li"),
                l = !1,
                h = !1;
            $(e).is(":visible") ? ($(i).addClass("closing"), l = !0) : ($(i).addClass("expanding"), h = !0), $(e).slideToggle({
                duration: 250,
                progress: function () {
                    var t = $("#float-sub-menu"),
                        e = $(t).height(),
                        i = $(t).offset(),
                        n = $(t).attr("data-offset-top"),
                        s = $(t).attr("data-menu-offset-top"),
                        o = i.top - $(window).scrollTop(),
                        r = $(window).height();
                    if (l && n < o && (o = n < o ? n : o, $("#float-sub-menu").css({
                        top: o + "px",
                        bottom: "auto"
                    }), $("#float-sub-menu-arrow").css({
                        top: "20px",
                        bottom: "auto"
                    }), $("#float-sub-menu-line").css({
                        top: "20px",
                        bottom: "auto"
                    })), h && r - o < e) {
                        var a = r - s - 22;
                        $("#float-sub-menu").css({
                            top: "auto",
                            bottom: 0
                        }), $("#float-sub-menu-arrow").css({
                            top: "auto",
                            bottom: a + "px"
                        }), $("#float-sub-menu-line").css({
                            top: "20px",
                            bottom: a + "px"
                        })
                    }
                },
                complete: function () {
                    $(e).is(":visible") ? ($(i).addClass("expand"), $(i).removeClass("closed")) : ($(i).addClass("closed"), $(i).removeClass("expand")), $(i).removeClass("closing expanding")
                }
            })
        }), $(document).on({
            mouseenter: function () {
                if ($("#page-container").hasClass("page-sidebar-minified")) {
                    clearTimeout(floatSubMenuTimeout);
                    var t = $(this).closest("li").find(".sub-menu").first();
                    if (targetFloatMenu == this && 0 !== $("#float-sub-menu").length) return;
                    targetFloatMenu = this;
                    var e = $(t).html();
                    if (e) {
                        var i = $("#sidebar").offset(),
                            n = parseInt($("#sidebar").width()),
                            s = $("#page-container").hasClass("page-with-right-sidebar") || "rtl" == $("body").css("direction") ? $(window).width() - i.left : i.left + n,
                            o = ($(t).height(), $(this).offset().top - $(window).scrollTop()),
                            r = $("#page-container").hasClass("page-with-right-sidebar") || "rtl" == $("body").css("direction") ? "auto" : s,
                            a = $("#page-container").hasClass("page-with-right-sidebar") || "rtl" == $("body").css("direction") ? s : "auto",
                            l = $(window).height();
                        if (0 === $("#float-sub-menu").length ? (e = '<div class="float-sub-menu-container" id="float-sub-menu" data-offset-top="' + o + '" data-menu-offset-top="' + o + '" onmouseover="handleMouseoverFloatSubMenu(this)" onmouseout="handleMouseoutFloatSubMenu(this)">\t<div class="float-sub-menu-arrow" id="float-sub-menu-arrow"></div>\t<div class="float-sub-menu-line" id="float-sub-menu-line"></div>\t<ul class="float-sub-menu">' + e + "</ul></div>", $("#page-container").append(e)) : ($("#float-sub-menu").attr("data-offset-top", o), $("#float-sub-menu").attr("data-menu-offset-top", o), $(".float-sub-menu").html(e)), $("#float-sub-menu").height() < l - o) $("#float-sub-menu").css({
                            top: o,
                            left: r,
                            bottom: "auto",
                            right: a
                        }), $("#float-sub-menu-arrow").css({
                            top: "20px",
                            bottom: "auto"
                        }), $("#float-sub-menu-line").css({
                            top: "20px",
                            bottom: "auto"
                        });
                        else {
                            $("#float-sub-menu").css({
                                bottom: 0,
                                top: "auto",
                                left: r,
                                right: a
                            });
                            var h = l - o - 21;
                            $("#float-sub-menu-arrow").css({
                                top: "auto",
                                bottom: h + "px"
                            }), $("#float-sub-menu-line").css({
                                top: "20px",
                                bottom: h + "px"
                            })
                        }
                    } else $("#float-sub-menu").remove(), targetFloatMenu = ""
                }
            },
            mouseleave: function () {
                $("#page-container").hasClass("page-sidebar-minified") && (floatSubMenuTimeout = setTimeout(function () {
                    $("#float-sub-menu").remove(), targetFloatMenu = ""
                }, 250))
            }
        }, ".sidebar .nav > li.has-sub > a")
    },
    CLEAR_OPTION = "",
    handleAjaxMode = function (h) {
        var c = h.emptyHtml ? h.emptyHtml : '<div class="p-t-40 p-b-40 text-center f-s-20 content"><i class="fa fa-warning fa-lg text-muted m-r-5"></i> <span class="f-w-600 text-inverse">Error 404! Page not found.</span></div>',
            t = h.ajaxDefaultUrl ? h.ajaxDefaultUrl : "";

        function u(t) {
            t ? ($("#page-content-loader").remove(), $("body").removeClass("page-content-loading")) : 0 === $("#page-content-loader").length && ($("body").addClass("page-content-loading"), $("#content").append('<div id="page-content-loader"><span class="spinner"></span></div>'))
        }

        function e(t, e, i) {
            var n, s, o;
            Pace.restart(), u(!1), $(".jvectormap-label, .jvector-label, .AutoFill_border ,#gritter-notice-wrapper, .ui-autocomplete, .colorpicker, .FixedHeader_Header, .FixedHeader_Cloned .lightboxOverlay, .lightbox, .introjs-hints, .nvtooltip, #float-sub-menu").remove(), $.fn.DataTable && $(".dataTable").DataTable().destroy(), $("#page-container").hasClass("page-sidebar-toggled") && $("#page-container").removeClass("page-sidebar-toggled"), n = '#sidebar [data-toggle="ajax"][href="' + t + '"]', 0 !== $(n).length && ($("#sidebar li").removeClass("active"), $(n).closest("li").addClass("active"), $(n).parents().addClass("active")), CLEAR_OPTION && (App.clearPageOption(CLEAR_OPTION), CLEAR_OPTION = ""), i || (s = t.replace("#", ""), (o = window.navigator.userAgent.indexOf("MSIE ")) && 0 < o && o < 9 ? window.location.href = s : history.pushState("", "", "#" + s));
            var r = t.replace("#", ""),
                a = h.ajaxType ? h.ajaxType : "GET",
                l = h.ajaxDataType ? h.ajaxDataType : "html";
            e && (l = $(e).attr("data-type") ? $(e).attr("data-type") : l, targetDataDataType = $(e).attr("data-data-type") ? $(e).attr("data-data-type") : l), $.ajax({
                url: r,
                type: a,
                dataType: l,
                success: function (t) {
                    $("#content").html(t)
                },
                error: function (t, e, i) {
                    $("#content").html(c)
                }
            }).done(function () {
                u(!0), $("html, body").animate({
                    scrollTop: 0
                }, 0), App.initComponent()
            })
        }
        "" === (t = window.location.hash ? window.location.hash : t) ? $("#content").html(c) : e(t, "", !0), $(window).on("hashchange", function () {
            window.location.hash && e(window.location.hash, "", !0)
        }), $(document).on("click", '[data-toggle="ajax"]', function (t) {
            t.preventDefault(), e($(this).attr("href"), this)
        })
    },
    handleSetPageOption = function (t) {
        t.pageContentFullHeight && $("#page-container").addClass("page-content-full-height"), t.pageSidebarLight && $("#page-container").addClass("page-with-light-sidebar"), t.pageSidebarRight && $("#page-container").addClass("page-with-right-sidebar"), t.pageSidebarWide && $("#page-container").addClass("page-with-wide-sidebar"), t.pageSidebarMinified && $("#page-container").addClass("page-sidebar-minified"), t.pageSidebarTransparent && $("#sidebar").addClass("sidebar-transparent"), t.pageContentFullWidth && $("#content").addClass("content-full-width"), t.pageContentInverseMode && $("#content").addClass("content-inverse-mode"), t.pageBoxedLayout && $("body").addClass("boxed-layout"), t.clearOptionOnLeave && (CLEAR_OPTION = t)
    },
    handleClearPageOption = function (t) {
        t.pageContentFullHeight && $("#page-container").removeClass("page-content-full-height"), t.pageSidebarLight && $("#page-container").removeClass("page-with-light-sidebar"), t.pageSidebarRight && $("#page-container").removeClass("page-with-right-sidebar"), t.pageSidebarWide && $("#page-container").removeClass("page-with-wide-sidebar"), t.pageSidebarMinified && $("#page-container").removeClass("page-sidebar-minified"), t.pageSidebarTransparent && $("#sidebar").removeClass("sidebar-transparent"), t.pageContentFullWidth && $("#content").removeClass("content-full-width"), t.pageContentInverseMode && $("#content").removeClass("content-inverse-mode"), t.pageBoxedLayout && $("body").removeClass("boxed-layout")
    },
    handleToggleNavbarSearch = function () {
        $('[data-toggle="navbar-search"]').click(function (t) {
            t.preventDefault(), $(".header").addClass("header-search-toggled")
        }), $('[data-dismiss="navbar-search"]').click(function (t) {
            t.preventDefault(), $(".header").removeClass("header-search-toggled")
        })
    },
    convertNumberWithCommas = function (t) {
        return t.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")
    },
    checkIsFloat = function (t) {
        return Number(t) === t && t % 1 != 0
    },
    checkIsInt = function (t) {
        return Number(t) === t && t % 1 == 0
    },
    countDecimals = function (t) {
        var e = t.toString().split(".");
        return e[1] ? e[1].length : 0
    },
    handleAnimation = function () {
        $("[data-animation]").each(function () {
            var t = $(this).attr("data-animation"),
                e = $(this).attr("data-value");
            switch (t) {
                case "width":
                    $(this).css("width", e);
                    break;
                case "height":
                    $(this).css("height", e);
                    break;
                case "number":
                    for (var i = this, n = countDecimals(e), s = 1, o = n; 0 < o;) s *= 10, o--;
                    $({
                        animateNumber: 0
                    }).animate({
                        animateNumber: e
                    }, {
                        duration: 1e3,
                        easing: "swing",
                        step: function () {
                            var t = (Math.ceil(this.animateNumber * s) / s).toFixed(n);
                            t = convertNumberWithCommas(t);
                            $(i).text(t)
                        },
                        done: function () {
                            $(i).text(convertNumberWithCommas(e))
                        }
                    });
                    break;
                case "class":
                    $(this).addClass(e)
            }
        })
    },
    handleSidebarSearch = function () {
        $(document).on("keyup", '[data-sidebar-search="true"]', function () {
            var e = $(this).val();
            (e = e.toLowerCase()) ? ($(".sidebar:not(.sidebar-right) .nav > li:not(.nav-profile):not(.nav-header):not(.nav-search), .sidebar:not(.sidebar-right) .sub-menu > li").addClass("d-none"), $(".sidebar:not(.sidebar-right) .has-text").removeClass("has-text"), $(".sidebar:not(.sidebar-right) .expand").removeClass("expand"), $(".sidebar:not(.sidebar-right) .nav > li:not(.nav-profile):not(.nav-header):not(.nav-search) > a, .sidebar .sub-menu > li > a").each(function () {
                var t = $(this).text(); - 1 < (t = t.toLowerCase()).search(e) && ($(this).closest("li").removeClass("d-none"), $(this).closest("li").addClass("has-text"), 0 != $(this).closest("li.has-sub").length && $(this).closest("li.has-sub").find(".sub-menu li.d-none").removeClass("d-none"), 0 != $(this).closest(".sub-menu").length && ($(this).closest(".sub-menu").css("display", "block"), $(this).closest(".has-sub").removeClass("d-none").addClass("expand"), $(this).closest(".sub-menu").find("li:not(.has-text)").addClass("d-none")))
            })) : ($(".sidebar:not(.sidebar-right) .nav > li:not(.nav-profile):not(.nav-header):not(.nav-search).has-sub .sub-menu").removeAttr("style"), $(".sidebar:not(.sidebar-right) .nav > li:not(.nav-profile):not(.nav-header):not(.nav-search), .sidebar:not(.sidebar-right) .sub-menu > li").removeClass("d-none"), $(".sidebar:not(.sidebar-right) .expand").removeClass("expand"))
        })
    },
    App = function () {
        "use strict";
        var e;
        return {
            init: function (t) {
                t && (e = t), this.initLocalStorage(), this.initSidebar(), this.initTopMenu(), this.initComponent(), this.initThemePanel(), this.initPageLoad(), $(window).trigger("load"), e && e.ajaxMode && this.initAjax()
            },
            settings: function (t) {
                t && (e = t)
            },
            initSidebar: function () {
                handleSidebarMenu(), handleMobileSidebarToggle(), handleSidebarMinify(), handleSidebarMinifyFloatMenu(), handleToggleNavProfile(), handleToggleNavbarSearch(), handleSidebarSearch(), e && (!e || e.disableSidebarScrollMemory) || handleSidebarScrollMemory()
            },
            initSidebarSelection: function () {
                handleClearSidebarSelection()
            },
            initSidebarMobileSelection: function () {
                handleClearSidebarMobileSelection()
            },
            initTopMenu: function () {
                handleUnlimitedTopMenuRender(), handleTopMenuSubMenu(), handleMobileTopMenuSubMenu(), handleTopMenuMobileToggle()
            },
            initPageLoad: function () {
                handlePageContentView()
            },
            initComponent: function () {
                e && (!e || e.disableDraggablePanel) || handleDraggablePanel(), handleIEFullHeightContent(), handleSlimScroll(), handleUnlimitedTabsRender(), handlePanelAction(), handleScrollToTopButton(), handleAfterPageLoadAddClass(), handlePageScrollClass(), handleAnimation(), 767 < $(window).width() && handelTooltipPopoverActivation()
            },
            initLocalStorage: function () {
                e && (!e || e.disableLocalStorage) || handleLocalStorage()
            },
            initThemePanel: function () {
                handleThemePageStructureControl(), handleThemePanelExpand(), handleResetLocalStorage()
            },
            initAjax: function () {
                handleAjaxMode(e), $.ajaxSetup({
                    cache: !0
                })
            },
            setPageTitle: function (t) {
                document.title = t
            },
            setPageOption: function (t) {
                handleSetPageOption(t)
            },
            clearPageOption: function (t) {
                handleClearPageOption(t)
            },
            restartGlobalFunction: function () {
                this.initLocalStorage(), this.initTopMenu(), this.initComponent()
            },
            scrollTop: function () {
                $("html, body").animate({
                    scrollTop: $("body").offset().top
                }, 0)
            }
        }
    }();
