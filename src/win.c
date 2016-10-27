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

#include "EnzOS/types.h"
#include "EnzOS/vesa.h"
#include "EnzOS/win.h"

void winInit(Win *w) {
        w->row = 0;
        w->column = 0;
        w->color = TERMCOLOR;
        w->borderColor = BACK_BLACK | FORE_BRIGHT_WHITE;

        memset(w->top, ' ', 80);
        memset(w->footer, ' ', 80);
}

void winRenderTop(Win *w) {
        uint8 i = 0;
        uint8 *tmp = "╔═══════════════════════════════════════════════════";

        putn(0, 0, tmp, strlen(tmp), w->borderColor);
        //putn(0, 1, w->top, VWIDTH-1, w->color);
}

void winRender(Win *w) {
        winRenderTop(w);
        putn(0, VHEIGHT-1, w->footer, VWIDTH-1, w->color);
}
