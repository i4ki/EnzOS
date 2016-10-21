/**
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 *
 * EnzOS Operating System
 */

#include "EnzOS/vesa.h"

//asm("org 0x100");


int main(void);

void start(void)
{
        main();
}


void poke(unsigned seg, unsigned ofs, unsigned val)
{
  asm("push ds\n"
      "mov  ds, [bp + 4]\n"
      "mov  bx, [bp + 6]\n"
      "mov  ax, [bp + 8]\n"
      "mov  [bx], ax\n"
      "pop  ds");
}


int main(void) {
        BiosSetGfxMode(VMODE);
        text(0, 0, "EnzOS Operating System", BACK_BLACK | FORE_BRIGHT_WHITE);
}
