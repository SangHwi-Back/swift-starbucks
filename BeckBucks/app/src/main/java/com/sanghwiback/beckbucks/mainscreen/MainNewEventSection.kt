package com.sanghwiback.beckbucks.mainscreen

import androidx.compose.foundation.Image
import androidx.compose.foundation.horizontalScroll
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.sanghwiback.beckbucks.R

@Preview(showBackground = true)
@Composable
fun MainNewEventSection() {
    val scrollState = rememberScrollState(0)

    Column {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 20.dp, vertical = 16.dp),
            horizontalArrangement = Arrangement.SpaceBetween,
        ) {
            Text(
                text = "What's New",
                fontWeight = FontWeight.Bold,
                fontFamily = FontFamily.SansSerif,
                fontSize = 20.sp
            )
            Text(
                text = "See all",
                fontWeight = FontWeight.SemiBold,
                fontFamily = FontFamily.SansSerif,
                fontSize = 13.sp,
                color = Color(0xFF00A862)
            )
        }

        Row(Modifier
            .horizontalScroll(scrollState)
            .padding(bottom = 16.dp)
        ) {
            Spacer(Modifier.width(20.dp))
            whatsNewItems.forEach { item ->
                Column(
                    Modifier
                        .width(200.dp)
                        .padding(end = 16.dp)
                ) {
                    Image(
                        modifier = Modifier
                            .fillMaxWidth()
                            .aspectRatio(1.3f)
                            .clip(RoundedCornerShape(12.dp)),
                        painter = painterResource(item.imageId),
                        contentScale = ContentScale.Crop,
                        contentDescription = item.title
                    )
                    Spacer(Modifier.height(8.dp))
                    Text(
                        text = item.title,
                        fontFamily = FontFamily.SansSerif,
                        fontWeight = FontWeight.Bold,
                        fontSize = 14.sp,
                        maxLines = 1,
                        overflow = TextOverflow.Ellipsis
                    )
                    Spacer(Modifier.height(4.dp))
                    Text(
                        text = item.content,
                        fontFamily = FontFamily.SansSerif,
                        fontSize = 12.sp,
                        color = Color(0xFF666666),
                        maxLines = 2,
                        overflow = TextOverflow.Ellipsis
                    )
                }
            }
            Spacer(Modifier.width(20.dp))
        }
    }
}

data class WhatsNewItem(val imageId: Int, val title: String, val content: String)

val whatsNewItems = listOf(
    WhatsNewItem(R.drawable.whats_new_1, "Spring Cherry Blossom Latte", "Enjoy the floral taste of spring in every sip."),
    WhatsNewItem(R.drawable.whats_new_2, "Cold Brew Oat Milk", "Smooth cold brew paired with creamy oat milk."),
    WhatsNewItem(R.drawable.whats_new_3, "Matcha Frappuccino", "A refreshing blend of matcha and cream."),
    WhatsNewItem(R.drawable.whats_new_4, "Caramel Cloud Macchiato", "Light and dreamy layers of caramel espresso."),
    WhatsNewItem(R.drawable.whats_new_5, "Mango Dragonfruit Lemonade", "Tropical flavors for a bright summer day."),
    WhatsNewItem(R.drawable.whats_new_6, "Pistachio Latte", "Rich and nutty pistachio with velvety espresso."),
    WhatsNewItem(R.drawable.whats_new_7, "Brown Sugar Oat Shaken", "Shaken espresso with brown sugar and oat milk."),
    WhatsNewItem(R.drawable.whats_new_8, "Vanilla Sweet Cream Cold Brew", "Bold cold brew topped with sweet vanilla cream."),
    WhatsNewItem(R.drawable.whats_new_9, "Iced Toasted Vanilla Latte", "Toasty vanilla flavor over smooth iced espresso."),
    WhatsNewItem(R.drawable.whats_new_10, "Pumpkin Spice Latte", "The iconic fall favorite returns with warm spices."),
    WhatsNewItem(R.drawable.whats_new_11, "Chestnut Praline Latte", "Sweet praline and chestnut for a cozy winter treat."),
    WhatsNewItem(R.drawable.whats_new_12, "Peppermint Mocha", "Classic mocha meets cool peppermint for the holidays."),
    WhatsNewItem(R.drawable.whats_new_13, "Honey Oat Milk Latte", "Golden honey swirled into a creamy oat milk latte."),
    WhatsNewItem(R.drawable.whats_new_14, "Iced Brown Sugar Latte", "Sweet brown sugar layered over chilled espresso."),
    WhatsNewItem(R.drawable.whats_new_15, "Strawberry Acai Lemonade", "Bright and fruity blend of strawberry and lemon."),
    WhatsNewItem(R.drawable.whats_new_16, "Lavender Oat Milk Latte", "Floral lavender infused into silky oat milk."),
    WhatsNewItem(R.drawable.whats_new_17, "Coconut Milk Mocha Macchiato", "Rich mocha with a tropical coconut milk twist."),
    WhatsNewItem(R.drawable.whats_new_18, "Iced Passion Tango Tea", "Vibrant herbal tea served over refreshing ice."),
    WhatsNewItem(R.drawable.whats_new_19, "Nitro Cold Brew", "Silky smooth nitrogen-infused cold brew, straight from tap."),
    WhatsNewItem(R.drawable.whats_new_20, "Reserve Clover Brewed Coffee", "Rare single-origin beans brewed to perfection."),
)
