package com.sanghwiback.beckbucks.mainscreen

import androidx.compose.foundation.Image
import androidx.compose.foundation.horizontalScroll
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import com.sanghwiback.beckbucks.R

val paddingModifier = Modifier.padding(20.dp, 0.dp, 20.dp, 18.dp)

@Preview(showBackground = true)
@Composable
fun MainScreen() {
    Column {
        MainHeader()
        MainHeaderButtons(modifier = Modifier.padding(bottom = 18.dp))
        MainPromotionSection()
    }
}

@Composable
fun MainHeader(modifier: Modifier = paddingModifier) {
    Column(modifier) {
        Text("테스터님, 나를 위한\n다정한 시간을 가져보아요")
    }
}

@Composable
fun MainHeaderButtons(modifier: Modifier = paddingModifier) {
    val scrollState = rememberScrollState()
    Row(modifier.horizontalScroll(scrollState)) {
        for ((index, name) in listOf("Gold", "Coupon", "Pay", "Buddy Pass").withIndex()) {
            Button(
                onClick = {},
                modifier = Modifier
                    .padding(
                        start = if (index == 0) 20.dp else 8.dp,
                        end = if (index == 4) 20.dp else 8.dp),
                shape = ButtonDefaults.filledTonalShape,
            ) {
                Text(name)
            }
        }
    }
}

@Composable
fun MainPromotionSection(modifier: Modifier = paddingModifier) {
    val names: List<String> = listOf(
        "바삭 피스타치오 바닐라 크림 콜드 브루", "돌체 콜드 브루",
        "니트로 콜드 브루", "니트로 바닐라 크림", "리저브 콜드 브루",
        "리저브 니트로", "서울 막걸리 콜드 브루"
    )
    val imageNames = listOf(
        R.drawable.crispy_pistachio_vanilla_cream_cold_brew, R.drawable.dolce_cold_brew,
        R.drawable.nitro_cold_brew, R.drawable.nitro_vanilla_cream, R.drawable.reserve_cold_brew,
        R.drawable.reserve_nitro, R.drawable.seoul_makgulri_cold_brew
    )
    val promotionModels: List<ProductViewCircleModel> = names.withIndex().map { (index, name) ->
        ProductViewCircleModel(
            name,
            imageNames[index],
            Color(244, 194, 194))
    }
    val scrollState = rememberScrollState()
    Column(modifier) {
        Text(
            text = "Feel the Refreshing Spring Vibe",
            fontWeight = FontWeight.Black)
        Text("산뜻한 날 즐기기 좋은 새로운 음료로 리프레시하세요!")
        Row(Modifier.horizontalScroll(scrollState)) {
            for (model in promotionModels) {
                ProductViewCircle(model)
            }
        }
    }
}

@Composable
fun ProductViewCircle(model: ProductViewCircleModel) {
    Column {
        Image(
            painter = painterResource(model.imageId),
            contentDescription = "",
            modifier = Modifier.clip(CircleShape).size(200.dp))
        Text(
            text = model.name,
            modifier = Modifier.size(width = 200.dp, height = 40.dp),
            textAlign = TextAlign.Center
        )
    }
}

data class ProductViewCircleModel(
    val name: String,
    val imageId: Int,
    val backgroundColor: Color,
)