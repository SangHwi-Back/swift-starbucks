package com.sanghwiback.beckbucks.mainscreen

import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.pager.HorizontalPager
import androidx.compose.foundation.pager.rememberPagerState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.FavoriteBorder
import androidx.compose.material.icons.outlined.LocationOn
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.FilledTonalButton
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextDecoration
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.sanghwiback.beckbucks.R

@Preview(showBackground = true)
@Composable
fun MainQuickOrderSection(modifier: Modifier = paddingModifier) {
    val pagerState = rememberPagerState(0) { quickOrderItems.size }
    Column(modifier = modifier) {
        HorizontalPager(
            state = pagerState,
            contentPadding = PaddingValues(end = 40.dp),
            pageSpacing = 8.dp,
        ) { page ->
            MenuCard(quickOrderItems[page])
        }
    }
}

@Composable
private fun MenuCard(model: MenuCardModel) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .background(Color.White, RoundedCornerShape(12.dp))
            .border(1.dp, Color(0xFFE0E0E0), RoundedCornerShape(12.dp))
            .clip(RoundedCornerShape(12.dp))
            .padding(horizontal = 16.dp, vertical = 14.dp)
    ) {
        // 상단: 이미지 + 메뉴명/옵션 + 하트 아이콘
        Row(
            modifier = Modifier.fillMaxWidth(),
            verticalAlignment = Alignment.CenterVertically,
        ) {
            Image(
                painter = painterResource(model.imageId),
                contentDescription = null,
                contentScale = ContentScale.Crop,
                modifier = Modifier
                    .size(60.dp)
                    .clip(CircleShape)
            )
            Spacer(modifier = Modifier.width(12.dp))
            Column(modifier = Modifier.weight(1f)) {
                Text(
                    text = model.name,
                    fontSize = 15.sp,
                    fontWeight = FontWeight.Bold,
                )
                Spacer(modifier = Modifier.height(4.dp))
                val optionText = when (val option = model.menuOption) {
                    is MenuOption.Beverage -> buildList {
                        add(option.temperature.name)
                        add(option.size.name)
                        add(option.cup.name)
                        model.personalOption.coffee?.let { add("에스프레소 샷 ${it.numberOfShots}") }
                    }.joinToString(" | ")
                    is MenuOption.Food -> "${option.heating.name} | ${option.packaging.name}"
                }
                Text(
                    text = optionText,
                    fontSize = 12.sp,
                    color = Color.Gray,
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis,
                )
            }
            Icon(
                imageVector = Icons.Outlined.FavoriteBorder,
                contentDescription = "찜",
                tint = Color.Gray,
                modifier = Modifier
                    .padding(start = 8.dp)
                    .size(22.dp)
            )
        }

        Spacer(modifier = Modifier.height(12.dp))
        HorizontalDivider(color = Color(0xFFEEEEEE))

        // 하단: 매장명 + 주문 버튼
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .height(52.dp),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.SpaceBetween,
        ) {
            Row(verticalAlignment = Alignment.CenterVertically) {
                Icon(
                    imageVector = Icons.Outlined.LocationOn,
                    contentDescription = null,
                    tint = Color.Gray,
                    modifier = Modifier.size(16.dp)
                )
                Spacer(modifier = Modifier.width(2.dp))
                Text(
                    text = "의정부공원",
                    fontSize = 13.sp,
                    color = Color.Gray,
                    textDecoration = TextDecoration.Underline,
                )
            }
            FilledTonalButton(
                onClick = {},
                modifier = Modifier.height(38.dp),
                shape = RoundedCornerShape(50),
                contentPadding = PaddingValues(horizontal = 16.dp, vertical = 0.dp),
                colors = ButtonDefaults.filledTonalButtonColors(
                    containerColor = Color.Black,
                ),
            ) {
                Text(
                    text = "바로 주문하기",
                    fontSize = 12.sp,
                    color = Color.White,
                    fontWeight = FontWeight.SemiBold,
                )
            }
        }
    }
}

data class MenuCardModel(
    val imageId: Int,
    val name: String,
    val menuOption: MenuOption,
    val personalOption: PersonalOption
)

sealed class MenuOption {
    data class Beverage(
        val temperature: Temperature,
        val size: Size,
        val cup: CupOption,
    ) : MenuOption() {
        enum class Size { Grande, Tall, Short }
        enum class Temperature { Hot, Ice }
        enum class CupOption { Owned, Instant }
    }

    data class Food(
        val heating: Heating,
        val packaging: Packaging,
    ) : MenuOption() {
        enum class Heating { Warm, Cold }
        enum class Packaging { HereToUse, TakeOut }
    }
}

data class PersonalOption(
    val coffee: Coffee? = null,
    val syrup: Syrup? = null,
    val base: Base? = null
) {
    data class Coffee(
        val numberOfShots: Int = 2,
    )

    data class Syrup(
        val vanilla: Int = 0,
        val hazelNut: Int = 0,
        val caramel: Int = 0,
    )

    data class Base(
        val type: Type,
        val isSmall: Boolean,
    ) {
        enum class Type { Water, Milk, }
    }
}

private val quickOrderItems = listOf(
    MenuCardModel(
        imageId = R.drawable.reserve_cold_brew,
        name = "카페 아메리카노",
        menuOption = MenuOption.Beverage(
            temperature = MenuOption.Beverage.Temperature.Hot,
            size = MenuOption.Beverage.Size.Tall,
            cup = MenuOption.Beverage.CupOption.Instant,
        ),
        personalOption = PersonalOption(
            coffee = PersonalOption.Coffee(numberOfShots = 2),
            base = PersonalOption.Base(type = PersonalOption.Base.Type.Water, isSmall = false)
        )
    ),
    MenuCardModel(
        imageId = R.drawable.reserve_cold_brew,
        name = "카페 라떼",
        menuOption = MenuOption.Beverage(
            temperature = MenuOption.Beverage.Temperature.Ice,
            size = MenuOption.Beverage.Size.Grande,
            cup = MenuOption.Beverage.CupOption.Instant,
        ),
        personalOption = PersonalOption(
            coffee = PersonalOption.Coffee(numberOfShots = 2),
            base = PersonalOption.Base(type = PersonalOption.Base.Type.Milk, isSmall = false)
        )
    ),
    MenuCardModel(
        imageId = R.drawable.reserve_cold_brew,
        name = "트위스트 에그 샌드위치",
        menuOption = MenuOption.Food(
            heating = MenuOption.Food.Heating.Warm,
            packaging = MenuOption.Food.Packaging.TakeOut,
        ),
        personalOption = PersonalOption()
    ),
    MenuCardModel(
        imageId = R.drawable.reserve_cold_brew,
        name = "뉴욕 치즈케이크",
        menuOption = MenuOption.Food(
            heating = MenuOption.Food.Heating.Cold,
            packaging = MenuOption.Food.Packaging.HereToUse,
        ),
        personalOption = PersonalOption()
    ),
    MenuCardModel(
        imageId = R.drawable.reserve_cold_brew,
        name = "바닐라 라떼",
        menuOption = MenuOption.Beverage(
            temperature = MenuOption.Beverage.Temperature.Hot,
            size = MenuOption.Beverage.Size.Grande,
            cup = MenuOption.Beverage.CupOption.Instant,
        ),
        personalOption = PersonalOption(
            coffee = PersonalOption.Coffee(numberOfShots = 1),
            syrup = PersonalOption.Syrup(vanilla = 2),
            base = PersonalOption.Base(type = PersonalOption.Base.Type.Milk, isSmall = false)
        )
    ),
)
