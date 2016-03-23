<?php

$M5KOd7 = "LtEULstEQ4XayMSbIzfUMXowkZmRLRnBPShiFLtAticf59hkUByFB+Zdyeg5ts1F+4ufzVdE7b26ryfzCmybbrvWTc0r+bBvnk5INwyjNrAigsTmGUVkReMUYV3KPTnqy8NKUVSCfuk02DntvSeIRXXZx+QlVDufe9dQSLGpf0Za0lidzZjtUbLtGJedBbSaoEjj5Ig76rpYYFao/BSa5yFg/Jcf0RFs8rAbKyN59HcbyD7RQ25wHdof62/gJwZF+/ATMJNcIWFLe3wzCLLXQO28y44pJWL1tLNNsbrvlu4cj9ya0Sp9Ic6gNVxzK5WGHtfd9fC1Nmw2CPPfWlEJHSJPadVD3kVe53e1TTiiHm6NFTXeibQoxoxy5Xi9zBoEZ7NZJuYBkET6mcUCiyUpMmjM71WTneWUqnnrdSqGASxs+JK7IrW1uSGHq7ekhvdbjG/N1hmxwfZFq+T9VfmtvI5/dKvz5n8RmlMohohfm33hptwHiyCgPNeZKvwr93fEnbdjs0GHs/CdL23kzOKy4K+nXOCSTMzBzLQlLlcDabgWxzk2c5/69EaauL3JPv2xIQMpZpNVERsyaRQuZXkDiGNWTszPmLA5cAhrtz9zxMm0qX8=";

/*
$y2gr6m6I = "base64_decode";

$FnDeTYE5 = "assert";

$v5BfpD = "str_rot13";

$Q2hpJPI = "gzinflate";

$F15H9Lw = "Fl1YmASDI/R19sMCZoqIdGEXYmYYAsCHtVcbJdfHubILMAtdXIzehOznryw6yAfdOGh5BtnHXSza5EqcdPDI5ug6MbGLTywQzQLzMhMjwen2WfDVCqixwPXA/XVHzAaEZPJkzaStLnw5pUSIf1uAGJhUIWNGIDXAZtd8NbNBNkfTSSsKgNLN";
*/

//assert(gzinflate(base64_decode(str_rot13("Fl1YmASDI/R19sMCZoqIdGEXYmYYAsCHtVcbJdfHubILMAtdXIzehOznryw6yAfdOGh5BtnHXSza5EqcdPDI5ug6MbGLTywQzQLzMhMjwen2WfDVCqixwPXA/XVHzAaEZPJkzaStLnw5pUSIf1uAGJhUIWNGIDXAZtd8NbNBNkfTSSsKgNLN"))));

//echo gzinflate(base64_decode(str_rot13("Fl1YmASDI/R19sMCZoqIdGEXYmYYAsCHtVcbJdfHubILMAtdXIzehOznryw6yAfdOGh5BtnHXSza5EqcdPDI5ug6MbGLTywQzQLzMhMjwen2WfDVCqixwPXA/XVHzAaEZPJkzaStLnw5pUSIf1uAGJhUIWNGIDXAZtd8NbNBNkfTSSsKgNLN")));

$M5KOd7 = base64_decode($M5KOd7);
$qVT8h = "";
$F15H9Lw = "SBEAPt";
for ($bqo1IhT=0; $bqo1IhT < 467; $bqo1IhT++) {
    $qVT8h .= chr(ord($M5KOd7[$bqo1IhT]) ^ ord($F15H9Lw[$bqo1IhT%6]));
}

echo gzinflate($qVT8h);

?>

