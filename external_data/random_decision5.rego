# This dummy policy makes a decision based on a number received from random.org service
# just to demonstrate possible usage of HTTP requests
# to fetch external data during policy evaluation.
# See <https://www.openpolicyagent.org/docs/latest/policy-reference/#http>

package terraform


random_number = num {
    request := {
        "url": "https://www.random.org/integers/?num=1&min=0&max=9&base=10&col=1&format=plain",
        "method": "GET"
    }
    response := http.send(request)
    response.status_code == 200
    num := to_number(trim(response.raw_body, "\n"))
}

deny[reason] {
    number := random_number
    number < 5

    reason := sprintf(
        "Unlucky you: got %d, but 5 or more is required",
        [number]
    )
}
