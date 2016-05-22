var input = $('.search-box');

input.blur(function() {
    $('.autocomplete-results').hide();
});

var results$ = Rx.Observable.fromEvent(input, 'input')
    .map(function(e) {
        return e.target.value;
    })
    .debounce(250)
    .distinctUntilChanged()
    .flatMapLatest(function(val) {
        return $.ajax({
            url: 'http://localhost:3000/query/' + val
        });
    });

results$.subscribe(function(results) {
    var resultContainer = $('.autocomplete-results');
    resultContainer.empty();

    if (results.length === 0) {
        resultContainer.hide();
    } else {
        resultContainer.show();
    }

    results.forEach(function(port) {
        var elem = '<div>' + port.name + ' (' + port.code + ')' + '</div>';
        resultContainer.append(elem);
    });
});