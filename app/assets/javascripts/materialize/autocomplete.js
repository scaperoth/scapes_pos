(function(a) {
    a.fn.autocomplete = function(b) {
        var c = {
            data: {}
        };
        return b = a.extend(c, b), this.each(function() {
            var c = a(this),
                d = b.data,
                e = c.closest(".input-field");
            if (!a.isEmptyObject(d)) {
                var f = a('<ul class="autocomplete-content dropdown-content"></ul>');
                e.length ? e.append(f) : c.after(f);
                var g = function(a, b) {
                    var c = b.find("img"),
                        d = b.text().toLowerCase().indexOf("" + a.toLowerCase()),
                        e = d + a.length - 1,
                        f = b.text().slice(0, d),
                        g = b.text().slice(d, e + 1),
                        h = b.text().slice(e + 1);
                    b.html("<span>" + f + "<span class='highlight'>" + g + "</span>" + h + "</span>"), c.length && b.prepend(c)
                };
                c.on("keyup", function(b) {
                    if (13 === b.which) return void f.find("li").first().click();
                    var e = c.val().toLowerCase();
                    if (f.empty(), "" !== e)
                        for (var h in d)
                            if (d.hasOwnProperty(h) && -1 !== h.toLowerCase().indexOf(e) && h.toLowerCase() !== e) {
                                var i = a("<li></li>");
                                d[h] ? i.append('<img src="' + d[h] + '" class="right circle"><span>' + h + "</span>") : i.append("<span>" + h + "</span>"), f.append(i), g(e, i)
                            }
                }), f.on("click", "li", function() {
                    c.val(a(this).text().trim()), c.trigger("change"), f.empty()
                })
            }
        })
    }
}( jQuery ));