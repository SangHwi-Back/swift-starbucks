package com.sanghwiback.beckbucks.mainscreen

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.height
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.sanghwiback.beckbucks.R

@Preview(showBackground = true)
@Composable
fun MainEventSection(modifier: Modifier = paddingModifier) {
    Column(modifier) {
        Text(
            text = "온라인에서 만나는 특별한 혜택!",
            fontSize = 22.sp,
            fontWeight = FontWeight.Bold
        )
        Spacer(Modifier.height(16.dp))
        EventPager(
            listOf(
                MainEventModel.ImageBanner(R.drawable.event_banner_image_1, Color.LightGray),
                MainEventModel.Banner(
                    R.drawable.event_banner_normal_2, Color.LightGray,
                    title = EventTextModel("리저브와 함께 더 빛나는 하루의 순간", Color.Black, FontFamily.SansSerif),
                    contents = EventTextModel("제조 음료 포함 30,000원 이상 구매 시 리저브 손거울을 증정해 드립니다.", Color.Black, FontFamily.SansSerif),
                    bottomDescription = EventTextModel("소진시까지", Color.Gray, FontFamily.Monospace),
                ),
                MainEventModel.ImageBanner(R.drawable.event_banner_image_2, Color.LightGray)
            )
        )
        Spacer(Modifier.height(16.dp))
        EventPager(
            listOf(
                MainEventModel.Banner(
                    R.drawable.event_banner_normal_1, Color.Green,
                    title = EventTextModel("ONE MORE COFFEE", Color.White, FontFamily.Serif),
                    contents = EventTextModel("스타벅스 에어로카노와 스위트 밀크 커피도 특별한 가격에 한 잔 더 즐겨보세요!", Color.White, FontFamily.Serif),
                    bottomDescription = EventTextModel("2026.4.1 (수) ~ 6.30 (화)", Color.White, FontFamily.Serif)
                ),
                MainEventModel.ImageBanner(R.drawable.event_banner_image_3, Color.LightGray),
                MainEventModel.Banner(
                    R.drawable.event_banner_normal_3, Color.Blue,
                    title = EventTextModel("생활에 필요한 3가지 구독을 한 번에!", Color.Yellow, FontFamily.Serif),
                    contents = EventTextModel("T 우주패스 & 스타벅스 & 올리브영 & 이마트24", Color.Yellow, FontFamily.Serif),
                    bottomDescription = EventTextModel("자세한 유의사항은 상세 내용 확인", Color.White, FontFamily.Serif)
                ),
            )
        )
    }
}

