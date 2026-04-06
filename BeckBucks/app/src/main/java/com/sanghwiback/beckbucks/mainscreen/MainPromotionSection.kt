package com.sanghwiback.beckbucks.mainscreen

import androidx.compose.foundation.horizontalScroll
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.rememberScrollState
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.sanghwiback.beckbucks.R

@Composable
fun MainPromotionSection(modifier: Modifier = paddingModifier) {
    val names = listOf(
        "바삭 피스타치오 바닐라 크림 콜드 브루", "돌체 콜드 브루",
        "니트로 콜드 브루", "니트로 바닐라 크림", "리저브 콜드 브루",
        "리저브 니트로", "서울 막걸리 콜드 브루"
    )
    val imageIds = listOf(
        R.drawable.crispy_pistachio_vanilla_cream_cold_brew, R.drawable.dolce_cold_brew,
        R.drawable.nitro_cold_brew, R.drawable.nitro_vanilla_cream, R.drawable.reserve_cold_brew,
        R.drawable.reserve_nitro, R.drawable.seoul_makgulri_cold_brew
    )
    val promotionModels = names.mapIndexed { i, name ->
        ProductViewCircleModel(name, imageIds[i])
    }
    val scrollState = rememberScrollState()

    Column(modifier) {
        Text(
            text = "Feel the Refreshing Spring Vibe",
            fontSize = 20.sp,
            fontWeight = FontWeight.ExtraBold,
            color = TextPrimary
        )
        Spacer(Modifier.height(4.dp))
        Text(
            text = "산뜻한 날 즐기기 좋은 새로운 음료로 리프레시하세요!",
            fontSize = 13.sp,
            color = TextSecondary
        )
        Spacer(Modifier.height(20.dp))
        Row(
            modifier = Modifier.horizontalScroll(scrollState),
            horizontalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            promotionModels.forEach { model ->
                ProductViewCircle(model)
            }
        }
    }
}
