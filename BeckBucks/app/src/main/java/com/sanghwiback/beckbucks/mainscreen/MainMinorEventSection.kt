package com.sanghwiback.beckbucks.mainscreen

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.height
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.unit.dp
import com.sanghwiback.beckbucks.R

@Composable
fun MainMinorEventSection(modifier: Modifier = paddingModifier) {
    Column(modifier) {
        BannerView(MainEventModel.Banner(
            imageId = R.drawable.dolce_cold_brew,
            background = Color(0xFFFFB6C1),
            title = EventTextModel("Event", Color(0xFFFF69B4), FontFamily.Serif),
            contents = EventTextModel("오전 11시 이후 이달의 샌드위치+음료 구매 시 2,000원 할인", Color.Black,
                FontFamily.SansSerif),
            bottomDescription = EventTextModel("2026. 4. 1 (수) - 4. 30 (목)", Color.Gray, FontFamily.Monospace)
        ))
        Spacer(Modifier.height(16.dp))
        BannerView(MainEventModel.Banner(
            imageId = R.drawable.dolce_cold_brew,
            background = Color(0xFF00FF00),
            title = EventTextModel("Event", Color(0xFF00FF00), FontFamily.Serif),
            contents = EventTextModel("다양한 샌드위치를 즐기고 아메리카노 쿠폰을 받아보세요!", Color.Black,
                FontFamily.SansSerif),
            bottomDescription = EventTextModel("2026. 4. 1 (수) - 4. 30 (목)", Color.Gray, FontFamily.Monospace)
        ))
        Spacer(Modifier.height(16.dp))
        BannerView(MainEventModel.Banner(
            imageId = R.drawable.dolce_cold_brew,
            background = Color.Cyan,
            title = EventTextModel("OAKLEY + STARBUCKS", Color.Black, FontFamily.Serif),
            contents = EventTextModel("OAKLEY\nCOMMUNITY\nRUNNING", Color.Black,
                FontFamily.SansSerif),
            bottomDescription = EventTextModel("2026. 5. 16 (토)", Color.Gray, FontFamily.Monospace)
        ))
    }
}

