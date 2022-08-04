<?php

namespace Tests;
class MainTest
{
    public function run()
    {
        ob_start();
        require __DIR__ . '/../src/index.php';
        $result = ob_get_clean();
        $expectedSubstring = 'Hello, World';
        if (strpos($result, $expectedSubstring) === false) {
            throw new \Exception('MainTest: Failed to assert that string "' . $result . '" contains a substring "' . $expectedSubstring . '"');
        }
    }
}