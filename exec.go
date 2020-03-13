/*
 *  The MIT License (MIT)
 *
 * Copyright 2020 Octavian Ionescu <itavyg.at.gmail.com>
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 *
 */

package go_helpers

import (
	"errors"
	"io/ioutil"
	"os/exec"
)

func ExecuteCommand(runDir *string, cmd string, args ...string) ([]byte, error) {
	c := exec.Command(cmd, args[:]...)
	if runDir != nil {
		c.Dir = *runDir
	}
	stderr, err := c.StderrPipe()
	if err != nil {
		return nil, err
	}
	stdout, err := c.StdoutPipe()
	if err != nil {
		return nil, err
	}

	if err := c.Start(); err != nil {
		return nil, err
	}
	slurpErr, _ := ioutil.ReadAll(stderr)
	slurpOut, _ := ioutil.ReadAll(stdout)
	if err := c.Wait(); err != nil {
		return nil, errors.New(string(slurpErr))
	}
	return slurpOut, nil
}
