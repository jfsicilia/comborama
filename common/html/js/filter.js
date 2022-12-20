/*
*/
document.getElementsByClassName = function (cl) {
    var retnode = [];
    var elem = this.getElementsByTagName('*');
    for (var i = 0; i < elem.length; i++) {
        if ((' ' + elem[i].className + ' ').indexOf(' ' + cl + ' ') > -1) retnode.push(elem[i]);
    }
    return retnode;
};

/*
*/
function containsAll(txt, words) {
    var result = true;
    for (i = 0; i < words.length; i++) {
        if (txt.indexOf(words[i]) < 0) {
            result = false;
            break;
        }
    }
    return result;
}

/*
*/
function filterList() {
    var input, words, uls, li, a, i, txtValue, nNotHidde;
    input = document.getElementById("search_box");
    words = input.value.toUpperCase().split(" ");
    uls = document.getElementsByClassName("combos_list");
    for (i = 0; i < uls.length; i++) {
        li = uls[i].getElementsByTagName("li");
        nNotHidden = 0;
        for (j = li.length - 1; j >= 0; j--) {
            // If it is an <a> element, check if it must be filtered or not.
            if (li[j].firstChild.nodeName == "A") {
                a = li[j].getElementsByTagName("a")[0];
                //txtValue = a.textContent || a.innerText;
                txtValue = a.innerText.toUpperCase();
                if (containsAll(txtValue, words)) {
                    li[j].style.display = "";
                    nNotHidden++;
                } else {
                    li[j].style.display = "none";
                }
                // If it is not an <a> element, then must be a title. Titles will be showed, if at least one element below them has not been filtered out.
            } else {
                if (nNotHidden > 0) {
                    li[j].style.display = "";
                } else {
                    li[j].style.display = "none";
                }
                nNotHidden = 0;
            }
        }
    }
}
