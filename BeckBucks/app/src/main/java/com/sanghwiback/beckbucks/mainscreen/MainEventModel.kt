package com.sanghwiback.beckbucks.mainscreen

import androidx.compose.ui.graphics.Color

sealed class MainEventModel {
    data class Banner(
        val imageId: Int,
        val background: Color,
        val title: EventTextModel,
        val contents: EventTextModel,
        val bottomDescription: EventTextModel
    ) : MainEventModel()

    data class ImageBanner(
        val imageId: Int,
        val background: Color?
    ) : MainEventModel()
}