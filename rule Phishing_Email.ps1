rule Phishing_Email
{
    strings:
        $a = "verify your email" nocase
        $b = "account suspended" nocase
        $c = "click below to login" nocase
    condition:
        2 of ($a, $b, $c)
}

