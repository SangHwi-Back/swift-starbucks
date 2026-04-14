package com.sanghwiback.beckbucks.mainscreen

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp

// ── 패키지 공용 색상 ──────────────────────────────────────────────────────────
internal val StarbucksGreen = Color(0xFF00704A)
internal val TextPrimary    = Color(0xFF1E1E1E)
internal val TextSecondary  = Color(0xFF767676)
internal val BorderDefault  = Color(0xFFCCCCCC)

// ── 패키지 공용 패딩 Modifier ─────────────────────────────────────────────────
val paddingModifier = Modifier.padding(start = 20.dp, end = 20.dp, bottom = 18.dp)

// ─────────────────────────────────────────────────────────────────────────────
@Preview(showBackground = true)
@Composable
fun MainScreen() {
    Column(Modifier.verticalScroll(rememberScrollState())) {
        MainHeader()
        MainHeaderButtons()
        MainPromotionSection()
        MainEventSection()
        MainQuickOrderSection()
        MainMinorEventSection()
        MainNewEventSection()
    }
}