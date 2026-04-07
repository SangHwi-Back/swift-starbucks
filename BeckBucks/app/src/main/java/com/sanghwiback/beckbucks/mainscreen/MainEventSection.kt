package com.sanghwiback.beckbucks.mainscreen

import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.pager.HorizontalPager
import androidx.compose.foundation.pager.rememberPagerState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.TextUnit
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.sanghwiback.beckbucks.R

// 카드 공통 외형: 좌우 margin → 높이 → clip 순서가 올바름
// (clip 이전에 padding을 먼저 적용해야 배경이 rounded rect 안에 들어옴)
private val cardModifier = Modifier
    .fillMaxWidth()
    .height(200.dp)
    .clip(RoundedCornerShape(12.dp))

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
                    title = TextModel("리저브와 함께 더 빛나는 하루의 순간", Color.Black, FontFamily.SansSerif),
                    contents = TextModel("제조 음료 포함 30,000원 이상 구매 시 리저브 손거울을 증정해 드립니다.", Color.Black, FontFamily.SansSerif),
                    bottomDescription = TextModel("소진시까지", Color.Gray, FontFamily.Monospace),
                ),
                MainEventModel.ImageBanner(R.drawable.event_banner_image_2, Color.LightGray)
            )
        )
        Spacer(Modifier.height(16.dp))
        EventPager(
            listOf(
                MainEventModel.Banner(
                    R.drawable.event_banner_normal_1, Color.Green,
                    title = TextModel("ONE MORE COFFEE", Color.White, FontFamily.Serif),
                    contents = TextModel("스타벅스 에어로카노와 스위트 밀크 커피도 특별한 가격에 한 잔 더 즐겨보세요!", Color.White, FontFamily.Serif),
                    bottomDescription = TextModel("2026.4.1 (수) ~ 6.30 (화)", Color.White, FontFamily.Serif)
                ),
                MainEventModel.ImageBanner(R.drawable.event_banner_image_3, Color.LightGray),
                MainEventModel.Banner(
                    R.drawable.event_banner_normal_3, Color.Blue,
                    title = TextModel("생활에 필요한 3가지 구독을 한 번에!", Color.Yellow, FontFamily.Serif),
                    contents = TextModel("T 우주패스 & 스타벅스 & 올리브영 & 이마트24", Color.Yellow, FontFamily.Serif),
                    bottomDescription = TextModel("자세한 유의사항은 상세 내용 확인", Color.White, FontFamily.Serif)
                ),
            )
        )
    }
}

@Composable
fun EventPager(models: List<MainEventModel>) {
    val pagerState = rememberPagerState(if (models.size > 1) 1 else 0) { models.size }
    HorizontalPager(pagerState) { page ->
        when (val model = models[page]) {
            is MainEventModel.Banner      -> BannerView(model)
            is MainEventModel.ImageBanner -> ImageBannerView(model)
        }
    }
}

// Banner: 좌측 텍스트 + 우측 이미지 (좁고 세로로 긴 비율)
@Composable
fun BannerView(model: MainEventModel.Banner) {
    Row(
        modifier = cardModifier.background(model.background),
        verticalAlignment = Alignment.CenterVertically
    ) {
        // 좌: 텍스트 영역 — 나머지 공간을 모두 차지
        Column(
            modifier = Modifier
                .weight(1f)
                .padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(4.dp)
        ) {
            Text(
                text = "EVENT",
                fontSize = 11.sp,
                fontWeight = FontWeight.Bold,
                color = StarbucksGreen,
                letterSpacing = 1.sp
            )
            ModelText(model.title,            fontSize = 15.sp, fontWeight = FontWeight.Bold,   maxLines = 2)
            ModelText(model.contents,         fontSize = 12.sp,                                 maxLines = 3)
            ModelText(model.bottomDescription,fontSize = 11.sp,                                 maxLines = 1)
        }
        // 우: 이미지 — 고정 폭(110dp), 카드 전체 높이를 채움
        Image(
            painter = painterResource(model.imageId),
            contentDescription = null,
            contentScale = ContentScale.Crop,
            modifier = Modifier
                .width(110.dp)
                .fillMaxHeight()
        )
    }
}

// ImageBanner: 배경 유무에 따라 두 가지 레이아웃
@Composable
fun ImageBannerView(model: MainEventModel.ImageBanner) {
    if (model.background == null) {
        // 배경 없음 → 이미지가 가로를 거의 채우며 200dp 높이를 꽉 채움
        Image(
            painter = painterResource(model.imageId),
            contentDescription = null,
            contentScale = ContentScale.Crop,
            modifier = cardModifier
        )
    } else {
        // 배경 있음 → 배경색을 깔고 이미지는 세로 크기에 맞춰 늘림
        Box(
            modifier = cardModifier.background(model.background),
            contentAlignment = Alignment.Center
        ) {
            Image(
                painter = painterResource(model.imageId),
                contentDescription = null,
                contentScale = ContentScale.FillHeight,
                modifier = Modifier.fillMaxHeight()
            )
        }
    }
}

@Composable
private fun ModelText(
    model: TextModel,
    fontSize: TextUnit = 13.sp,
    fontWeight: FontWeight = FontWeight.Normal,
    maxLines: Int = Int.MAX_VALUE
) {
    Text(
        text = model.text,
        color = model.color,
        fontFamily = model.font,
        fontSize = fontSize,
        fontWeight = fontWeight,
        maxLines = maxLines,
        overflow = TextOverflow.Ellipsis
    )
}

sealed class MainEventModel {
    data class Banner(
        val imageId: Int,
        val background: Color,
        val title: TextModel,
        val contents: TextModel,
        val bottomDescription: TextModel
    ) : MainEventModel()

    data class ImageBanner(
        val imageId: Int,
        val background: Color?
    ) : MainEventModel()
}

data class TextModel(
    val text: String,
    val color: Color,
    val font: FontFamily
)
